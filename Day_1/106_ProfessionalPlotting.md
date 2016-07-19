# 106: Plots For Publication
Steve Pederson  
20 July 2016  



# Getting Professional Plots For Publication

## Publication Quality Plotting

Two main points:

1. Tweaking the look of the above plots
2. Plot Resolution and Font Sizes

## The package `ggplot2` | themes

`ggplot2` uses themes to control the overall appearance


```r
ggplot(data, aes(x = gender, y = height, fill = gender)) +
  geom_boxplot() +
  theme_bw()
```

My default is `theme_bw()`

- Removes the background grey, prints labels in black etc.

## The package `ggplot2` | themes


```r
ggplot(data, aes(x = gender, y = height, fill = gender)) +
  geom_boxplot() +
  theme_classic()
```


```r
ggplot(data, aes(x = gender, y = height, fill = gender)) +
  geom_boxplot() +
  theme_void()
```

## The package `ggplot2` | `ggthemes`


```r
library(ggthemes)
```


```r
ggplot(data, aes(x = gender, y = height, fill = gender)) +
  geom_boxplot() +
  theme_economist()
```


```r
ggplot(data, aes(x = gender, y = height, fill = gender)) +
  geom_boxplot() +
  theme_excel()
```

## The package `ggplot2` | themes

The `theme()` function is where you set:

- `axis.text`, `legend` attributes etc.
- Often uses _elements_ to set an attribute


```r
?theme
```

## The package `ggplot2` | themes

Changing text within themes uses `element_text()`


```r
?element_text
```


```r
ggplot(data, aes(x = gender, y = height, fill = gender)) +
  geom_boxplot() +
  theme_bw() +
  theme(axis.text = element_text(family = "Courier", 
                                 size = 15, angle = 30))
```

## The package `ggplot2` | themes

Changing backgrounds and outlines uses `element_rect()`


```r
ggplot(data, aes(x = gender, y = height, fill = gender)) +
  geom_boxplot() +
  theme_bw() +
  theme(legend.background = element_rect(fill = "yellow", 
                                         colour = "black"))
```

## The package `ggplot2` | themes

To remove all attributes use `element_blank()` in place of `element_rect()`, `element_text()` or `element_line()`


```r
ggplot(data, aes(x = gender, y = height, fill = gender)) +
  geom_boxplot() +
  theme_bw() +
  theme(panel.grid = element_blank())
```

## Legends

We can move the legend to multiple places:


```r
ggplot(data, aes(x = gender, y = height, fill = gender)) +
  geom_boxplot() +
  theme_bw() +
  theme(legend.position = "bottom")
```

Or we can use co-ordinates to place it inside the plotting region


```r
ggplot(data, aes(x = gender, y = height, fill = gender)) +
  geom_boxplot() +
  theme_bw() +
  theme(legend.position = c(0.8, 0.1))
```

## Other plot attributes | Axes

We can also edit axes, fills, outlines etc. using `scale_...()` layers


```r
ggplot(data, aes(x = gender, y = height, fill = gender)) +
  geom_boxplot() +
  theme_bw() +
  scale_y_log10(limits = c(100, 200),
                breaks = c(100, 125, 150, 175)) 
```

## Other plot attributes | Axes

We can turn off or modify plot expansion


```r
ggplot(data, aes(x = gender, y = height, fill = gender)) +
  geom_boxplot() +
  theme_bw() +
  scale_y_continuous(expand=c(0, 0)) 
```

## Other plot attributes | Fill and Outline Colours


```r
ggplot(data, aes(x = gender, y = height, fill = gender)) +
  geom_boxplot() +
  theme_bw() +
  scale_fill_manual(values = c("green", "blue"))
```

Colours can also be specified using hexadecimal codes


```r
rgb(1, 0, 0)
```

[1] "#FF0000"

## Exporting Figures | Using `ggsave()`

The main image formats are `jpeg`, `png` and `tiff`

- `R` can also export `svg` and `pdf`
- `ggplot2` has the function `ggsave()`


```r
?ggsave
```

The `Plots` Tab is the default graphics device

## Exporting Figures | Using `ggsave()`


```r
ggplot(data, aes(x = gender, y = height, fill = gender)) +
  geom_boxplot() +
  theme_bw() +
  scale_fill_manual(values = c("green", "blue"))
```

```r
ggsave("HeightByGender.png")
```

- `ggsave` defaults to 300dpi 
- Defaults to the size of the `Plots` Tab

## Exporting Figures| Using `ggsave()`

- Change the size manually by setting the `width` and `height` attributes


```r
ggsave("HeightByGender.png", width = 18, height = 18, units = "cm")
```

- Getting the font size right can take ages
- Need to set correctly when we make the plot

## Exporting Figures | Writing Directly

- We initiate another graphics device using `png()`, `jpeg()`, `pdf()` etc.
- Turn the device off after creating the image using `dev.off()`
- Nothing will appear in the `Plots` tab

## Exporting Figures | Writing Directly


```r
png("HeightByGender.png", width = 18, height = 18, units = "cm", 
    res = 300)
ggplot(data, aes(x = gender, y = height, fill = gender)) +
  geom_boxplot() +
  theme_bw() +
  theme(text = element_text(size = 16)) +
  scale_fill_manual(values = c("green", "blue"))
dev.off()
```

## Exporting Figures | Writing Directly

Try to decide how big the plot will be in your final document

- Export using that size

## Multiple Plots

To make multiple plots/subplots, use the package `grid`

1. Save each plot as an `R` object
2. Create _viewports_ which we can "push" the plot to
3. Use the `print()` function, specifying the viewport


```r
plotHeight <- ggplot(data, aes(x = gender, y = height, fill = gender)) +
  geom_boxplot() +
  theme_bw() +
  guides(fill = FALSE)
plotWeight <- ggplot(data, aes(x = gender, y = weight, fill = gender)) +
  geom_boxplot() +
  theme_bw() 
```

## Multiple Plots

Create the _viewports_ and print

- The device has width = 1 and height = 1


```r
library(grid)
vp1 <- viewport(x = 0, y = 0, width = 0.4, just = c("left", "bottom"))
vp2 <- viewport(x = 0.4, y = 0, width = 0.6, just = c("left", "bottom"))
grid.newpage()
print(plotHeight, vp = vp1)
print(plotWeight, vp = vp2)
grid.text("A", 0.05, 0.95)
grid.text("B", 0.45, 0.95)
```

----

<img src="106_ProfessionalPlotting_files/figure-html/unnamed-chunk-24-1.png" style="display: block; margin: auto;" />

<div class="footer" style="text-align:center;width:25%">
[Home](http://uofabioinformaticshub.github.io/RAdelaide-July-2016/)
</div>
