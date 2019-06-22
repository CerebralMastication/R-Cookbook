set.seed(42)
options(digits = 3)

library(tidyverse)
library(knitr)

knitr::opts_chunk$set(
  comment = "#>",
  messages = FALSE, 
  collapse = TRUE,
  out.width = "85%",
  fig.align = 'center',
  fig.width = 6,
  fig.asp = 0.618,  # 1 / phi
  fig.show = "hold"
)

options(dplyr.print_min = 6, dplyr.print_max = 6)

# hook_output <- knit_hooks$get("output")
# knit_hooks$set(output = function(x, options) {
#   lines <- options$output.lines
#   if (is.null(lines)) {
#     return(hook_output(x, options))  # pass to default hook
#   }
#   x <- unlist(strsplit(x, "\n"))
#   more <- "etc ..."
#   if (length(lines)==1) {      # first n lines
#     if (length(x) > lines) {   # truncate the output, but add ....
#       x <- c(head(x, lines), more)
#     }
#   } else {
#     x <- c(more, x[lines], more)
#   }
#   # paste these lines together
#   x <- paste(c(x, ""), collapse = "\n")
#   hook_output(x, options)
# })

