# 304: TxDb Objects
Steve Pederson  
22 July 2016  



## AnnotationData

Four common classes of annotation

Object type |contents
-------------|---------------------------
OrgDb | gene based information
BSgenome | genome sequence
**TxDb**  | **transcriptome ranges**
OrganismDb | composite information

## `TxDb` Objects

These are the objects with the transcriptome information

- Saved using `GRanges` classes
- Derived heavily from the `GenomicRanges` & `IRanges` packages
- The key idea is to refer the the genome using ranges to define locations

## Workspace Setup


```r
library(TxDb.Hsapiens.UCSC.hg19.knownGene)
txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene   
```


```r
txdb
```

This will load all the package dependencies as well

## `GRanges` objects

Let's look at a `GRanges` object

Note that our `txdb` object used EntrezGene Ids


```r
ids <- c(BRCA1="672", PTEN="5728")
genes(txdb, filter=list(gene_id=ids)) 
```

## `Rle` vectors

Run Length Encoding format vectors

- More memory efficient way to store positional information
- highly efficient for long regions of "no information", or
- also efficient for data with long stretches of repeats

## `Rle` vectors

`rle` : Part of the `base` *R* package

`Rle` : `S4Vectors` version

`Rle` is used extensively in `GenomicRanges`


```r
x <- c(1, 0, 0, 0, 1, 1, 2, 0, 0)
Rle(x)
```

## Creating a `GRanges` object


```r
gr <- GRanges(seqnames=Rle(c("chr1", "chrMT"), c(2, 4)),
              ranges=IRanges(15:20, 20),
              strand=rep(c("+", "-", "*"), 2))
```

Print the object by typing `gr`

The essential components are:

- `seqnames` & `ranges`
- If `strand` is omitted, the value `*` is added

## Working with a `GRanges` object

### Try these commands:


```r
seqnames(gr)
strand(gr)
ranges(gr)
seqinfo(gr)
length(gr)
gr[1]
width(gr)
start(gr)
```

- `seqinfo()` returns an object with a formal class
- `Seqinfo` objects contain metadata about each sequence

## Adding more information


```r
names(gr) <- paste0("Rng", LETTERS[1:length(gr)])
```

We can assign `names` to the ranges:

- Could be exons, genes, SNPs, CDS or any other feature

Now look at the object again

## Adding more information

We can also add some key information about the sequences


```r
seqlengths(gr) <- c(5e6, 1.5e5)
isCircular(gr) <- c(FALSE, TRUE)
genome(gr) <- c("madeUp.v1")
seqinfo(gr)
```

## Adding more information

`GRanges` objects also have columns for metadata

Let's add:

1. Some $p$-values from a hypothesis test
2. Alternative names for the Chromosomes


```r
mcols(gr) <- data.frame(score = 10^(-rexp(6)),
                        altChr = rep(c("G001", "G002"), 
                                     times=c(2, 4)))
```


## Subsetting `GRanges` objects

### Try these commands:


```r
gr[1:3]
gr[1:2, 1]
subset(gr, score < 0.05)
subset(gr, width==1)
subset(gr, start > 18)
subset(gr, start > 18 | width ==5)
table(gr$altChr)
summary(mcols(gr)[,"score"])
```

## `GRangesList`

`GRanges` objects can also be extended to `GRangesList` objects


```r
exByGn <- exonsBy(txdb, "gene")
length(exByGn)
```


```r
exByGn
```

## `GRangesList`

As well as the `exonsBy()` methods, other methods include

- `transcriptsBy()`, `cdsBy()`, `threeUTRsByTranscript()` + more

In the current example exons are listed by gene, but can also be listed by `exon`, `cds` or `tx`

## `GRangesList`

These behave like normal `list` objects in *R*

### Try these commands


```r
exByGn[[1]]
exByGn$`1`
exByGn[1:2]
sapply(exByGn[1:10], 
       function(x){length(subset(x, width<100))}) 
unlist(exByGn[1:5])
```

*Ask if you're unsure about what any of the above commands do*

## The `TxDb` Object as a Database

As well as extracting `GRanges` from these objects, they share methods with OrgDb objects


```r
keytypes(txdb)
columns(txdb)
```

## `GenomicFeatures`

Loading a `TxDb` object will also load dependencies such as `GenomicFeatures`

Contains many useful functions

- `makeTxDbFromBiomart()`, `makeTxDbFromGFF()`, `makeTxDbFromGRanges()`, `makeTxDbFromUCSC()`


## `GenomicFeatures`

`TxDb` objects not currently accesible from `AnnotationHub`

- Other source objects are, e.g. GTF files

Gives the possibility to use methods for non-model organisms using our own annotations, genomes etc

## `GenomicFeatures`

Also contains other useful methods


```r
promoters(txdb, upstream=100, downstream=50,
          columns = c("tx_name", "gene_id"))
```


```r
library(mirbase.db)
microRNAs(txdb)[1:3]
```

