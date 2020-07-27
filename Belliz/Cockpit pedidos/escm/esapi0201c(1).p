DEF INPUT PARAM row-pedido       as ROWID no-undo.
def input param pe-quem-aprovou  like ped-venda.quem-aprovou no-undo.
def input param pe-dt-apr-cred   like ped-venda.dt-apr-cred  no-undo.
def input param c-pe-motivo      as char no-undo.
def input param c-pe-motivo-no  as char no-undo.
def input param l-ok             as log  no-undo.

def var c-opcao-mp       as char no-undo.

{cdp/cdapi013.i}  /* Definicoes das Temp-Tables da Avaliacao de Credito */ 
{cdp/cdapi300.i1}  /* Temp-Table de Erros   */

/* temp table rowErrors */
{method/dbotterr.i}
DEF VAR h-pdapi513e       AS HANDLE                   NO-UNDO.
DEF VAR h-bodi605         AS HANDLE                   NO-UNDO.
DEF VAR h-bodi159mps      AS HANDLE                   NO-UNDO.
DEF VAR h-bodi261         AS HANDLE                   NO-UNDO. 
DEF VAR h-bodi159cal      AS HANDLE                   NO-UNDO.
def var hShowMsg          as handle                   no-undo.
def var h-cdapi013        as handle                   no-undo.
def var i-seq-erro as integer no-undo.
DEF VAR l-inval-sit AS LOGICAL NO-UNDO.
DEF TEMP-TABLE tt-ped-item-cotas NO-UNDO
    FIELD nr-sequencia AS INT 
    FIELD it-codigo    AS CHAR
    FIELD cod-refer    AS CHAR.


find first param-global no-lock no-error.
FIND first para-ped no-lock no-error.  

DO:
    FIND FIRST ped-venda EXCLUSIVE-LOCK
    WHERE ROWID(ped-venda) = row-pedido NO-ERROR.

    IF NOT AVAIL ped-venda THEN
        LEAVE.    
  
    RUN pi-reprova.
  
    run cdp/cdapi013.p persistent set h-cdapi013 (input-output table tt-param-aval,
                                                  input-output table tt-erros-aval) .
    if valid-handle(h-cdapi013) then 
    do:
        empty temp-table tt-erros-aval.
        
        run pi-integra-mla in h-cdapi013 (input "CM0201":U,
                                          input ped-venda.nr-pedido,
                                          input 2).
        
        run piRetornaTTErrosAval in h-cdapi013 (output table tt-erros-aval).
        
        delete procedure h-cdapi013.
        
        if can-find(first tt-erros-aval) then do:
            assign i-seq-erro = 0.
            for each tt-erros-aval:
                run utp/ut-msgs.p ("msg", tt-erros-aval.cd-erro, "").
                create RowErrors.
                assign i-seq-erro                 = i-seq-erro + 1                       
                       RowErrors.ErrorSequence    = i-seq-erro
                       RowErrors.ErrorNumber      = tt-erros-aval.cd-erro
                       RowErrors.ErrorDescription = trim(return-value)
                       RowErrors.ErrorType        = "EMS":U
                       RowErrors.ErrorSubType     = "Error":U.
            end.
        end.
    
    end.

END.
       
PROCEDURE pi-reprova:
    MESSAGE "aquu" VIEW-AS ALERT-BOX.
       find current ped-venda EXCLUSIVE-LOCK NO-ERROR.
       if  ped-venda.cod-sit-ped = 3 then
           return.
       else 
           if  ped-venda.cod-sit-aval = 4 then
               return.
           else do:          
               assign ped-venda.desc-bloq-cr = c-pe-motivo-no
                      ped-venda.dt-apr-cred  = pe-dt-apr-cred
                      ped-venda.cod-sit-aval = 4 /* simula uma suspensÆo */
                      ped-venda.quem-aprovou = pe-quem-aprovou.

               IF NOT AVAIL para-ped THEN
                   FIND FIRST para-ped NO-LOCK NO-ERROR.

               IF SUBSTRING(para-ped.char-1,64,3) = "YES" THEN DO: /* Verifica se o parƒmetro de hist¢rico de pedido esta ativo no PD0301 */

                   IF NOT VALID-HANDLE(h-bodi605) THEN                                 
                      RUN dibo/bodi605.p PERSISTENT SET h-bodi605.                     
                                                                                      
                   RUN logCredito IN h-bodi605 (INPUT ped-venda.nr-pedcli,             
                                                INPUT ped-venda.nome-abrev).           
                                                                                      
                   IF VALID-HANDLE(h-bodi605) THEN DELETE PROCEDURE h-bodi605.
               END.

               IF NOT VALID-HANDLE(h-pdapi513e) THEN                               
                  RUN pdp/pdapi513e.p PERSISTENT SET h-pdapi513e.                  
                                                                                  
               RUN piMandaEmailCredito IN h-pdapi513e (INPUT ped-venda.nr-pedcli,  
                                                       INPUT ped-venda.nome-abrev).

               IF VALID-HANDLE(h-pdapi513e) THEN DELETE PROCEDURE h-pdapi513e.

               /* Atualiza‡Æo de Cotas */
               IF AVAIL param-global AND
                  param-global.modulo-08 THEN DO:

                  IF  NOT VALID-HANDLE(h-bodi261) OR 
                      h-bodi261:TYPE      <> "PROCEDURE":U OR 
                      h-bodi261:FILE-NAME <> "dibo/bodi261.p":U THEN 
                      RUN dibo/bodi261.p PERSISTENT SET h-bodi261 NO-ERROR.

                  IF ped-venda.cod-sit-com <> 1 THEN 
                     RUN setarLogAtualizacao IN h-bodi261.     
                  RUN atualizarCotasPedido IN h-bodi261(INPUT ROWID(ped-venda),
                                                        INPUT 1,
                                                        INPUT TABLE tt-ped-item-cotas). /* a bo verifica se est  
                                                                                           reprov por cr‚dito */
                  IF VALID-HANDLE(h-bodi261) THEN DO:
                     DELETE PROCEDURE h-bodi261.
                     ASSIGN h-bodi261 = ?.
                  END.    
               END.

               /* antigo cd4100*/
               IF  NOT VALID-HANDLE(h-bodi159cal) OR 
                   h-bodi159cal:TYPE      <> "PROCEDURE":U OR 
                   h-bodi159cal:FILE-NAME <> "dibo/bodi159cal.p":U THEN 
                   RUN dibo/bodi159cal.p PERSISTENT SET h-bodi159cal.
               RUN setInvoicingAvaiable in h-bodi159cal(INPUT ROWID(ped-venda)).
               IF VALID-HANDLE(h-bodi159cal) THEN DO:
                  DELETE PROCEDURE h-bodi159cal.
                  ASSIGN h-bodi159cal = ?.
               END.    


               ASSIGN c-opcao-mp = "Modifica". 
               if  not valid-handle(h-bodi159mps) or
                   h-bodi159mps:type      <> "PROCEDURE":U or
                   h-bodi159mps:file-name <> "dibo/bodi159mps.p":U then
                   run dibo/bodi159mps.p persistent set h-bodi159mps.
               run pi-transacao-mp in h-bodi159mps(input rowid(ped-venda),
                                                   input rowid(ped-venda),
                                                   input "ModificarPedido":U).

               if  valid-handle(h-bodi159mps) then do:
                   delete procedure h-bodi159mps.
                   assign h-bodi159mps = ?.
               end.     

           find current ped-venda NO-LOCK NO-ERROR.
           /**
           *** Integra‡äes: CRM
           **/
           RUN utp/ut-crm.p.  /* Verifica se possue integra‡Æo com CRM */
           IF  RETURN-VALUE = "YES":U THEN
               RUN adapters/neogrid/pdp/anepd016.p (INPUT rowid(ped-venda),
                                                    INPUT "CHANGE":U).
   end.

END PROCEDURE.
