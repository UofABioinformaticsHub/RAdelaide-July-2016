# Getting More Out Of Functions
Steve Pederson  
21 July 2016  



# Getting More Out Of Functions

## Revisiting `myMean()`

Our previous approach was highly effective.


```r
?sum
```

Note that this function has an `na.rm` argument already

What does the  `...` mean?

## The ellipsis

In `R` the ellipsis (`...`) is used to pass unspecified arguments down to other functions

- _Very flexible_, but can get confusing


```r
myMean<- function(x, ...){
  total <- sum(x, ...)
  n <- sum(!is.na(x))
  mn <- total/n
  mn
}
```

## The ellipsis

If we now call `myMean()`:


```r
testVec <- c(NA, 1:10)
myMean(testVec, na.rm = TRUE)
```

```
## [1] 5.5
```

__It works!!!__

We need to specify these arguments by name

## The ellipsis

If calling a function with an `...` argument:

- We can pass down named arguments to lower-level functions
- The exception is when `...` is the first argument


```r
?plot
```

# A Bigger Challenge

## Today's Data

In `Day_2/data` is a file `snps.csv`


```r
library(readr)
library(dplyr)
snps <- read_csv("data/snps.csv")
dim(snps)
```

```
## [1]  104 2001
```

## Today's Data

Here we have genotypes coded as `AA`,`AB` or `BB` for 2000 SNP alleles

How many samples and populations do we have?

## Today's Data

Here we have genotypes coded as `AA`,`AB` or `BB` for 2000 SNP alleles


```r
snps %>%
  group_by(Population) %>%
  summarise(n = n())
```

```
## # A tibble: 2 x 2
##   Population     n
##        <chr> <int>
## 1    Control    53
## 2      Treat    51
```

## Our Task

Write a function that performs a Fisher's Exact Test on each allele

For each SNP, we need to:

1. Form a 3 $\times$ 2 table
2. Perform the test
3. Format our output into a `data_frame` (or `tibble`)

---

<div class="footer" style="text-align:center;width:25%">
[Home](http://uofabioinformaticshub.github.io/RAdelaide-July-2016/)
</div>
