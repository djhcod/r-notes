if (!exists(".inflation")) {
  .inflation <- getSymbols('CPIAUCNS', src = 'FRED',
                           auto.assign = FALSE)
}

# adjusts Google finance data with the monthly consumer price index
# values provided by the Federal Reserve of St. Louis
# historical prices are returned in present values
adjust <- function(data) {

  latestcpi <- last(.inflation)[[1]]
  inf.latest <- time(last(.inflation))
  months <- split(data)

  adjust_month <- function(month) {
    date <- substr(min(time(month[1]), inf.latest), 1, 7)
    coredata(month) * latestcpi / .inflation[date][[1]]
  }

  adjs <- lapply(months, adjust_month)
  adj <- do.call("rbind", adjs)
  axts <- xts(adj, order.by = time(data))
  axts[ , 5] <- Vo(data)
  axts
}
