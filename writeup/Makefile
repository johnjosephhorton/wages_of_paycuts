# These are the data files that the R package depends upon.
# If they are missing, then we need to run clean_data.R in the WageCutsR/data-raw folder.

project_name = wages_of_paycuts

ts := $(shell /bin/date "+%Y-%m-%d---%H-%M-%S")

# Get the data 
data_url_file := ../data_url.txt
data_url := $(shell cat ${data_url_file})

encrypted_data = ../code/WageCutsR/data-raw/replication.tar.gz.gpg
decrypted_data = ../code/WageCutsR/data-raw/replication.tar.gz
expanded_data = ../code/WageCutsR/data-raw/replication/wage_cuts.csv

$(encrypted_data): ../data_url.txt
	cd ../code/WageCutsR/data-raw/ && curl -o replication.tar.gz.gpg $(data_url)  	

$(decrypted_data): $(encrypted_data)
	cd ../code/WageCutsR/data-raw/ && gpg --passphrase-file ../../../data_passphrase.txt --batch replication.tar.gz.gpg

$(expanded_data): $(decrypted_data)
	cd ../code/WageCutsR/data-raw/ && tar -xvf replication.tar.gz && ./clean_data.R

# These are the tables used in the writeup 
tables =./tables/uptake_simple.tex ./tables/uptake_framing.tex ./tables/uptake_unframed.tex ./tables/error.tex ./tables/cor.tex ./tables/games.tex

# These are the figures used in the writup 
plots = ./plots/uptake.pdf

$(data):
	cd ../code/WageCutsR/data-raw; ./clean_data.R

$(tables) $(plots): $(data) $(expanded_data)
	cd ../code/R; ./$(project_name).R

$(project_name).pdf : $(project_name).tex $(project_name).bib $(tables) $(plots)
	pdflatex $(project_name)
	pdflatex $(project_name)
	bibtex $(project_name) 
	pdflatex $(project_name)
	pdflatex $(project_name)
	gs -q -dNOPAUSE -dBATCH -dPDFSETTINGS=/prepress -sDEVICE=pdfwrite -sOutputFile=tmp.pdf $(project_name).pdf
	mv tmp.pdf $(project_name).pdf 

clean: 
	rm *.blg 
	rm *.bbl 
	rm *.aux 
	rm *.out 
	rm *.log 
	rm *.pdf 
	rm *.ttt 
	rm *.fff
	rm *.lot
	rm *.log
	rm *.lof

website: $(project_name).pdf
	printf 'cd papers\nput $<\n' \ | sftp -oPort=2222 johnjhorton@john-joseph-horton.com

backup:
	tar --exclude='../backups' -zcvf ../backups/$(project_name)_$(ts).tar.gz ../

snapshot:
	@echo Timestamp is $(ts)
	cp $(project_name).pdf ../snapshots/$(project_name)_$(ts).pdf

