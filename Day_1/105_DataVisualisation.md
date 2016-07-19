# 105: Data Visualisation
Steve Pederson  
20 July 2016  



# Data Visualisation | Using the Package `ggplot2`

## The package `ggplot2`

`R` has numerous plotting functions in the base package `graphics`


```r
?plot
?boxplot
?hist
```

__Go to the bottom of each help page and copy a few lines__

## The package `ggplot2`

- `ggplot2` gives much more flexibility and power
- Has unique syntax and approach
- We add layers of plotting information


```r
library(ggplot2)
```

## The package `ggplot2` | aesthetics

The main function is `ggplot()`

- In this first stage we set the plotting aesthetics using `aes()`
- Defines what is plotted on which axis, what defines the colour/shape etc.


```r
ggplot(data, aes(x = weight, y = height))
```

No data will be plotted. We get the plot area only...

## The package `ggplot2` | geometry

After defining the plot aesthetics, we add the geometry using various `geom_...()` functions

We tell the first line that "more is to come" by adding a `+` symbol at the end


```r
ggplot(data, aes(x = weight, y = height)) +
  geom_point()
```

## The package `ggplot2` | geometry

<img src="105_DataVisualisation_files/figure-html/unnamed-chunk-5-1.png" style="display: block; margin: auto;" />

## The package `ggplot2` | aesthetics

There are numerous aesthetics available for `geom_point()`


```r
?geom_point
```


```r
ggplot(data, aes(x = weight, y = height, colour = transport)) +
  geom_point()
```


```r
ggplot(data, aes(x = weight, y = height, 
                 colour = transport, shape = gender)) +
  geom_point()
```

## The package `ggplot2` | aesthetics

We can put the general aesthetics in `ggplot()`, with the `geom_point()` specific ones in that line


```r
ggplot(data, aes(x = weight, y = height)) +
  geom_point(aes(colour = transport, shape = gender))
```

Aesthetics set outside of `aes()` are general across all points


```r
ggplot(data, aes(x = weight, y = height)) +
  geom_point(aes(colour = transport, shape = gender), size = 4)
```

## The package `ggplot2` | adding multiple geoms


```r
ggplot(data, aes(x = weight, y = height)) +
  geom_point(aes(colour = transport, shape = gender)) +
  geom_smooth()
```

This defaults to a `loess` fit


```r
ggplot(data, aes(x = weight, y = height)) +
  geom_point(aes(colour = transport, shape = gender)) +
  geom_smooth(method = "lm", formula = y~x, se = FALSE)
```

## The package `ggplot2` | labels

Axis and legend labels can be added using `labs()`


```r
ggplot(data, aes(x = weight, y = height)) +
  geom_point(aes(colour = transport, shape = gender)) +
  geom_smooth(method = "lm", formula = y~x, se = FALSE) +
  labs(x = "Weight (kg)", y = "Height (cm)", 
       shape = "Gender", colour = "Transport")
```


## The package `ggplot2` | facets

(This is my favourite feature)


```r
ggplot(data, aes(x = weight, y = height)) +
  geom_point(aes(colour = transport, shape = gender)) +
  geom_smooth(method = "lm", formula = y~x, se = FALSE) +
  labs(x = "Weight (kg)", y = "Height (cm)", 
       shape = "Gender", colour = "Transport") +
  facet_wrap(~gender) 
```

## The package `ggplot2` | Different geoms

Enter `geom_` in the Console followed by the `tab` key


```r
ggplot(data, aes(x = height, fill = gender)) +
  geom_density(alpha = 0.5)
```


```r
ggplot(data, aes(x = gender, y =height, fill = gender)) +
  geom_boxplot()
```


## The package `ggplot2` | `geom_bar()`

We can summarise our data, then _pipe_ into `ggplot()`


```r
data %>%
  group_by(transport, gender) %>%
  summarise(mn_height = mean(height), sd_height = sd(height)) %>%
  ggplot(aes(x = transport, y = mn_height, fill = transport)) +
  geom_bar(stat = "identity") +
  facet_wrap(~gender) +
  guides(fill =FALSE)
```

NB: `geom_bar()` requires `stat = "identity"`

## The package `ggplot2` | `geom_errorbar()`


```r
data %>%
  group_by(transport, gender) %>%
  summarise(mn_height = mean(height), sd_height = sd(height)) %>%
  ggplot(aes(x = transport, y = mn_height, fill = transport)) +
  geom_bar(stat = "identity") +
  geom_errorbar(aes(ymin = mn_height - sd_height,
                    ymax = mn_height + sd_height),
                width = 0.6)+
  facet_wrap(~gender) +
  guides(fill =FALSE)
```

## The package `ggplot2` | facets

__How could we get histograms for both `weight` and `height` using facets?__

- The geom to use is `geom_histogram()`

## The package `ggplot2` | facets

__How could we get histograms for both `weight` and `height` using facets?__


```r
data %>%
  melt(id.vars = c("gender", "name", "transport")) %>%
  ggplot(aes(x = value, fill = variable)) +
  geom_histogram(bins = 10, colour = "black") +
  facet_wrap(~variable, scales = "free_x") +
  guides(fill = FALSE)
```

## The package `ggplot2` | facets


```r
data %>%
  melt(id.vars = c("gender", "name", "transport")) %>%
  ggplot(aes(x =gender, y = value, fill = gender)) +
  geom_boxplot() +
  facet_wrap(~variable, scales = "free_y")
```

<div class="footer" style="text-align:center;width:25%">
[Home](http://uofabioinformaticshub.github.io/RAdelaide-July-2016/)
</div>
