# 303: Sequence Data
Steve Pederson  
22 July 2016  



# BSgenome Objects

## AnnotationData

Four common classes of annotation

Object type |contents
-------------|---------------------------
OrgDb | gene based information
**BSgenome** | **genome sequence**
TxDb  | transcriptome ranges
OrganismDb | composite information

## `BSgenome` Objects


```r
library("BSgenome")
available.genomes()[1:4]
```

- These objects hold genome sequence information
- Currently 84 genomes available
- Mainly UCSC & NCBI derived

## `BSgenome` Objects

- Mainly human & model organisms
- Built around the `Biostrings` package ("BS")
- Special methods & classes for long sequences
- Loaded by default when we called `library("BSgenome")`

## `Biostrings`

Four important object classes:

1. `BString` - Can hold any character strings
2. `DNAString` - Restricted to DNA characters
3. `RNAString` - Restricted to RNA characters
4. `AAString` - Restricted to Amino Acid alphabet

## `BString` objects


```r
b <- BString("I am a BString object")
b
length(b)
as.character(b)
```

## `BString` objects

### Try these commands:


```r
subseq(b, start = 5)
subseq(b, start = -5, width=3)
reverse(b)
Views(b, start=c(1:5), end = 9)
```

## `DNAString` objects

- Restricted to DNA characters


```r
DNA_ALPHABET
```


```r
DNA_BASES
IUPAC_CODE_MAP[DNA_ALPHABET[1:15]]
```

## `DNAString` objects


```r
d <- DNAString("TTGAAAA-CTC-N")
d
length(d)
d[3:6]
```

## `DNAString` objects

### Try these commands:


```r
reverseComplement(d)
reverse(d)
alphabetFrequency(d)
alphabetFrequency(d, baseOnly=TRUE)
Views(d, start = 3:0, end = 5)
Views(d, start = 1:5, width=6)
subseq(d, start = -4, width = 3)
```

## `RNAString` objects

Very similar to `DNAString` objects, but with a different alphabet


```r
RNA_ALPHABET
```


```r
RNA_BASES
```

## `RNAString` objects

### Try these commands


```r
RNA_GENETIC_CODE
r <- RNAString(d)
r
r == d
alphabetFrequency(r, baseOnly = TRUE)
letterFrequency(r, c("A", "U"))
```

## `AAString` objects

Restricted to the Amino Acid alphabet

Functions specific to `DNAString`/`RNAString` objects won't work

### Try these commands


```r
AA_ALPHABET      
AA_STANDARD       
AA_PROTEINOGENIC
a <- AAString("MARKSLEMSIR*")
seqtype(a)
seqtype(d)
```

## `XStringSet` Objects

All of the above strings can be extended to:
- `BStringSet`, `DNAStringSet`, `RNAStringSet`, `AAStringSet`


```r
x <- c("CTC-NACCAGTAT", "TTGA", "TACCTAGAG")
width(x)
dss <- DNAStringSet(x)
```

The function `width()` is imported from the dependency `BiocGenerics`

## `DNAStringSet` Objects

### Try these commands


```r
nchar(dss)
width(dss)
names(dss)
names(dss) <- paste0("String", 1:3)
dss
subseq(dss, start=-4)
dss[1]
dss[[1]]
```

## Back to the `BSgenome` objects


```r
BiocInstaller::biocLite("BSgenome.Hsapiens.UCSC.hg19")
library("BSgenome.Hsapiens.UCSC.hg19")
ls(2)
```

This package is > 600Mb

After loading, we can just call `Hsapiens` as the `BSgenome` object

## `BSgenome`


```r
seqNms <- seqnames(Hsapiens)
seqNms[1:5]
seqLens <- seqlengths(Hsapiens)
seqLens[1:5]
```

## `BSgenome`

### Some commands to try


```r
Hsapiens
length(Hsapiens)
getSeq(Hsapiens, seqNms[1:2])
Hsapiens[["chr1"]]
Hsapiens$chr1
```

NB: Apart from the `[[` method, you **always** need to call sequences by name

## `BSgenome`

Contain `XString` objects:  
- extensive suite of functions for searching & pattern matching

### Some more interesting commands


```r
pattern1 <- DNAString("ACGGACCTAAT")
matchPattern(pattern1, Hsapiens$chr1)
vmatchPattern(pattern1, 
              getSeq(Hsapiens, seqNms[1:5]))
vcountPattern(pattern1, 
              getSeq(Hsapiens, seqNms[1:5]),
              max.mismatch = 1) 
findPalindromes(Hsapiens$chr1, min.armlength = 50)
```


## `BSgenome`

These objects are also well setup to interact with `TxDb` objects


