require(stats)

centre <- function(x, type) {
  switch(type,
         mean = mean(x),
         median = median(x),
         trimmed = mean(x, trim = .1))
}
x <- 1:10

centre(x, "mean")
centre(x, "median")
centre(x, "trimmed")
