# compareVersions

This package is in a early stage of development. It provides functionality to compare versions of R packages on CRAN and GitHub.

### Installation

You can install the current version of `compareVersions` from GitHub:
```{r}
#install.packages("devtools")
devtools::install_github("ottlngr/compareVersions")
```

### Usage

```{r}
library(compareVersions)
compare_versions("devtools")
```
