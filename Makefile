#
# Simple Makefile
#
PROJECT = jsontools

VERSION = $(shell grep -m1 'Version = ' $(PROJECT).go | cut -d\"  -f 2)

BRANCH = $(shell git branch | grep '* ' | cut -d\  -f 2)

build: bin/jsoncols bin/jsonrange bin/xlsx2json bin/xlsx2csv

bin/jsoncols: jsontools.go cmds/jsoncols/jsoncols.go
	go build -o bin/jsoncols cmds/jsoncols/jsoncols.go 

bin/jsonrange: jsontools.go cmds/jsonrange/jsonrange.go
	go build -o bin/jsonrange cmds/jsonrange/jsonrange.go 

bin/xlsx2json: cmds/xlsx2json/xlsx2json.go
	go build -o bin/xlsx2json cmds/xlsx2json/xlsx2json.go

bin/xlsx2csv: cmds/xlsx2csv/xlsx2csv.go
	go build -o bin/xlsx2csv cmds/xlsx2csv/xlsx2csv.go

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
	env GOBIN=$(HOME)/bin go install cmds/jsonrange/jsonrange.go
	env GOBIN=$(HOME)/bin go install cmds/xlsx2json/xlsx2json.go
	env GOBIN=$(HOME)/bin go install cmds/xlsx2csv/xlsx2csv.go

dist/linux-amd64:
	env CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o dist/linux-amd64/jsoncols cmds/jsoncols/jsoncols.go
	env CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o dist/linux-amd64/jsonrange cmds/jsonrange/jsonrange.go
	env CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o dist/linux-amd64/xlsx2json cmds/xlsx2json/xlsx2json.go
	env CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o dist/linux-amd64/xlsx2csv cmds/xlsx2csv/xlsx2csv.go

dist/macosx-amd64:
	env CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -o dist/macosx-amd64/jsoncols cmds/jsoncols/jsoncols.go
	env CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -o dist/macosx-amd64/jsonrange cmds/jsonrange/jsonrange.go
	env CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -o dist/macosx-amd64/xlsx2json cmds/xlsx2json/xlsx2json.go
	env CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -o dist/macosx-amd64/xlsx2csv cmds/xlsx2csv/xlsx2csv.go

dist/windows-amd64:
	env CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o dist/windows-amd64/jsoncols.exe cmds/jsoncols/jsoncols.go
	env CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o dist/windows-amd64/jsonrange.exe cmds/jsonrange/jsonrange.go
	env CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o dist/windows-amd64/xlsx2json.exe cmds/xlsx2json/xlsx2json.go
	env CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o dist/windows-amd64/xlsx2csv.exe cmds/xlsx2csv/xlsx2csv.go

dist/raspbian-arm7:
	env CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=7 go build -o dist/raspbian-arm7/jsoncols cmds/jsoncols/jsoncols.go
	env CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=7 go build -o dist/raspbian-arm7/jsonrange cmds/jsonrange/jsonrange.go
	env CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=7 go build -o dist/raspbian-arm7/xlsx2json cmds/xlsx2json/xlsx2json.go
	env CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=7 go build -o dist/raspbian-arm7/xlsx2csv cmds/xlsx2csv/xlsx2csv.go

dist/raspbian-arm6:
	env CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=6 go build -o dist/raspbian-arm6/jsoncols cmds/jsoncols/jsoncols.go
	env CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=6 go build -o dist/raspbian-arm6/jsonrange cmds/jsonrange/jsonrange.go
	env CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=6 go build -o dist/raspbian-arm6/xlsx2json cmds/xlsx2json/xlsx2json.go
	env CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=6 go build -o dist/raspbian-arm6/xlsx2csv cmds/xlsx2csv/xlsx2csv.go


release: dist/linux-amd64 dist/macosx-amd64 dist/windows-amd64 dist/raspbian-arm7 dist/raspbian-arm6
	mkdir -p dist
	cp -v README.md dist/
	cp -v LICENSE dist/
	cp -v INSTALL.md dist/
	cp -v jsoncols.md dist/
	cp -v jsonrange.md dist/
	cp -v xlsx2json.md dist/
	cp -v xlsx2csv.md dist/
	zip -r $(PROJECT)-$(VERSION)-release.zip dist/

