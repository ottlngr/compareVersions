#' Compare package versions
#'
#' Compare package versions on CRAN and GitHub.
#' @param package character, name of the package
#' @return data.frame
#' @details \code{compare_versions()} parses the package's index.html on CRAN and looks for the current version as well as URL to a GitHub repo. If the latter is found, \code{compare_versions()} tries to read to current package version from the DESCRIPTION file in the repo.
#' @author Philipp Ottolinger
#' @import RCurl
#' @import magrittr
#' @import stringr
#' @export compare_versions
#' @examples
#' #library(compareVersions)
#' compare_versions("LexisPlotR")
#' compare_versions("ggplot2")
#' compare_versions("dplyr")

compare_versions <- function(package) {
  . <- NULL
  if (!grepl(pattern = "/", x = package)) {
    cranurl <- paste("https://cran.r-project.org/web/packages/", package, "/", sep = "")
    cranfile <- getURL(cranurl)
    cranversion <- cranfile %>%
      stringr::str_extract("(?<=Version:</td>\n<td>)[0-9a-zA-Z.-]*")
    ghurl <- cranfile %>% str_extract('(?<=URL:</td>\n<td>).*') %>%
      stringr::str_extract('https://github.com.*|http://github.com.*') %>%
      stringr::str_extract('(?<=>).*') %>%
      stringr::str_extract('[^<]*')
    if (is.na(ghurl)) { message(paste("No GitHub URL found in ", package, " index.html @ CRAN.\n", sep = "")) }
    ghversion <- ghurl %>%
      stringr::str_extract("(?<=.com/).*") %>%
      paste("https://raw.githubusercontent.com/", . , "/master/DESCRIPTION", sep = "") %>%
      getURL() %>%
      str_extract("(?<=Version: ).*")
    if (is.na(ghversion)) { message(print(""))}
  } else {
    cranversion <- stringr::str_extract(package, '(?<=/).*') %>%
      paste("https://cran.r-project.org/web/packages/", . , "/", sep = "") %>%
      getURL() %>%
      stringr::str_extract("(?<=Version:</td>\n<td>)[0-9a-zA-Z.-]*")
    ghversion <- package %>%
      paste("https://raw.githubusercontent.com/", . , "/master/DESCRIPTION", sep = "") %>%
      getURL() %>%
      stringr::str_extract("(?<=Version: ).*")
  }
  table <- data.frame(package, cranversion, ghversion, stringsAsFactors = F) %>%
    `colnames<-`(c("Package", "CRAN", "GitHub"))
  return(table)
}
