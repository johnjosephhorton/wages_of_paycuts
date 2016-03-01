# Notes

This is the associated code for my paper .
Forthcoming at ISR. 
A draftn of the paper is available at:

1. My website: [http://www.john-joseph-horton.com/papers/wages_of_paycuts.pdf](http://www.john-joseph-horton.com/papers/wages_of_paycuts.pdf)

## Citation Info

```
```

## Replication

The repository is set up to make it transparent how the final PDF is constructed from the raw data. 
To replicate, you will need a Linux or Mac OX machine that has the following installed:

1. `R`
1. `pdflatex`
1. `make`
1. `gpg`
1. `curl`
1. `gs` (GhostScript)

To replicate the data analysis, you will need several R packages.
However, when you run the code below, it *should* obtain all these R-specific dependencies you need. 

Note that this repository does not contain the actual experimental data.
To obtain the data, email me at `john.joseph.horton@gmail.com` and I will email you two small text files.
These files have the information you need to download and unencrypt the data. 

One you have the two files, the steps are:

####Download the repository from github
```
 git clone git@github.com:johnjosephhorton/wages_of_paycuts.git 
```
#### Add the text files to the repository
Move the two files I sent you into the `/wages_of_paycuts` directory.
For example, if you download them to you downloads folder, you might run
```
cp ~/Downloads/*txt ~/wages_of_paycuts
```
The two files are: 
```
data_passphrase.txt
data_url.txt
```
#### Build the PDF
From `/wages_of_paycuts`, run: 
```
cd writeup
make wages_of_paycuts.pdf
```
This should download the necessary data files and decrypt them.
It will also run the statistical analysis in R (downloading all needed packages) and then produce plots and tables (stored in `writeup/tables` and `writeup/plots`). 
Finally, it will build the pdf file using `pdflatex`, leaving the resultant `wages_of_paycuts.pdf` in the `/writing` folder.
To see the actual steps that are being followed, you can inspect `writeup\Makefile`.

If you run into any trouble replicating, please contact me at ``john.joseph.horton@gmail.com``. 
