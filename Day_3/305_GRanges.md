# 305: Genomic Ranges
Steve Pederson  
22 July 2016  



# Genomic Ranges

## Packages for NGS Data

- `ShortRead` 
    + for reading/analysing FASTQ files
    + also performs QC

- `Rsamtools`
    + for processing SAM/BAM files
    + more than a wrapper to `samtools`
    + Objects connect to `GRanges` objects
    
## ShortRead

Numerous functions for handling `.fastq` files

- Uses `Biostrings` classes

- `DNAStringSet` for sequences

- `BStringSet` for quality scores

Personally I can't see any advantage to the set of external tools

## Rsamtools

- Built for integration with `GenomicRanges` 
- Very useful for dealing with NGS data
    + Particularly RNA-Seq
- Mainly built around handling `.bam` files    
    
## `Genomic Ranges`

Anchor point between different analytic requirements

- SNP data
- RNASeq data
- CLIP or other miRNA data

## More SNP Data

In "`Day 3/data`":

- This is a large simulated SNP dataset
- All we have is the genomic locations
- From the human autosomes (Chr1 - 22)

## More SNP Data

Let's load the data so we can form a `GRanges` object

Change into the "*Day 3*" directory


```r
library(readr)
snpFile <- file.path("data", "HsSNPs.csv")
file.exists(snpFile)
snps <- read_csv(snpFile)
```


## `Genomic Ranges`

Load the important Bioconductor packages


```r
library(GenomicRanges)
library(TxDb.Hsapiens.UCSC.hg19.knownGene)
txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene  
```

## `Genomic Ranges`

As we only have the autosomal SNPS:

- let's set this up as a `Seqinfo` object
- We'll need this when constructing our SNP `GRanges` object


```r
autoSeq <- list(seqlevels = seqlevels(txdb)[1:22])
autoSeq$seqinfo <- seqinfo(txdb)[autoSeq$seqlevels]
```

## `Genomic Ranges`

Now we have everything we need!


```r
snpGR <- GRanges(Rle(snps$Chr), 
                 IRanges(snps$BP, end = snps$BP), 
                 strand = "*", 
                 seqinfo = autoSeq$seqinfo)
```

We can explore this using `length()`, `seqlengths()`, `seqlevels()` etc.


```r
head(start(snpGR))
```


## What do we do now?

1. Let's find how many SNPs we have on each chromosome
    - form a GRanges object for entire chromosome, THEN 
    - count the overlaps between the two GRanges objects


```r
autosomes <- GRanges(Rle(autoSeq$seqlevels), 
                    IRanges(1, seqlengths(autoSeq$seqinfo)), 
                    strand = "*", 
                    seqinfo = autoSeq$seqinfo)
```

## `countOverlaps()`

Now we have our two `GRanges` objects


```r
snpPerChrom <- countOverlaps(autosomes, snpGR, type="any")
names(snpPerChrom) <- seqlevels(autosomes)
```

1. Check the help page using `?countOverlaps`

## `Genomic Ranges

Now the fun stuff:

- How do we find if any SNPs overlap genes?
- What about introns/exons?
- Promoters? CDS?
- Whichever way you want to subset the genome...

## `Genomic Ranges`

Let's look by gene first

Define a gene as the range between the start & end points of all transcripts


```r
txGRL <- transcriptsBy(txdb, "gene")
gnGRL <- range(txGRL)
```

This time we have `GRangesList` objects as both objects

## `GenomicRanges`

Now we can find the overlaps


```r
gnOverlaps <- countOverlaps(gnGRL, snpGR)
gnOverlaps <- gnOverlaps[gnOverlaps > 0]
```

### How do we find that how many genes have SNPs?

### Would each SNP be counted once?

## `Genomic Ranges`

Now we can find the overlaps looking the other way


```r
snpGnOverlaps <- countOverlaps(snpGR, gnGRL)
snpGnOverlaps <- snpGnOverlaps[snpGnOverlaps > 0]
```

### Now we can see how many SNPs overlap genes

*(Perhaps I should've simulated my data better...)*

## `Genomic Ranges`

We can find the actual mappings from SNP to gene


```r
mapSnpGns <- findOverlaps(snpGR,gnGRL)
```

## `Genomic Ranges`

There's an even shorter way to count SNP hits for exons


```r
exBySNP <- exonsByOverlaps(txdb, snpGR)
```

And CDS


```r
cdsBySNP <- cdsByOverlaps(txdb, snpGR)
```

## `Genomic Ranges`

SNPs are pretty easy

- They all have a width of 1
- Overlaps are very simple to define
- RNASeq reads are more complex