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
library(reshape2)
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

Write a function that performs a Fisher's Exact Test on each allele, comparing the allele structure across populations

For each SNP, we need to:

1. Form a 2 $\times$ 2 table
2. Perform the test
3. Format our output into a `data_frame` (or `tibble`)

## Starting Our Function

The best place to start is just working with a single SNP

__What information do we need?__

1. The Population Structure
2. The Genotypes


```r
fisherFun<- function(snp, pop){
  
}
```

## Writing Our Function | Forming The Table

Forming a table of alleles:

- Could use `group_by()` then `summarise()` `acast()`


```r
snps[1:2] %>% 
  group_by(Population, SNP1) %>% 
  summarise(count = n()) %>%
  filter(!is.na(SNP1)) %>%
  acast(Population~SNP1, value.var = "count")
```

```
##         AA AB BB
## Control 13 30 10
## Treat    8 19 21
```

## Writing Our Function | Forming The Table

Forming a table of genotypes:

- An easier way is to use `table()`


```r
table(snps$Population, snps$SNP1)
```

```
##          
##           AA AB BB
##   Control 13 30 10
##   Treat    8 19 21
```

## Writing Our Function | Forming The Table


```r
fisherFun<- function(snp, pop){
 genoTable <- table(pop, snp) 
 return(genoTable)
}
fisherFun(snps$SNP1, snps$Population)
```

```
##          snp
## pop       AA AB BB
##   Control 13 30 10
##   Treat    8 19 21
```

## Writing Our Function | Getting the Allele Frequencies


```r
fisherFun<- function(snp, pop){
 genoTable <- table(pop, snp) 
 alleleTable <- cbind(A = 2*genoTable[,"AA"] + genoTable[,"AB"],
                      B = 2*genoTable[,"BB"] + genoTable[,"AB"])
 return(alleleTable)
}
fisherFun(snps$SNP1, snps$Population)
```

```
##          A  B
## Control 56 50
## Treat   35 61
```

## Writing Our Function | Adding the Fisher Test


```r
fisherFun<- function(snp, pop){
 genoTable <- table(pop, snp) 
 alleleTable <- cbind(A = 2*genoTable[,"AA"] + genoTable[,"AB"],
                      B = 2*genoTable[,"BB"] + genoTable[,"AB"])
 fTest <- fisher.test(alleleTable)
 return(fTest)
}
fisherFun(snps$SNP1, snps$Population)
```


## Writing Our Function | Adding the Fisher Test

Is there any optional information we might like to pass to the Fisher Test?


```r
?fisher.test
```

## Writing Our Function | Adding the ellipsis


```r
fisherFun<- function(snp, pop, ...){
 genoTable <- table(pop, snp) 
 alleleTable <- cbind(A = 2*genoTable[,"AA"] + genoTable[,"AB"],
                      B = 2*genoTable[,"BB"] + genoTable[,"AB"])
 fTest <- fisher.test(alleleTable, ...)
 return(fTest)
}
```

## Writing Our Function | Adding the ellipsis

__Compare the following__


```r
fisherFun(snps$SNP1, snps$Population)
fisherFun(snps$SNP1, snps$Population, conf.level = 0.99)
```

__Was there a difference?__

__Should we leave the ellipsis here?__

## Writing Our Function | Defining The Output

__What information should we keep?__

Do we want:

- The frequency of `A` or `B` in each population?
- Any Odds Ratio?
- The $p$-value?

## Writing Our Function | Defining The Output

__What information should we keep?__

- The frequency of `A` or `B` in each population?
- Any Odds Ratio?
- The $p$-value?

__Let's go with just `A` in each population and the $p$-value__

## Writing Our Function | Defining The Output


```r
fisherFun<- function(snp, pop, ...){
 genoTable <- table(pop, snp) 
 alleleTable <- cbind(A = 2*genoTable[,"AA"] + genoTable[,"AB"],
                      B = 2*genoTable[,"BB"] + genoTable[,"AB"])
 freqs <- alleleTable[,"A"] / rowSums(alleleTable) 
 fTest <- fisher.test(alleleTable, ...)
 return(freqs)
}
```

## Writing Our Function | Defining The Output


```r
fisherFun<- function(snp, pop, ...){
 genoTable <- table(pop, snp) 
 alleleTable <- cbind(A = 2*genoTable[,"AA"] + genoTable[,"AB"],
                      B = 2*genoTable[,"BB"] + genoTable[,"AB"])
 freqs <- alleleTable[,"A"] / rowSums(alleleTable) 
 fTest <- fisher.test(alleleTable, ...)
 out <- as.list(freqs) %>% as.data.frame()
 out$p.value <- fTest$p.value
 return(out)
}
```

## Writing Our Function | Defining The Output


```r
fisherFun(snps$SNP1, snps$Population)
```

```
##     Control     Treat    p.value
## 1 0.5283019 0.3645833 0.02359114
```

# Using Functions Repetitively


---

<div class="footer" style="text-align:center;width:25%">
[Home](http://uofabioinformaticshub.github.io/RAdelaide-July-2016/)
</div>
