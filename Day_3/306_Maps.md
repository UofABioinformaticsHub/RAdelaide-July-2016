# Plotting Maps
Steve Pederson  
22 July 2016  



# Plotting Maps

## Let's Setup The Workspace


```r
install.packages("maps")
```


```r
library(maps)
library(ggplot2)
library(dplyr)
```

## Getting the crude data

`ggplot2` has function `map_data()`


```r
world_map <- map_data("world")
```

Let's check it out


```r
head(world_map)
```

## Getting the crude data

__How big is the world map?__


```r
dim(world_map)
```

__How much information is there for each region?__


```r
table(world_map$region)
```

## Getting Australian Data


```r
aus_map <- map_data("world", region = "Australia")
```

__Now how much data do we have?__


```r
dim(aus_map)
```

So this may be low resolution...


```r
table(aus_map$subregion)
```

__Is that every region?__

## Getting Australian Data


```r
aus_map %>%
  mutate(naRegion = is.na(subregion)) %>%
  group_by(naRegion) %>%
  count()
```

So we have more data points without a `subregion` than with

Here,the `group` column corresponds to the `subregion`

The mainland is `group == 40`

## Getting Australian Data


```r
table(aus_map$group) %>% sort()
```


```r
aus_map %>%
  filter(group == 40) %>%
  tbl_df()
```

__Any thoughts on what the `group` column does?__

## Plotting the data

Without Groups


```r
ggplot(aus_map, aes(x = long, y = lat)) +
  geom_polygon() 
```

With Groups


```r
ggplot(aus_map, aes(x = long, y = lat, group  = group)) +
  geom_polygon() 
```

## Plotting the data


```r
ggplot(aus_map, aes(x = long, y = lat, 
                    group  = group, fill = subregion)) +
  geom_polygon() +
  guides(fill = FALSE) + 
  theme_bw()
```

__How can we zoom in?__

## Zooming In


```r
aus_map %>%
  filter(subregion == "Tasmania") %>%
  ggplot(aes(x = long, y = lat, 
                    group  = group, fill = as.factor(group))) +
  geom_polygon() +
  guides(fill = FALSE) + 
  theme_bw()
```

It's low resolution...

## Adding points | Arthur's Lake

This is at:

- 146$^{\circ}$ 54' 36" (Longitude)
- 41$^{\circ}$ 59' 24" (Latitude)


```r
arthur <- data_frame(long = 146 + 54/60 + 36/3600,
                     lat = -41 - 59/60 - 24/3600, 
                     group = NA,
                     order = NA, 
                     region = NA, 
                     subregion = "Arthur's Lake")
```

## Adding points | Arthur's Lake


```r
aus_map %>%
  filter(subregion == "Tasmania") %>%
  ggplot(aes(x = long, y = lat, 
                    group  = group, fill = as.factor(group))) +
  geom_polygon() +
  guides(fill = FALSE) + 
  theme_bw() +
  geom_point(aes(x = long,y = lat), data = arthur) +
  geom_text(aes(x = long, y = lat, label = subregion), 
            data = arthur,
            nudge_y = 0.1) 
```

## Adding "Roads"

Let's make a pretend road


```r
road <- data_frame(long = c(146, 146.5, 146.8),
                   lat = c(-43, -42.5, -42.3),
                   group = NA,
                   order = NA, 
                   region = NA, 
                   subregion = NA)
```


## Adding Roads


```r
aus_map %>%
  filter(subregion == "Tasmania") %>%
  ggplot(aes(x = long, y = lat, 
                    group  = group, fill = as.factor(group))) +
  geom_polygon() +
  # coord_map("mercator") +
  guides(fill = FALSE) + 
  theme_bw() +
  geom_point(aes(x = long,y = lat), data = arthur) +
  geom_text(aes(x = long, y = lat, label = subregion), 
            data = arthur,
            nudge_y = 0.1) +
  geom_line(aes(x = long,y = lat), data = road)
```

## Going Forward

- The key is finding high resolution co-ordinates
- Layering can be much more sophisticated
- States can be defined as groups (then fill them)

Useful packages might be:  
`mapdata`, `maptools`

-`maptools` can import Esri shapefiles.

