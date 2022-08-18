all:

format:
	fd -t f -e lua -p0 | xargs -0 stylua

lint:
	fd -t f -e lua -p0 | xargs -0 selene
