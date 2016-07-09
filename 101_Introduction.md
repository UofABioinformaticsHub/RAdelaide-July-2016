# Introduction To R
Steve Pederson  
9 July 2016  



## Why use R?

- The main software/language used for analysis of biological data (along with Python)
- Can handle extremely large datasets  
- We can easily perform complex analytic procedures
- Many processes come as inbuilt functions  
- Huge user base of biological researchers

## Why use R? | Other Key Reasons

- Avoids common Excel pitfalls
- Reproducible Research

## Automatic Conversion | A common Excel problem

Excel is notorious for converting values from one thing to another inappropriately.

- Gene names are often converted to dates 
    - Septin genes (e.g. _SEPT9_)
    - "Deleted in Esophigeal Cancer 1" (_DEC1_)

- Genotypes can be converted into numeric values
    - A homozygote for the first allele (1/1)
    
In `R` we generally work with plain text files.
    
## Reproducible Research

- Research is littered with mistakes from Excel
- Studies have made Phase III trials
- _We have code to record and repeat our analysis_
- We can track errors more easily than if they are copy/paste errors

## Using R

>__With power comes great responsibility - Uncle Ben__
  
With this extra capability, we need to understand a little about:  

- Data Types  
- Data Structures  

Today we will start with:

- Reading data into R
- Manipulating and cleaning data
- Visualising data

-----
