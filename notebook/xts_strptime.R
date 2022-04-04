df <- data.frame(
  dateTime = c(
    "2019-08-20 16:00:00",
    "2019-08-20 16:00:01",
    "2019-08-20 16:00:02",
    "2019-08-20 16:00:03",
    "2019-08-20 16:00:04",
    "2019-08-20 16:00:05"
  ),
  var1 = c(9, 8, 11, 14, 16, 1),
  var2 = c(3, 4, 15, 12, 11, 19),
  var3 = c(2, 11, 9, 7, 14, 1)
)

timeSeries <- as.xts(df[, 2:4], 
                     order.by = strptime(df[, 1], format = "%Y-%m-%d %H:%M:%S")
)

print(paste(min(time(timeSeries)), is.POSIXt(min(time(timeSeries))), sep = " "))
print(paste(max(time(timeSeries)), is.POSIXt(max(time(timeSeries))), sep = " "))

datetime <- Sys.time() + (86400 * 0:10)


dframe <- data.frame(c(1,2,3),c(3,4,5))

colnames(dframe) <- c('a','b')


which(dframe$a == 2)
