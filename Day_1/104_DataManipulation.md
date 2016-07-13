# Data Manipulation
Steve Pederson  
20 July 2016  



# Data Manipulation

## Data Manipulation

Also known as _data munging_

We'll cover:

- `SQL-` and `Excel-`like functions in `dplyr`
- Changing from wide to long form using `reshape2`
- Editing text using `stringr`

## Data Manipulation | Loading The Packages


```r
library(readr)
library(dplyr)
library(tibble)
```

- The package `dplyr` works specifically with `data.frame` objects
- Works optimally with `local data frame` aka `tbl_df` objects
- Have just been renamed `tibble` objects

## But First | Logical Tests 

- Is Equal To: `==`
- Not equal - `!=`
- OR - `|`
- Less than `<`
- Less than or equal `<=`

## Logical Tests


```r
x <- 1:10
x == 5
x !=5
x > 5
x > 5 | x == 2
```

- `R` also recognises the symbol `&` for `AND`
- Not relevant for `dplyr`

## Starting with `dplyr`

Data for this session:


```r
data <- read_csv("data/comments.csv", comment = "#")
data
```

So we have a 32 x 6 `data frame`


```r
dim(data)
nrow(data)
ncol(data)
```

## Starting with `dplyr` | The `select()` function

The first row is the row names from the original file.

__How can we remove this column?__

The function `select()` allows you to select columns by name


```r
select(data, gender, name, weight, height, transport)
```

## Starting with `dplyr` | The `select()` function

The first row is the row names from the original file.

__How can we remove this column?__

The function `select()` allows you to select columns by name


```r
select(data, gender, name, weight, height, transport)
```

Or by position


```r
select(data, 2:6)
```

## Starting with `dplyr` | The `select()` function

- We can also remove columns using the minus (`-`) sign


```r
select(data, -1)
```

- As this column has no name, we can't call/remove it by name.
- We can remove other columns by name


```r
select(data, -transport)
```

__Discuss: Would removing by name or position by the best?__

## The `select()` function

The `select()` function has a few bonus functions:

- `starts_with()`, `ends_with()`, `contains()`, `one_of()` and `everything()`


```r
select(data, ends_with("t"))
select(data, contains("eig"))
```

## The `select()` function

__So far, we haven't changed the original object__

We can overwrite this anytime (sometimes by accident)


```r
data <- select(data, -1)
data
```

Now we have removed the meaningless columns

- To get the column, we just need to reload the `.csv` file

## Using `filter()` and `arrange()` 

We can use our logical tests to filter the data


```r
filter(data, transport == "car")
filter(data, transport == "car", gender == "female")
```

We can sort on one or more columns


```r
arrange(data, weight)
arrange(data, desc(weight))
arrange(data, transport, height)
```

## Combining Functions

- This is where `dplyr` steps up a gear
- We can chain functions together using `%>%`
- This behaves like a `|` in the bash shell
- Known as the `magrittr`

-----

<img src="images/MagrittePipe.jpg" width="800" style="display: block; margin: auto;" />

## Combining Functions


```r
data %>% filter(transport == "bike")
```


```r
data %>% filter(transport == "bike") %>% arrange(weight)
```

There is __no limit__ to the number of functions you can chain together

## Combining Functions | For the technically minded

Each function in `dplyr` takes a `data.frame` as the first argument

The `magrittr` pipes our (modified) `data.frame` into the next function as the first argument

## Adding extra columns

We can add extra columns using `mutate()`


```r
data %>% mutate(height_m = height/100)
```

Once we've added a column, we can refer to it by name


```r
data %>% mutate(height_m = height/100, BMI = weight / height_m^2)
```

We can also overwrite existing columns


```r
data %>% mutate(height = height/100)
```

__Have we changed the original `data.frame`?__

## Changing Column Names

Can use the function `rename()`


```r
data %>% rename(height_cm = height)
```

Now we can get crazy


```r
data %>%
  rename(height_cm = height) %>%
  mutate(height_m = height_cm/100,
         BMI = weight / height_m^2) %>%
  filter(BMI > 25)
```

## Getting Summaries

Again, this is where `dplyr` really makes it easy.


```r
data %>% summarise(mean(weight), mean(height))
```


```r
data %>% summarise_each(funs(mean, sd), ends_with("ght"))
```

## Getting Group Summaries

We can group categorical variables by their levels


```r
data %>%
  group_by(gender) %>%
  summarise_each(funs(mean), ends_with("ght"))
```

## Getting Group Summaries

Or combinations of levels


```r
data %>%
  group_by(gender, transport) %>%
  summarise_each(funs(mean), ends_with("ght"))
```

We can use any function that spits out a single value

- `sd()`, `min()`, `median()`
- Plus the function `n()`

## Getting Group Summaries


```r
data %>%
  group_by(gender, transport) %>%
  summarise(mn_weight = mean(weight),
            mn_height = mean(height),
            n = n())
```


# Reshaping your data

## Reshaping your data

This dataset is in what we refer to as `wide` form

- We have a row of measurements for each individual
- The information is _structured around the individual_
- In `long` form, the information is _structured around the measurement_

## Reshaping your data | From Wide to Long


```r
library(reshape2)
library(readr)
```


```r
wideData <- read_csv("data/wide.csv")
```

This is a time course for two treatments


```r
melt(wideData, id.vars = c("Name", "Tx"))
```

Many functions require data to be in this format

## Reshaping your data | From Wide to Long

We don't need to leave those names as `variable` and `value`


```r
wideData %>%
  melt(id.vars = c("Name", "Tx"),
       variable.name = "Day", 
       value.name = "Change") 
```


## Reshaping your data

1. __How could we get means for each treatment/day from the original data?__
2. __How can we get the same from the data after "melting"?__

## Reshaping your data

1 __How could we get means for each treatment/day from the original data?__


```r
wideData %>% 
  group_by(Tx) %>%
  summarise_each(funs(mean), starts_with("day"))
```
2 __How can we get the same from the data after "melting"?__


```r
wideData %>%
  melt(id.vars = c("Name", "Tx"),
       variable.name = "Day", 
       value.name = "Change") %>%
  group_by(Tx, Day) %>%
  summarise(mn_change = mean(Change))
```

## Reshaping your data | From Long To Wide

Let's save that last summary `data.frame`


```r
wideMeans <- wideData %>%
  melt(id.vars = c("Name", "Tx"),
       variable.name = "Day", 
       value.name = "Change") %>%
  group_by(Tx, Day) %>%
  summarise(mn_change = mean(Change))
```

## Reshaping your data | From Long To Wide

We can change from long to wide using the `formula` syntax

- "`~`" stands for _is a function of_, or _depends on_
- The function `dcast` uses it to define rows on the LHS and columns on the RHS


```r
dcast(wideMeans, Tx~Day)
dcast(wideMeans, Day~Tx)
```

## Reshaping your data | From Long To Wide

Would we ever use both?


```r
pcr <- read_csv("data/PCR.csv")
```

Here we have 3 genes being measured in 2 cell types, across 3 time-points

The first part is easy:

```r
melt(pcr, id.vars = "Gene", variable.name = "CellType", value.name = "Ct")
```

## Text Manipulation

We might like to split those names into the two cell types and 3 time-points.

- Use the functions `str_extract()` and `str_replace()`


```r
library(stringr)
pcr %>%
  melt(id.vars = "Gene",
       variable.name = "CellType", value.name = "Ct") %>%
  mutate(TimePoint = str_extract(CellType, "(0hr|12hr|24hr)"),
         CellType = str_replace(CellType, "_(0hr|12hr|24hr)", "")) 
```

**Save this as the object `pcr_long`**

## Text Manipulation

Now we could make it wide (but not as wide)


```r
pcr %>%
  melt(id.vars = "Gene", 
       variable.name = "CellType", value.name = "Ct") %>%
  mutate(TimePoint = str_extract(CellType, "(0hr|12hr|24hr)"),
         CellType = str_replace(CellType, "_(0hr|12hr|24hr)", "")) %>%
  dcast(Gene + CellType ~ TimePoint, value.var = "Ct")
```

## Challenge

To investigate the effect of fitness, gender, country of origin on red blood cell count (RBC), you have been given `challenge.csv` with observations made on 500 subjects. The variables are:

1. **gender**: male or female.
2. **fitness**: a measure of fitness lying between 0 and 100. 
3. **country**: there are three countries denoted by 1, 2, or 3.
4. **RBC**: red blood cell count in millions/$\mu$L.

__Clean the data entirely in R__

<div class="footer" style="text-align:center;width:25%">
[Home](http://uofabioinformaticshub.github.io/RAdelaide-July-2016/)
</div>
