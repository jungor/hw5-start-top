VPATH=src

index.html index.css index.js: index.jade index.sass index.ls
	sass --style expanded src/index.sass bin/assets/css/index.css
	lsc src/index.ls -o bin
	jade -P src/index.jade --out bin
	cp -r bin/* .

clean:
	rm -rf index.html index.js bin/index.html bin/index.js bin/assets/css/index.css bin/assets/css/index.css.map assets .sass-cache
