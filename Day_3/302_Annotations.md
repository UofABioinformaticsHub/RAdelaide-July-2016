# 302: Annotations
Steve Pederson  
22 July 2016  



# Getting Annotation Information

## Annotation

- Make up a significant proportion of Bioconductor Packages
- Often seen as the end point of analysis
- For networks/pathways it's the starting point

## `biomaRt`

The package `biomaRt` is based on the web interface at http://www.ensembl.org/biomart/martview



```r
library(biomaRt)
allMarts <- listMarts()
```

These are the possible data sources (i.e. marts) we can access

## `biomaRt`

Each `mart` has multiple `datasets`


```r
mart <- useMart("ENSEMBL_MART_ENSEMBL")
ensDatasets <- listDatasets(mart)
library(dplyr)
filter(ensDatasets, grepl("sapiens", dataset))
```

## `biomaRt`

We can just go straight there by selecting the `dataset` within `useMart()`


```r
mart <- useMart(biomart = "ENSEMBL_MART_ENSEMBL", 
                dataset = "hsapiens_gene_ensembl")
```

NB: This is exactly the same procedure as the windows on the web GUI

## `biomaRt`

Now the `mart` & `dataset` have been selected

- The main query function is `getBM()`


```r
?getBM
```

This will give the requested data directly into a `data.frame`

## `biomaRt` | Attributes and Filters

The two main pieces of data

- `attributes` are the values we are looking for
- `filter` along with `values` are our search queries

To find what attributes can be downloaded from our `mart`


```r
martAttributes <- listAttributes(mart)
```

These are possible pieces of information we can return (`dim(martAttributes)`)

## `biomaRt`

- Some attributes may contain large amounts of data
- We can use filters to restrict the information
- e.g. we may have only a few genes of interest


```r
martFilters <- listFilters(mart)
```


## `biomaRt` | Example 1

- Let's get all the gene names on Chromosome 1
- NB: We need to specify the filter, and give the filter values separately
- We need to specify the mart argument every time



```r
genes <- getBM(attributes=c("hgnc_symbol", "entrezgene"), 
               filters = "chromosome_name", 
               values = "1", mart = mart)
head(genes)
```

## `biomaRt` | Example 2


```r
ids <- c("ENSG00000134460", "ENSG00000163599")
attr <-  c("ensembl_gene_id", "ensembl_transcript_id")
test <- getBM(attributes = attr,
              filters = "ensembl_gene_id",
              values = ids,
              mart = mart)
```

Repeat the above **without asking for the gene_id back**

How could we also get the `chromosome`, `strand`, `start` & `end` positions in the above query

## `biomaRt`

We could condense each set of transcripts into a `CharacterList` and make a `DataFrame`...



We can set multiple filters:

- The values must be supplied as a list (read the help page)

## `biomaRt` and `dplyr`

Here's a problem


```r
?select
```

We now have more than one function called `select`

__How will `R` know which one to use"__

A `mart` is an `S4` object, a `data.frame` is an `S3` object

## `biomaRt` and `dplyr`

This is a well known problem

The specific version of a function can be called by using the package name

- Known as the `namespace`
- `dplyr::select()` or `biomaRt::select()`

# Annotation Hub

## AnnotationData

This session relies heavily on material from

**Annotation Resources**

Authors: Marc RJ Carlson, Herve Pages, Sonali Arora, Valerie Obenchain, and Martin Morgan

Presented at BioC2015 July 20-22, Seattle, WA

https://github.com/mrjc42/BiocAnnotRes2015

## AnnotationData

Four common classes of annotation

Object type |contents
-------------|---------------------------
OrgDb | gene based information
BSgenome | genome sequence
TxDb  | transcriptome ranges
OrganismDb | composite information

## AnnotationHub


```r
library(AnnotationHub)
ah <- AnnotationHub()
```

- This is a relatively new & sensibly named package
- We can access & find numerous annotation types
- Uses `SQL`-type methods
- Creating this object will create a cache with the latest metadata from each data source

## Annotation Hub

Get a summary:


```r
ah
```

This is another `S4` object

- 3 important components: `$dataprovider`, `$species` & `$rdataclass`
- additional components listed under `additional mcols()` can also be accessed with the `$`

## Annotation Hub

We can find the data providers


```r
unique(ah$dataprovider) 
```

Or the different data classes in the hub


```r
unique(ah$rdataclass) 
```

## Annotation Hub

We can find the species with annotations


```r
sp <- unique(ah$species)
head(sp)
length(sp)
```

## Annotation Hub

We can `query` for matches to any term, e.g. to look for rabbit (*Oryctolagus cuniculus*) annotation sources


```r
query(ah, "Oryctolagus")
```

We can create smaller `AnnotationHub` objects, which we could then search again

## Annotation Hub

We can subset easily


```r
subset(ah, rdataclass=="GRanges")
```

Or if we know we want the `GRanges` annotations for the rabbit


```r
subset(query(ah, "Oryctolagus"), rdataclass=="GRanges")
```

## Annotation Hub

Or we can combine multiple search queries

Fetch the rabbit annotations, which are `GRanges` objects derived from `Ensembl`


```r
query(ah, 
      pattern=c("Oryctolagus", "GRanges", "Ensembl"))
```

## Annotation Hub

We can find the metadata for the whole object, or any subset we've created


```r
meta <- mcols(ah)
meta
```

## Annotation Hub

There's even a GUI


```r
display(ah)
```

- You may need to resize the **Viewer** window
- Return an `AnnotationHub()` to R by selecting a row & clicking the button

## Annotation Hub

Once we have the specific annotation we're interested in:
- subset using the name & the double bracket method
- this loads the `AnnotationData` object into your workspace


```r
gr <- ah[["AH51056"]]
gr
```

