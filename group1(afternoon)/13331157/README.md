# hw5-start-top

http://my.ss.sysu.edu.cn/wiki/display/SPSP/Lab+04.+Asynchronous+JavaScript
http://my.ss.sysu.edu.cn/wiki/display/SPSP/Lab+05.+Start+TOP

### install & run：
1. 安装node.js, 请确保你的node.js为0.10.x版本, 而不是最新版的0.12.x
2. 命令行输入 npm install -g grunt-cli
3. 进入文件目录, 命令行输入: npm install
4. 命令行输入: grunt watch
5. 用浏览器打开http://localhost:3000/Sx/index.html
6. 如果在你的PC上无法运行，请联系QQ 1262213295进行解决


### 自顶向下:
```c
S1:

                   -----  set-status-as-waiting
                  |
                  |-----  set-status-as-done
                  |
click-on-button - |-----  set-other-as-disable ----  set-status-as-disable
                  |
                  |-----  set-other-as-enable  ----  set-status-as-enable
                  |
                  |-----  all-buttons-done
                  |
                   -----  make-bubble-enable

               ---- get-and-show-the-sum
info.click  - |
               ---- make-bubble-disable

                                   ---- set-status-as-enable
main.onmouseleave -- reset-all  - |
                                   ---- make-bubble-disable

S2:

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
info.click --|
              ---- make-bubble-disable

                                   ---- set-status-as-enable
main.onmouseleave -- reset-all -- |
                                   ---- make-bubble-disable

             ---- reset-all
apb.click --|
             ---- robot-auto-click

S3:

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
apb.click --|
             ---- robot-auto-click

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

S5:

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
apb.click --|
            |      ---- manager.get-sequence
             ---- |
                  |---- manager.show-sequence
                  |
                  |---- manager.start-click
                  |
                   ---- manager.set-order
```