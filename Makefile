run:
	python3 mvs.py

prompt:
	python3 mvs.py 2 100 'There is'

book:
	curl -sSL -o dl.txt https://www.gutenberg.org/cache/epub/46/pg46.txt
	sed -n '/START OF .* GUTENBERG/,/END OF .* GUTENBERG/p' dl.txt | sed '1d;$d' > book.txt

wc:
	grep '[[:graph:]]' mvs.py | grep -v '^#' | wc -l

lint: readme
	python3 -m venv venv/
	venv/bin/pip3 install ruff mypy
	venv/bin/ruff check --select ALL --ignore ANN001,D100,D103,D211,D213,F401,I001,PLR2004,PTH123,S311,SIM115,T201
	venv/bin/ruff format --diff
	venv/bin/mypy .

readme:
	sed -n '1,/^```python3$$/p' README.md > tmp.md
	cat mvs.py >> tmp.md
	sed -n '/^```$$/,$$p' README.md >> tmp.md
	mv tmp.md README.md
