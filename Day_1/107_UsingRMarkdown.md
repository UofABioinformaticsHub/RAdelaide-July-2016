# Using R Markdown
Steve Pederson  
20 July 2016  



# R Markdown

## Writing Reports Using `rmarkdown`

* `rmarkdown` is a cohesive way to
    + Load & tidy data 
    + Analyse data, including figures & tables
    + Publish everything in a complete report/analysis
* Everything is one document, with our analysis code embedded alongside our results
* The package `knitr` is the engine behind this

*All sessions for RAdelaide were written this way*

## Writing Reports Using `rmarkdown`

We can output our analysis directly as

* HTML
* MS Word Documents
* PDF Documents 
* Slidy or `ioslides` presentations

We never need to use MS Word, Excel or Powerpoint again!

## Writing Reports Using `rmarkdown`

- `.Rmd` files allow us to include normal text alongside embedded `R` code.
    + Create all of our figures & tables directly from the data
    + Data, experimental and analytic descriptions
    + Mathematical/Statistical equations
    + Nicely Formatted Results
    + Any other information


## Creating an *R* Markdown document

Let's create our first `rmarkdown` document

1. Go to the `File` drop-down menu in RStudio
2. New File -> R Markdown...


## The New R Markdown Form

<img src="images/NewRMarkdown.png" width="534" style="display: block; margin: auto;" />


## The New R Markdown Form

1. Change the Title to: My First Report
2. Change the Author to your own name
3. Leave everything else as it is & hit OK
4. Save the file as `RMarkdownTutorial.Rmd`

## The R Markdown Format | The Header
 
* The header section is contained between the `---` lines
    + __Nothing can be placed before this!__
    + Uses YAML (**Y**AML **A**in't **M**arkup **L**anguage)
    + Editing is beyond the scope of this course
    + Can set custom `.css` files, load LaTeX packages etc.
    
## The R Markdown Format | Code Chunks
    
* Lines 8 -- 10 are a code `chunk`
    + Chunks always begin with ```{r}
    + Chunks always end with ```
    + The code goes between these two delineators
    + Chunk names are optional and directly follow the `r`
    + Other parameters are set here, e.g. do we show/hide the code

## The R Markdown Format | File Structure

* Line 12 is a Section Heading, starting with ##
    + Click the _staggered text_ symbol in the top-right to open the _document outline_
    + Chunk names are shown in _italics_
    + Section Names in plain text

## The R Markdown Format | Text Formatting

`Help > Markdown Quick Reference`

- This describes the text formatting options: 
    + Bold is indicated by \*\*Knit\*\* (or \_\_Knit\_\_)
    + Italics can be indicated using a single asterisk/underline: \*Italics\* or \_Italics\_


    
## The R Markdown Format | Creating the Report

- The default format is an `html_document` & we can change this later.
- Generate the default document by clicking `Knit HTML`

<img src="images/CompileHTML.png" width="800" style="display: block; margin: auto;" />


## The R Markdown Format | Creating the Report

A preview window will appear with the compiled report

- Note the hyperlink to the RMarkdown website & the bold typeface for the word **Knit**
- The *R* code and the results are printed for `summary(cars)`
- The plot of `temperature` Vs. `pressure` has been embedded
- The code for the plot was hidden using `echo = FALSE`

    
## The R Markdown Format | Creating the Report

We could also export this as an MS Word document 

<img src="images/KnitWord.png" width="800" style="display: block; margin: auto;" />

## The R Markdown Format | Creating the Report

By default, this will be Read-Only

Saving as a `.PDF` may require an installation of LaTeX.

# Making our own report

## Making our own report

Now we can modify the code to create our own analysis.

- Delete everything in your R Markdown file EXCEPT the header
- We'll analyse the `PlantGrowth` dataset which comes with `R`
- First we'll need to describe the data


```r
?PlantGrowth
```

## Rename the report
First we should change the title of the report to something suitable, e.g. *The Effects of Two Herbicide Treatments on Plant Growth*

## Create a ``Data Description" Section
Now let's add a section header for our analysis to start the report

1. Type `# Data Description` after the header and after leaving a blank line
2. Use your own words to describe the data

## Describing the data

### My text was:
> Plants were treated with two different herbicides and the effects on growth were compared using the dried weight of the plants after one month.
Both treatments were compared to a control group of plants which were not treated with any herbicide.
Each group contained 10 plants, giving a total of 30 plants.


## Describing the data
Hopefully you mentioned that there were 10 plants in each group, with a total of 30.

__Can we get that information from the data itself?__

## Describing the data

The code `nrow(PlantGrowth)` would give the total number of samples.

__We can embed this in our data description!__

1. Instead of the number 30 in your description, enter  \``r` `nrow(PlantGrowth)`\`
2. Recompile the HTML document.
3. Try to repeat for the number 10

## Describing the data

Two possible approaches using `dplyr`


```r
filter(PlantGrowth, group == "ctrl") %>% nrow()
```

OR


```r
nrow(filter(PlantGrowth, group == "ctrl"))
```

## Loading *R* packages

1. Before the Data Description header, add a new header called `Required Packages`
2. Create a code chunk with the contents `library(dplyr)`.
3. Recompile the HTML

**Hint: You can create an empty code chunk using** `Ctrl+Alt+I`

This has loaded the package `dplyr` for the whole document.
All subsequent code chunks can use any functions in the package

## Tidying our output
Notice that loading `dplyr` gave us an overly informative message.

We can turn this off:

1. After the `r` at the start of the code chunk, add a comma
2. Start typing the word `message` and use the auto-complete feature to set `message = FALSE`
3. Recompile


## Adding some *R* code
After our description, we could also have a look at the data in a summary


```r
PlantGrowth %>% 
  group_by(group) %>% 
  summarise(n = n(),
            Mean = mean(weight))
```

(Recompile...)

## Formatting Tables

To change this table into a nicely formatted one:

1. Load `pander` into the workspace
2. Use the function `pander`

The line after loading `dplyr` enter:

```r
library(pander)
```

## Formatting Tables



```r
PlantGrowth %>% 
  group_by(group) %>% 
  summarise(n = n(),
            Mean = mean(weight)) %>%
  pander(caption = "Sample Sizes and average weights for each group")
```

## Formatting Tables


--------------------
 group   n    Mean  
------- ---- -------
 ctrl    10   5.032 

 trt1    10   4.661 

 trt2    10   5.526 
--------------------

Table: Sample sizes and average weights for each group

## Using `pander`

The package `pander` is great for formatting `R` output.

Add the following line to your data description:

> "The three groups are classified as \``r` `pander(levels(PlantGrowth$group))`\`"

(We'll understand this code better after tomorrow...)

## Add a plot of the data

We can use `ggplot2` for this

1. Load this package back in the **Required Packages** section
2. Create a plot using `geom_boxplot()`
3. Fill the boxes based on the `group` variable


## Add a plot of the data




<img src="107_UsingRMarkdown_files/figure-html/unnamed-chunk-12-1.png" style="display: block; margin: auto;" />

## Analyse the data | Define the model

Here we can fit a simple linear regression using:

- `weight` as the response variable
- `group` as the predictor variable


We can describe the model in words or mathematically

## Analyse the data | Define the model

> Data will be fit using the model

$$
y_{ij} = \mu + \alpha_i + \epsilon_{ij}
$$

The text creating this is:  

> y_{ij} = \\mu + \\alpha_i + \\epsilon_{ij}

Add _double dollar signs_ (\$\$) on the lines immediately before and after the equation

## Analyse the data | Define the model

- Create a new section for this?
- We can insert mathematical text between single dollar signs within our text
- Describe the model (can use LaTeX)

## Analyse the data | Define the model

$$
y_{ij} = \mu + \alpha_i + \epsilon_{ij}
$$

- $y_{ij}$ represents the observed weight for plant $j$ in treatment group $i$
- $\mu$ represents the overall mean
- $\alpha_i$ represents the effect for each treatment, with $\alpha_1 = 0$
- $\epsilon_{ij}$ is a general error term $\epsilon_{ij} \sim \mathcal{N}(0, \sigma)$

## Analyse the data | Fit the model

To fit a linear model in `R`:

1. Use the function `lm()`
2. Save the results as a new object


```r
model_fit <- lm(weight ~ group, data = PlantGrowth)
```

## Analyse the data | Fit the model

We can view the `summary()` or `anova()` for a given model using


```r
summary(model_fit)
anova(model_fit)
```

## Analyse the data | Fit the model

To place these as tables in the text: `pander()`


```r
summary(model_fit) %>% pander()
```


```r
anova(model_fit) %>% pander()
```

You can change the default captions if you like

## Bonus Challenge

__How could we make a barchart with error bars from this data?__

## Bonus Challenge


```r
PlantGrowth %>%
  group_by(group) %>%
  summarise(mean = mean(weight), sd = sd(weight)) %>%
  ggplot(aes(x = group, y = mean, fill = group)) +
  geom_bar(stat = "identity") +
  geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd),
                width = 0.6) +
  theme_bw() +
  labs(x = "Treatment Group", y = "Mean Weight (g)") +
  guides(fill = FALSE) +
  ggtitle("Mean Growth For All Treatment Groups.")
```


## Finishing the analysis

After you're happy with the way your analysis looks

- A good habit is to finish with a section called `Session Info`
- Add a code chunk which calls the *R* command `sessionInfo()`

## Finishing the analysis

So far we've been compiling everything as HTML, but let's switch to an MS Word document

We could email this to our supervisors, or upload to Google docs for collaborators...

## Summary

This basic process is incredibly useful

- We never need to cut & paste anything between document formats
- Every piece of information comes directly from our *R* analysis
- We can very easily incorporate new data as it arrives
- Creates *reproducible research*

<div class="footer" style="text-align:center;width:25%">
[Home](http://uofabioinformaticshub.github.io/RAdelaide-July-2016/)
</div>
