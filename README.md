
<!-- README.md is generated from README.Rmd. Please edit that file -->

# genero

<!-- badges: start -->

<!-- badges: end -->

The goal of `genero` is to ease data cleaning when it comes to augment
data with “gender” or sex assigned at birth. It uses lists of common
names in Spanish and Portuguese with frequent gender assignments.
Therefore it has many limitations and should be used with care. This
package is provided to study large populations and not individual
records.

For better methods for estimating gender in English and other languages
please use the [gender package](https://github.com/ropensci/gender/)

This package does not take into account non-binary gender identification
as of this moment. We apologize for that, we expect to have more
sensical approaches in the near future. Any ideas or feedback on how to
make it more inclusive are more than welcome.

Use this package with care and make sure it is not used for any type of
discrimination.

Make sure to check the results provided by `genero` by other means, like
manual inspection.

## Installation

You can install the released version of genero from
[CRAN](https://CRAN.R-project.org) (SOOOOOON) with:

``` r
install.packages("genero")
```

And the development version with

``` r
devtools::install_github("datasketch/genero")
```

## Example

This is a basic example which shows you how to estimate gender from
names:

``` r
library(genero)

names <- c("Juan", "Pablo", "Camila", "Mariana")
genero(names)
#> [1] "male"   "male"   "female" "female"
```

For Portuguese use the `lang = "pt"` parameter. Don’t like the results
English? Me neither, simply provide a named vector to rename results.

``` r
names <- c("Gabriela", "Ina","Luiz", "Edson")
genero(names, lang = "pt", result_as = c(male = "Homem", female = "Mulher"))
#> [1] "Mulher" "Mulher" "Homem"  "Homem"
```

It also works with data frames and composed names, and even last names.
The `genero` tries to guess whats the column with the names, if it finds
two columns with names, the first one will be
used.

``` r
names <- c("Juan Álvarez", "Juan Maria García", "Maria José", "José María", "María Rodríguez")
age <- c(23, 43, 56, 67, 24)

d <- data.frame(names = names, age = age, stringsAsFactors = FALSE)
genero(names)
#> [1] "male"   "male"   "female" "male"   "female"
```
