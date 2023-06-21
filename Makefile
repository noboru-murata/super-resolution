.SUFFIXES: .tex .dvi .pdf

NAME 	= $(shell head -1 README.org | tr -d '*[:space:]')
# NAME 	= online-learning
ORG	= slide.org
TEX	= $(ORG:%.org=%.tex)
PDF	= $(ORG:%.org=%.pdf)
SUB	= $(shell ls main/*.tex)
GIF 	= thumbnail.gif

HUGO	= $(HOME)/Desktop/hugo/official/static

RSYNC	= /usr/bin/rsync -auv --delete \
		--exclude='.*' --exclude='*~' --exclude='_*'

MSG	= $(shell head -1 VERSION)
# to overwrite MGS, try make MSG="xxx" 

all:	$(PDF)

pdf:
	latexmk $(TEX)

clean:
	latexmk -C $(TEX)

view:
	open $(PDF)

# sync to hugo directory
hugo:
	$(RSYNC) $(PDF) $(HUGO)/pdfs/$(NAME).pdf
	$(RSYNC) $(GIF) $(HUGO)/pdfs/$(NAME).gif

thumbnail:
	convert -density 150 -delay 100 slide.pdf -thumbnail "600x600>" thumbnail.gif 

delay:
	mogrify -loop 0 -delay 200 thumbnail.gif

git-add:
	git add $(ORG) $(TEX) $(PDF)

push:
	git add -u
	git commit -m "${MSG}"
	git push -u origin main

stat:
	git status
