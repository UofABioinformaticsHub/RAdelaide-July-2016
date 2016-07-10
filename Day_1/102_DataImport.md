# Data Import In R
Steve Pederson  
20 July 2016  





# Getting Data Into R

## Importing Data

- A stumbling block for many learning `R` is the `Error Messages`
- We often see them while we're loading data
- `R` is very strict about data formats
- We can load `.xlsx`, `xls`, `csv`, `txt`, `gtf/gff` files + many more
- The structure of the spreadsheet is vital

## Importing Data

- Things we do to make it "look nice" in Excel can create problems
- In `Day1/data`, open `RealTimeData.xlsx` in Excel (or Libre Office)

__Which sheet do you think will be the most problematic to load?__

<div class="footer" style="font-size:55%;width:50%;line-spacing:1;text-align:right">
  <p>Worksheet downloaded from Gaurav Nagar,Indian Veterinary Research Institute</p>
</div>

## Importing Data

### Sheet 1

- This is actually the type of format `R` loves to see
- We have a simple column structure, with column and row names
- No blank rows at the top or separating sub-tables
- No blank columns


## Importing Data

### Sheet 2
__What about all those missing values?__

- `R` can happily deal with missing values: $\implies$ will load as `NA`
- The missing column names may give a warning message
- Otherwise no problems

## Importing Data

### Sheet 3

- Here we effectively have 2 tables on the same sheet
    - This can cause error messages
    - The plot will simply be ignored

__Always think in terms of columns__

## Using the GUI To Load Data

- In today's `data` folder is the file `toothData.csv`
- Clicking on it will only open it in the `Script Window` as a text file
- We can use the button as shown

![](images/guiImport.png)

## Using the GUI To Load Data | The Preview Window


<img src="images/Preview.png" width="550" style="display: block; margin: auto;" />

## Using the GUI To Load Data

1. Try changing a few settings to see the changes in the Preview section
2. Once you're happy, click "Import"

You will see two lines of code in the `Console` $\implies$ two things have just happened


```r
toothData <- read.csv("RAdelaideWorkshop/Day_1/data/toothData.csv")
View(toothData)
```

## Using the GUI To Load Data


```r
toothData <- read.csv("RAdelaideWorkshop/Day_1/data/toothData.csv")
```

__ALWAYS__ copy the first line into your script!

- This is the exact command we've used to load the file

## Using the GUI To Load Data


```r
View(toothData)
```

The second line has opened a preview of our `R` object

- Unless we change it, the `R` object will be the filename before the `.csv`
- Also look at the `toothData` object in the `Environment` tab (click the arrow)

## Data Frame Objects

- The object `toothData` is known as a `data.frame`
- `R` equivalent to a spreadsheet


```r
View(toothData)
```

OR


```r
toothData
```

OR


```r
head(toothData)
```


## Data Frame Objects | Factors

- By default `R` assumes that a column of text is a categorical variable (i.e. a `factor`)
- Can be a trap for the unwary
- We can change this by unchecking the `stringsAsFactors` button during import

## What have we really done?

- In the above we called the `R` function `read.csv()` 
- From the `utils` package which is one of the `base` packages
- The help page isn't very helpful here...


```r
?read.csv
```

- There are three basic functions listed here:  
`read.table()`, `read.csv()` and `read.delim()`
- The main differences are in the separators

## A Better Alternative

- The above uses the default function `read.csv()`
- The package `readr` has a similar, but slightly superior version called `read_csv()`


```r
library(dplyr)
library(tibble)
library(readr)
toothData <- read_csv("data/toothData.csv")
```

## A Better Alternative

__Why is this better?__

1. This is a `local data frame`
2. Character columns are left as plain text
3. Display in the `Console` is more convenient


```r
toothData
```


