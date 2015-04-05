# SE-386 Lab 04 Live Coding Show

http://my.ss.sysu.edu.cn/wiki/display/SPSP/Lab+04.+Asynchronous+JavaScript

# install & run

1. 安装node.js
2. 【可选】在浏览器中安装livereload插件：http://feedback.livereload.com/knowledgebase/articles/86242-how-do-i-install-and-use-the-browser-extensions
3. npm install
4. grunt watch
5. 用浏览器打开http://localhost:8000/

=====================================

1、我的gruntfile.coffee只能运行grunt命令来对ls文件进行预编译，没有实现实时同步监听的grunt watch功能。
2、gruntfile.coffee是在老师的版本的基础上修改得来。
3、打开gruntfile.coffee，可以在最开头对x进行设置，设置想要预编译的文件夹的序号，设置完成后运行grunt命令，即可对x序号的文件夹内的ls文件进行预编译得到对应的js文件。
4、请在server.js的根目录下按lab4的运行方式打开服务器文件，默认port是3000。
5、请在运行grunt命令之前用npm install安装所需程序，需要装有node.js和npm。