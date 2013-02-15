SRC = out/pwgrid.md

HTML = $(SRC:.md=.html)

all:	$(HTML)

clean:
	rm -rf out

out/%.md:	*.py
	mkdir -p out
	./create_pwgrid.py > $@

%.html:	%.md Makefile css/*.css
	pandoc --standalone --self-contained -t html5 --css=css/pwgrid.css -o $@ $<
