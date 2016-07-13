# Editing Data
Steve Pederson  
20 July 2016  



# Data Cleaning

## Setup

If you've started a new session since last time:


```r
library(dplyr)
library(readr)
```


## Data Cleaning | What if the data we have isn't nice?

- Missing values might be given a value (e.g. 9999, "NA")
- Column names might be missing
- File may have comments
- May be structural errors in the file
- White-space in cells

## Dealing With Column Names

- The function `read.csv()` refers to column names as a `header`
- By default, the first row is assumed to contain the names of the variables/columns
- This tells `R` how many columns you have

__What happens if we get this wrong?__


```r
no_header <- read_csv("data/no_header.csv")
```

## Dealing With Column Names

We can easily fix this


```r
no_header <- read_csv("data/no_header.csv", col_names = FALSE)
```

__What about that first column?__

## Dealing With Column Names

We can specify what is loaded or skipped using `col_types`


```r
?read_csv
```


```r
no_header <- read_csv("data/no_header.csv", col_names = FALSE,
                      col_types = "-ccnnc")
```

__What if we get that wrong?__

## Dealing With Column Names | Getting it wrong

Let's mis-specify the third column as a number


```r
no_header <- read_csv("data/no_header.csv", col_names = FALSE,
                      col_types = "-cnnnc")
```

- Did the error message make any sense?
- Did the file load?
- What happened to the third column?

## Dealing With Comments

Let's get it wrong first


```r
comments <- read_csv("data/comments.csv")
```

Now we can get it right


```r
comments <- read_csv("data/comments.csv", comment = "#")
```

This will work if there are comments in __any__ rows

## Structural Problems

**What happens when you try to load the file `bad_colnames_.csv`**


```r
bad_colnames <- read_csv("data/bad_colnames.csv")
```

__How could we fix this?__

a. By editing the file, and 
b. Without editing the file

## Structural Problems

__Here's my fix__


```r
bad_colnames <- read_csv("data/bad_colnames.csv", 
                             skip =  1, col_names = FALSE)
colnames(bad_colnames) <- c("rowname", "gender", "name",
                                "weight", "height", "transport")
```

We can set column names manually...

## The `c()` function

The most common function in `R` is `c()`

- This stands for `combine`
- Combines all values into a single `R` object, or `vector`
- If left empty, it is equivalent to `NULL`


```r
c()
```

```
## NULL
```

```r
colnames(bad_colnames) <- c()
```

## Encoded Missing Values

__What if missing values have been set to "-"?__

Let's get it wrong first


```r
missing_data <- read_csv("data/missing_data.csv")
```

__Where have the errors appeared?__

Now we can get it right


```r
missing_data <- read_csv("data/missing_data.csv", na = "-")
```
<div class="footer" style="text-align:center;width:25%">
[Home](http://uofabioinformaticshub.github.io/RAdelaide-July-2016/)
</div>