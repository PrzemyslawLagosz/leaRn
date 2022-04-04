x <- list(1, 1, 1)
y <- list(10, 20, 30)
z <- list(100, 200, 300)

xyz <- map2(x, y, ~ .x + .y)
