# Notes

This is the associated code for my paper with Daniel Chen:

## Citation Info

```
@article{chen2016online,
  title={Are Online Labor Markets Spot Markets for Tasks?: A Field Experiment on the Behavioral Response to Wage Cuts},
  author={Chen, Daniel L and Horton, John J},
  journal={Information Systems Research},
  year={Forthcoming}
}
```

A draft of the paper is available at:

1. My website: [http://www.john-joseph-horton.com/papers/wages_of_paycuts.pdf](http://www.john-joseph-horton.com/papers/wages_of_paycuts.pdf)

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

#### Build the PDF
From `/wages_of_paycuts`, run: 
```
cd writeup
make -B wages_of_paycuts.pdf
```

If you run into any trouble replicating, please contact me at ``john.joseph.horton@gmail.com``. 
