run:
	./mvs < book.txt

prompt:
	./mvs 2 100 'There is' < book.txt

susam:
	./mvs < susam.txt

filter-website:
	if ! [ -d /tmp/susam/ ]; then \
	  git clone --depth 1 https://github.com/susam/susam.net.git /tmp/susam; \
	fi
	find /tmp/susam/content/ -name '*.html' \
	  ! -path 'content/guestbook/guestbook.html' \
	  ! -path '*/comments/*' \
	  ! -path 'content/licence/mit.html' \
	  -exec cat {} + | \
	sed '\
	  /<script>/,/<\/script>/d; \
	  /<style>/,/<\/style>/d; \
	' | \
	tr -s ' \n' ' ' | \
	sed ' \
	  s/<[^>]*>//g; \
	  s/&[mn]dash;/-/g; \
	  s/&amp;/\&/g; \
	  s/&gt;/>/g; \
	  s/&lt;/</g; \
	  s/&nbsp;/ /g; \
	  s/\\(//g; \
	  s/\\)//g; \
	  s/\\\[//g; \
	  s/\\\]//g; \
	  s/\\{/{/g; \
	  s/\\}/}/g; \
	  s/\\begin{[^}]*}//g; \
	  s/\\end{[^}]*}//g; \
	  s/\\ge/>=/g; \
	  s/\\gt/>/g; \
	  s/\\in/in/g; \
	  s/\\ldots/.../g; \
	  s/\\le/<=/g; \
	  s/\\left(//g; \
	  s/\\lt/</g; \
	  s/\\mathbb{\([^}]*\)}/\1/g; \
	  s/\\right)//g; \
	  s/\\text{\([^}]\)}/\1/g; \
	' > susam.txt

book:
	curl -sSL -o dl.txt https://www.gutenberg.org/cache/epub/46/pg46.txt
	sed -n '/START OF .* GUTENBERG/,/END OF .* GUTENBERG/p' dl.txt | sed '1d;$d' > book.txt

wc:
	grep '[[:graph:]]' mvs | grep -v '^#' | wc -l

lint: readme
	python3 -m venv venv/
	venv/bin/pip3 install ruff mypy
	venv/bin/ruff check --select ALL --ignore ANN001,D100,D103,D211,D213,F401,I001,PLR2004,PTH123,S311,SIM115,T201 mvs
	venv/bin/ruff format --diff mvs
	venv/bin/mypy mvs

readme:
	sed -n '1,/^```python3$$/p' README.md > tmp.md
	cat mvs >> tmp.md
	sed -n '/^```$$/,$$p' README.md >> tmp.md
	mv tmp.md README.md

REPO = mvs

push:
	git remote remove origin
	git remote remove cb
	git remote add origin git@github.com:susam/mvs.git
	git remote add origin git@codeberg.org:susam/mvs.git
	git push origin --all
	git push origin --tags
	git push cb --all
	git push cb --tags
