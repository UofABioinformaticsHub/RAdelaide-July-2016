# 203: Functions: Part 2
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

1. Form a 2 $\times$ 2 table (for `A` and `B`)
2. Perform the test
3. Format our output 

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
 alleleTable <- data.frame(A = 2*genoTable[,"AA"] + genoTable[,"AB"],
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
 alleleTable <- data.frame(A = 2*genoTable[,"AA"] + genoTable[,"AB"],
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
 alleleTable <- data.frame(A = 2*genoTable[,"AA"] + genoTable[,"AB"],
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
 alleleTable <- data.frame(A = 2*genoTable[,"AA"] + genoTable[,"AB"],
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
 alleleTable <- data.frame(A = 2*genoTable[,"AA"] + genoTable[,"AB"],
                           B = 2*genoTable[,"BB"] + genoTable[,"AB"])
 freqs <- alleleTable[,"A"] / rowSums(alleleTable) 
 fTest <- fisher.test(alleleTable, ...)
 out <- as.list(freqs)
 out$p.value <- fTest$p.value
 as.data.frame(out)
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

## Using `lapply`

Now we have a function which works on one SNP

- How do we apply this to all 2000?

`R` has a very handy function `lapply()`


```r
?lapply
```

## Using `lapply`

This stands for `l`ist `apply()`

- We literally apply this function to every element of a `list`
- Remember a `data.frame` is a `list`

## Using `lapply`

A simple example:


```r
x <- list(int = 1:10, norm = rnorm(100))
```

Here we have made a list `x` with two components `int` and `norm`


```r
lapply(x, mean)
```

## Using `lapply`

We could place any sensible function here


```r
lapply(x, head)
lapply(x, min)
lapply(x, typeof)
```


## Using `lapply`

Note the `...`

- `lapply()` places each element of the list (i.e. `X`) as the _first argument_ of `FUN`
- Any other arguments are named and specified here
- They will not be iterated over  
We can use `mapply()` for that if required

## Alternatives to `lapply()`

In all the above, the output was a list the same length as the input.

#### `sapply()` attempts to simplify the output


```r
sapply(x, mean)
sapply(x, range)
```

- Can be useful, but sometimes unpredictable
- Only use if you're sure of the structure of the output

## Alternatives to `lapply()`

In all the above, the output was a list the same length as the input.

#### `vapply()` requires the output structure be defined


```r
vapply(x, mean, numeric(1))
vapply(x, range, numeric(2))
```

## Alternatives to `lapply()`

The function `apply()` can be applied to matrices/arrays


```r
?apply
```

- `MARGIN = 1` applies the function by row
- `MARGIN = 2` applies the function by column
- `MARGIN = 3` for 3-d arrays etc.

# Back To The SNP Data

## Back To The SNP Data

Our data is a `data.frame` (i.e. a `list`)  
$\implies$ can use `lapply()`


```r
vapply(snps, anyNA, logical(1))
```

We could even chain together functions


```r
snps %>%
  lapply(is.na) %>%
  sapply(mean)
```

## Back To The SNP Data | Applying `fisherFun()`

Our output is a `data.frame`

__Should we use `lapply()` or `sapply()`?__

## Back To The SNP Data | Applying `fisherFun()`

Let's do a quick test


```r
lapply(snps[2:3], fisherFun, pop = snps$Population)
sapply(snps[2:3], fisherFun, pop = snps$Population)
```

## Back To The SNP Data | Applying `fisherFun()`

One `dplyr` function we haven't seen yet: `bind_rows()`


```r
snps[2:3] %>%
  lapply(fisherFun, pop = snps$Population) %>%
  bind_rows()
```

We can use this to combine all our results!

## Back To The SNP Data | Applying `fisherFun()`

Here's my actual analysis


```r
results <- snps[-1] %>%
  lapply(fisherFun, pop = snps$Population) %>%
  bind_rows() %>%
  mutate(SNP = names(snps)[-1],
         adjP = p.adjust(p.value, method = "bonferroni")) %>%
  arrange(p.value) %>%
  select(SNP, everything())
```

## Back To The SNP Data | Applying `fisherFun()`


```r
head(results)
```

```
##       SNP   Control     Treat      p.value         adjP
## 1 SNP1716 0.6132075 0.0900000 5.995601e-16 1.199120e-12
## 2 SNP1236 0.6320755 0.1078431 1.234748e-15 2.469497e-12
## 3  SNP603 0.3846154 0.8921569 8.474637e-15 1.694927e-11
## 4 SNP1271 0.4230769 0.9183673 1.357034e-14 2.714068e-11
## 5 SNP1501 0.3301887 0.8431373 2.380582e-14 4.761164e-11
## 6  SNP248 0.5849057 0.1000000 6.181343e-14 1.236269e-10
```

# Running in Parallel

## Running in Parallel

The package `parallel` has a function `mclapply()`

- This stands for `m`ulti`c`ore `lapply()`
- This is literally all we need to run in parallel



```r
library(parallel)
```

## Running in Parallel

- Can treat each CPU/hyperthread as a node in a cluster
- Always some overhead setting up the "cluster"
- I usually leave at least one node free to "drive" things

## Running in Parallel


```r
results <- snps[-1] %>%
  mclapply(fisherFun, pop = snps$Population, mc.cores = 3) %>%
  bind_rows() %>%
  mutate(SNP = names(snps)[-1],
         adjP = p.adjust(p.value, method = "bonferroni")) %>%
  arrange(p.value) %>%
  select(SNP, everything())
```

## Running in Parallel

Check the times (using my dual-core i7 laptop)


```r
times <- list(
  series = system.time(lapply(snps[-1], 
                              fisherFun, 
                              pop = snps$Population)),
  parallel = system.time(mclapply(snps[-1], 
                                  fisherFun, 
                                  pop = snps$Population,
                                  mc.cores = 3))
)
```

- Running in series took 3.054 sec  
Running in parallel took 1.753 sec

## Running in Parallel

With 3 cores: a speed up of 1.74-fold

Now imagine a set of 25,000 SNPs with pair-wise comparisons required for linkage

- That's 312,487,500 comparisons
- Process went from > 2 weeks to ~2 days using 20 cores

## Advanced Parallel Programming

`mclapply()`:  

- invisibly sets up `mc.cores` identical R sessions
- subsets the data sequentially
- runs the function
- closes the sessions & returns the results

## Advanced Parallel Programming

The package `snow` allows us to configure each node manually

- Can export specific SNPs to specific nodes
- Need to export all required functions to each node
- Need to load all packages on each node

## Conclusion

When writing functions, the __order__ of arguments can be important

- Not only for `lapply()`
- Remember `%>%` places the output of a function into the __first position__ of the next function

# VM Setup Time

---

<div class="footer" style="text-align:center;width:25%">
[Home](http://uofabioinformaticshub.github.io/RAdelaide-July-2016/)
</div>
