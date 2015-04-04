VPATH=src

index.html index.css: index.jade index.sass
	jade -P src/index.jade --out bin/
	sass --style expanded src/index.sass bin/assets/css/index.css
