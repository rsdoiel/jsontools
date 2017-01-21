#
# Simple Makefile
#
PROJECT = jsontools

VERSION = $(shell grep -m1 'Version = ' $(PROJECT).go | cut -d\"  -f 2)

BRANCH = $(shell git branch | grep '* ' | cut -d\  -f 2)

build: bin/jsoncols 

bin/jsoncols: jsontools.go cmds/jsoncols/jsoncols.go
	go build -o bin/jsoncols cmds/jsoncols/jsoncols.go 


website:
	./mk-website.bash

status:
	git status

save:
	git commit -am "Quick Save"
	git push origin $(BRANCH)

refresh:
	git fetch origin
	git pull origin $(BRANCH)

publish:
	./mk-website.bash
	./publish.bash

clean: 
	if [ -f index.html ]; then /bin/rm *.html;fi
	if [ -d bin ]; then /bin/rm -fR bin; fi
	if [ -d dist ]; then /bin/rm -fR dist; fi
	if [ -f $(PROJECT)-$(VERSION)-release.zip ]; then rm -f $(PROJECT)-$(VERSION)-release.zip; fi

install:
	env GOBIN=$(HOME)/bin go install cmds/jsoncols/jsoncols.go

dist/linux-amd64:
	env CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o dist/linux-amd64/jsoncols cmds/jsoncols/jsoncols.go

dist/macosx-amd64:
	env CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -o dist/macosx-amd64/jsoncols cmds/jsoncols/jsoncols.go

dist/windows-amd64:
	env CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o dist/windows-amd64/jsoncols.exe cmds/jsoncols/jsoncols.go

dist/raspbian-arm6:
	env CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=6 go build -o dist/raspbian-arm6/jsoncols cmds/jsoncols/jsoncols.go

dist:
	mkdir -p dist

dist/README.md: README.md
	cp -v README.md dist/

dist/LICENSE: LICENSE
	cp -v LICENSE dist/

dist/INSTALL.md: INSTALL.md
	cp -v INSTALL.md dist/

targets: dist/linux-amd64 dist/macosx-amd64 dist/windows-amd64 dist/raspbian-arm7 dist/raspbian-arm6

docs: dist dist/README.md dist/LICENSE dist/INSTALL.md

zip: $(PROJECT)-$(VERSION)-release.zip 
	zip -r $(PROJECT)-$(VERSION)-release.zip dist/

release: targets docs zip
