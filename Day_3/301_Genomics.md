# 301: R In The Genomics Era
Steve Pederson  
22 July 2016  



# The Bioconductor Project

## R Packages

- A Package is a collection of functions
- Associated with a given task/analysis/data-type
- The main repository is "__The Comprehensive R Archive Network__" (https://cran.r-project.org/)

`Tools > Install Packages...`

## R Packages

Go to the `Help` Tab

`Home` > `Packages` > `dplyr`

Here you can see all of the functions in `dplyr`

Many packages also define objects of a given `class`,  
e.g. a `data_frame`, `tbl_df` or `tibble`


## The Bioconductor Project | http://www.bioconductor.org

- All packages (~1200) are for Bioinformatics
    + Statistical Analysis; Databases & Data Handling; Visualisation
    + NGS data, microarrays, flow cytometry, proteomics...
- New releases every ~6 months
- All packages come with a descriptive vignette

## The Bioconductor Project


```r
browseVignettes()
```

Also has an active support community:

- https://support.bioconductor.org/
- Large suite of tutorials & workflows


## The Bioconductor Project

A recent training course:

http://www.bioconductor.org/help/course-materials/2016/BioC2016/

Some upcoming courses:

http://www.abacbs.org/biocasia2016workshop

## The Bioconductor Project

3 Broad Headings based on package tags, or `biocViews`

1. Software
2. AnnotationData
3. ExperimentData


## The Bioconductor Project

### 1. Software

- Currently >1000 packages, primarily for analysis
- Heavily used array packages: `affy`, `gcrma`, `limma`
- Access to external databases: `biomaRt`, `topGO`
- Rich in Seq analysis packages: `edgeR`, `DESeq`, `RSamtools`
- Wrappers for external Seq tools: `muscle`, `RBowtie`
- Lots of new object classes defined

## The Bioconductor Project

### 2. Annotation
- Currently >900 packages
- Set database classes (`OrgDb`, `TxDb`, `OrganismDb`, `BSgenome`)
- Annotations for common microarrays (e.g. Affy & Illumina)


## The Bioconductor Project

### 3. Experiment Data
- Currently ~300 packages
- Includes standard datasets for algorithm testing
- Also those included in many training courses


## Installing Bioconductor

- Packages don't appear in the drop-down menu for *RStudio*
    + Tools > Install Packages > ???
- Can be added to your default repositories, but there is a preferred installation procedure

## Installing Bioconductor


```r
source("http://bioconductor.org/biocLite.R")
```

- This installs the package `BiocInstaller`
- Manages the synchronisation of *R* releases and Bioconductor updates
- The main installation function is `biocLite()`
- Installs from __both__ CRAN & Bioconductor

## Installing Bioconductor

*R* dependencies can be challenging!

To check that you have the tested package versions and fix them


```r
library(BiocInstaller)
biocValid(fix = TRUE)
```

# Object Classes

## Object Classes

R has two common types of objects

- Built on top of (and including) vectors, lists etc
- `S3` and `S4`
- `S3` are very common
    - Usually list-type objects
    - e.g. results from `lm()` or `t.test()`

## Object Classes | Methods

Each defined class has a set of methods associated with it


```r
iris_lm <- lm(Petal.Length ~ Species, data = iris)
class(iris_lm)
typeof(iris_lm)
```

## Object Classes | Methods

At it's heart an object of class `lm` is a list

- It has a specific structure
- Methods for `lm` objects depend on this structure


```r
methods(class = "lm")
```

These are all functions that can be applied to an `lm` object

## Object Classes | Methods

Let's pick one of those defined methods, e.g. `residuals()`

- We can find what other classes of object have these


```r
methods("residuals")
```

__Note the suffixes!!__

Functions that end in `name.something()` apply to objects of class `something`

## S3 Objects

- S3 objects are very loose
- We can mess with them


```r
class(iris_lm) <- "htest"
```

__No error message!!!???__


```r
iris_lm
```

## S3 Objects

Did we break it?


```r
str(iris_lm)
```


```r
body(summary.lm)
body(summary.default)
```

## S3 Objects | Methods

Many packages define methods for given objects


```r
methods(class = "data.frame")
```


```r
library(dplyr)
methods(class = "data.frame")
```

## S3 Objects | Methods


```r
body(print)
```

This doesn't seem to make sense

Now type a `.` after print, then `Tab`

These are all the visible classes a print method exists for


```r
methods(print)
```


## S4 Objects

Many Bioconductor Packages define `S4` objects

- Very strict controls on data structure
- Can be frustrating at first
- Use the `@` symbol as well as `$`
- Methods are also strictly defined

## S4 Objects

Some packages use `S4` implementations of `S3` objects, e.g.

- `data.frame` (S3) Vs `DataFrame` (S4)
- `rle` (S3) Vs `Rle`

Look and behave very similarly, but can trip you over

- Object may require a `DataFrame` and you give it a `data.frame`

## Variations on the `data.frame` theme

- `data.frame`
    1. Can set `rownames`
    2. Dumps all data to your screen
    
- `tbl_df` aka `data_frame` 
    1. `rownames` are always `1:nrow(df)`
    2. Prints a summary

## Variations on the `data.frame` theme



```r
library(tibble)
mtcars
mtcars %>% rownames_to_column("model") %>% as_tibble()
mtcars %>% rownames_to_column("model") %>% as_tibble() %>% print(n=3)
```

I this last line we used `print.tbl_df`

## Variations on the `data.frame` theme | `DataFrame` objects


```r
library(S4Vectors)
?DataFrame
```

- An `S4` version
- Can have columns of lists (so can `tbl_df` objects)
- The function `CharacterList()` from `IRanges` is used
- Incompatible with `dplyr` unless coerced

## Variations on the `data.frame` theme


```r
library(IRanges)
genes <- c("A", "B")
transcripts <- CharacterList(c("A1", "A2", "A3"),
                             c("B1", "B2"))
transcripts
```


```r
DF <- DataFrame(Gene = genes, Transcripts = transcripts)
DF
```

```
## DataFrame with 2 rows and 2 columns
##          Gene     Transcripts
##   <character> <CharacterList>
## 1           A        A1,A2,A3
## 2           B           B1,B2
```

## Variations on the `data.frame` theme | `AnnotatedDataFrame` Objects

Enables addition of metadata


```r
library(Biobase)
metaData <- data.frame(labelDescription = c("The measured length", 
                                       "The Delivery Method",
                                       "The Dose in mg"))
newTooth <- AnnotatedDataFrame(data = ToothGrowth,
                               varMetadata = metaData)
```


```r
newTooth
pData(newTooth)
varMetadata(newTooth)
```