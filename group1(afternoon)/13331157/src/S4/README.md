```c
S4:

                   -----  set-status-as-waiting
                  |
                  |-----  set-status-as-done
                  |
                  |-----  set-other-as-disable ----  set-status-as-disable
click-on-button --|
                  |-----  set-other-as-enable  ----  set-status-as-enable
                  |
                  |-----  all-buttons-done
                  |
                   -----  make-bubble-enable

               ---- get-and-show-the-sum
info.click -- |
               ---- make-bubble-disable

                                   ---- set-status-as-enable
main.onmouseleave -- reset-all -- |
                                   ---- make-bubble-disable

             ---- reset-all
apb.click --|                           ---- generate-sequence
             ---- robot-auto-click  -- |
                                        ---- show-sequence
```