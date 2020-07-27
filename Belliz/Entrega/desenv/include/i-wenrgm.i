IF VALID-HANDLE(hWenController) THEN DO:
    &if "{&field1}" <> "" &then
        RUN registerWidgetEvent IN hWenController ({&field1}:HANDLE, "{&event1}").
    &endif
    &if "{&field2}" <> "" &then
        RUN registerWidgetEvent IN hWenController ({&field2}:HANDLE, "{&event2}").
    &endif
    &if "{&field3}" <> "" &then
        RUN registerWidgetEvent IN hWenController ({&field3}:HANDLE, "{&event3}").
    &endif
    &if "{&field4}" <> "" &then
        RUN registerWidgetEvent IN hWenController ({&field4}:HANDLE, "{&event4}").
    &endif
    &if "{&field5}" <> "" &then
        RUN registerWidgetEvent IN hWenController ({&field5}:HANDLE, "{&event5}").
    &endif
    &if "{&field6}" <> "" &then
        RUN registerWidgetEvent IN hWenController ({&field6}:HANDLE, "{&event6}").
    &endif
    &if "{&field7}" <> "" &then
        RUN registerWidgetEvent IN hWenController ({&field7}:HANDLE, "{&event7}").
    &endif
    &if "{&field8}" <> "" &then
        RUN registerWidgetEvent IN hWenController ({&field8}:HANDLE, "{&event8}").
    &endif
    &if "{&field9}" <> "" &then
        RUN registerWidgetEvent IN hWenController ({&field9}:HANDLE, "{&event9}").
    &endif
    &if "{&field10}" <> "" &then
        RUN registerWidgetEvent IN hWenController ({&field10}:HANDLE, "{&event10}").
    &endif
END.

