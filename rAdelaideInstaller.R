# Connect to BioC & install using the correct packages

reqVers <- "3.3.1"
if (paste(R.Version()[c("major", "minor")], collapse = ".") != reqVers){
  warning("Your R version is not correct. Please ensure you are running R", reqVers)
}

source("https://bioconductor.org/biocLite.R")
message("Checking each installed package version is correct...\n")
biocValid(fix = TRUE, ask = FALSE)
packList <- c("magrittr", "dplyr", "reshape2", "readr", "readxl", "ggplot2", 
              "knitr", "snow", "biomaRt", "GenomicRanges", 
              "AnnotationHub", "VariantAnnotation", "rtracklayer", "topGO",
              "nlme", "lme4", "lattice", "MASS", "rmarkdown", "lmerTest", 
              "car", "tibble", "stringr", "pander", "xtable")
installed <- rownames(installed.packages())
notInstalled <- packList[!packList %in% installed]

if (length(notInstalled) > 0){
  message("Installing/updating other required packages...\n")
  biocLite(notInstalled, ask = FALSE)
  installed <- rownames(installed.packages()) # Update to see what's there now
  missingPackages <- notInstalled[!notInstalled %in% installed]
  if (length(missingPackages) > 0){
    invisible(sapply(missingPackages, function(x){
      warning("\nThe package", x, "has not been installed.",
              "Please try entering the code:\n\n biocLite(", x, 
              ")\n\nPlease email stephen.pederson@adelaide.edu.au the output of any error messages you see.\n")
    }))
  }
} else{
  message("All packages appear to have been successfully installed.")
}

