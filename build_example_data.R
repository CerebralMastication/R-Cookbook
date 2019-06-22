set.seed(42)

## chapter 6
batches <- data.frame( batch=factor(sample(1:3, 20, replace=TRUE)),
                       clinic=sample(c('IL','NJ','KY'), 20, replace=TRUE),
                       dosage = 'IL',
                       shrinkage = rnorm(20)
                    )
save(batches, file='./data/batches.rdata')



pred <- data.frame( pred1 = rnorm(20),
                    pred2 = rnorm(20),
                    pred3 = rnorm(20))

pred %>%
  mutate(pred4 = 4 * pred3 + rnorm(20),
         pred5 = 2 * pred2 + rnorm(20,2,2),
         pred6 = .5 * pred1 + rnorm(10,.5,.5)) %>%
  mutate(resp =  .4 + .1 * pred1 + .2 * pred2 + .3 * pred3 + .4 * pred4 + .5 * pred5 + .6 * pred6  ) ->
pred
save(pred, file='./data/pred.rdata')

## chapter 9
set.seed(5)
x <- rnorm(100, mean=1050, sd=118)
y <- x + rnorm(100, mean=15, sd=8)
save(x,y,file='./data/sat.rdata')

set.seed(9)
fav   <- sample(100:150, 20, replace = FALSE )
unfav <- fav + rnorm(20, mean=8, sd=7)
save(fav, unfav,file='./data/workers.rdata')

## chapter 11
set.seed(3)
n <- (200)
x <- rnorm(n, 2, 2)
lab <- sample( c('NJ','KY'), n, replace=TRUE)
e <- rnorm(n)
y <- 2.5 + 5 * x + e
lab_df <- data.frame(x, lab, y)
save(lab_df, file='./data/lab_df.rdata')



n <- 50
u <- rnorm(n)
e <- rnorm(n, 0, 3)
y <- 10 + 3 * u + 5 * u^2 + e
df_squared <- data.frame(u,y)
save(df_squared, file='./data/df_squared.rdata')


n <- 100
time <- runif(n) * 1.5
e <- rnorm(n, 0, .15)
z <- 2 * exp(-2 * time + e )
log_z <- log(z)
df_decay <- data.frame(time, z, log_z)
save(df_decay, file='./data/df_decay.rdata')

set.seed(2)
n  <- 30
x1 <- rnorm(n)
x2 <- rnorm(n, 3, 18)
e  <- rnorm(n, 0, 12)
y  <- 4 + 2 * x1 + 5 * x2 + e
save(x1, x2, y, file='./data/conf.rdata')

set.seed(2)
n  <- 40
x3 <- rnorm(n, 1, 10)
x4 <- rnorm(n, 3, 18)
e  <- c(rnorm(n-10, 3, 12), 51:60)
y2  <- 4 + (2 * x3)^2 + (5 * x4)^2 + e
y2[28] <- 65000

# m <- lm(y2 ~ x3 + x4 + e)
# summary(m)
# par(mfrow=(c(2,2))) # this gives us a 2x2 plot
# plot(m)

save(x4, x3, y2, file='./data/bad.rdata')

set.seed(48)
n <- 100
x <- rnorm(n)

e <- rnorm(n, 0, .5)
e1 <- e + .05 * lag(e)
e2 <- e + .25 * lag(e)

y1 <- 4 + 2 * x + e1
y2 <- 4 + 2 * x + e2
save(x, z, y1, y2, file='./data/ac.rdata')


set.seed(2)
n <- 20
u <- rnorm(n,4,2)
v <- runif(n,0,7)
w <- rnorm(n,4,2)
e <- rnorm(n,0,2)

y <- 5 + 2 * u + 3 * v + 4 * w + e
save(y, u, v, w, file='./data/pred2.rdata')

library('quantmod')
getSymbols("^GSPC", src = "yahoo", from = as.Date("1950-01-01"), to = as.Date("2017-12-31"))
GSPC_daily_returns <- periodReturn(GSPC, period='daily')
GSPC_df <- as.data.frame(GSPC_daily_returns)
names(GSPC_df) <- 'r'
GSPC_df$mon <-  factor( format(as.Date(rownames(GSPC_df)), "%b") )
GSPC_df$wday <- factor( format(as.Date(rownames(GSPC_df)), "%a") )
save(GSPC_df, file='./data/anova.rdata')


library(tidyverse)
perf <- read_csv("./data/compositePerf-2010.csv")
att.fact <- factor(rowSums(perf[,c("ATT2","ATT3","ATT4")] == "Y"))
hw.mean <- rowMeans(perf[,c("HW1","HW2","HW3","HW4")])
midterm <- perf$Mid
hw <- factor(rowSums(perf[,c("HW1","HW2","HW3","HW4")] > 0))
student_data <- tibble(att.fact, hw.mean, midterm, hw)
save(student_data, file='./data/student_data.rdata')


set.seed(2)
n <- 20
u <- rnorm(n,4,2)
v <- runif(n,0,3)
w <- rnorm(n,0,1.45)
e <- rnorm(n,0,2)

y <- 5 + 2 * u + 3 * v + 1 * w + e
save(y, u, v, w, file='./data/anova2.rdata')

## chapter 12

#
#	SummingRowsAndColumns
#
set.seed(138)

daily.prod <- matrix(sample(150:200, 5*3, replace=T), 5, 3)
colnames(daily.prod) <- c("Widgets","Gadgets","Thingys")
rownames(daily.prod) <- c("Mon", "Tue", "Wed", "Thu", "Fri")
daily.prod <- as.data.frame(daily.prod)
save(daily.prod, file='./data/daily.prod.rdata')

set.seed(1)
x <- rnorm(10)
y <- rnorm(10)
save(x,y,file='./data/xy.rdata')

set.seed(247+12)
N <- 5
df <- data.frame(
  month=sample(6:8, N, replace=T),
  day=sample(1:28, N, replace=T),
  outcome=sample(c("Win","Lose","Tie"), N, replace=T)
)
save(df, file='./data/outcome.rdata')


set.seed(8)
n <- 7
x <- rnorm(n,1,100) + 1:n
save(x, file='./data/adf.rdata')

## chapter 13
set.seed(144)
N <- 50
x <- exp(cumsum(rnorm(N,sd=0.5)))
y <- exp(cumsum(rnorm(N,sd=0.5)))
eps <- rnorm(N,sd=.25)

# Something difficult to solve: exponential, with non-normal noise
z <- (x + 10)^.7 + eps^3
save(x,y,z, file='./data/opt.rdata')

set.seed(162)
N <- 30
x <- rbeta(N, 2, 2)
y <- x + (rbeta(N,2,2) - 0.5)
save(x,y,file='./data/pca.rdata')

## diffs data
library(quantmod)

set.seed(193)

refresh.data <- function() {
  syms <- c("APC",
            "BP",
            "BRY",        # Crude and nat gas
            "CVX",
            "HES",
            "MRO",        # Integrated
            "NBL",        # Integrated
            "OXY",        # Exploration
            "ETP",        # Was SUN, which got bought by ETP
            "TOT",
            "VLO",
            "XOM" )

  getClose <- function(sym) {
    z <- Cl(getSymbols(sym, auto.assign=FALSE, return.type="xts"))
    colnames(z) <- sym
    z["2013"] }

  closeList <- lapply(syms, getClose)
  closes <- do.call(merge.xts, closeList)
  diffs.xts <<- na.omit(diff(na.omit(closes)))
  coredata(diffs.xts)
}

diffs <- refresh.data()
save(diffs, file='./data/diffs.rdata')

## chapter 14
library(quantmod)
getSymbols("CPIAUCSL", src='FRED') #CPI
cpi <- CPIAUCSL["1999/2017"]
cpi <- cpi / cpi['20010101'][[1]]  # set 2000-01-01 to 1
names(cpi) <- 'cpi'

getSymbols('IBM', from='1999-01-01', to='2017-12-31')
ibm <- IBM$IBM.Adjusted
names(ibm) <- 'ibm'

ibm.infl <- cbind(cpi, ibm)
ibm.infl <- na.spline(ibm.infl)    ## cpi is monthly and has dates that IBM does not
                                   ## spline fills those in nicely
ibm.infl <- ibm.infl["2000/2017"]  ## trim down the range. Needed to start with larger range so
                                   ## that the spline works right

ibm.infl$ibm.inf <- ibm.infl$ibm * ibm.infl$cpi
ibm.infl$cpi <- NULL

save(ibm.infl, cpi, ibm, file='./data/ibm.rdata')


set.seed(42)

N <- 250
ts1 <- arima.sim(list(ar=c(0.6,0.2)), N)
ts2 <- arima.sim(list(), N+1)
ts2 <- ts2[-1]

save(ts1, ts2, file='./data/ts_acf.rdata')



# Vanguard Long-Term Bond Index Investor (VBLTX)
# Invesco DB Commodity Tracking (DBC)

library('quantmod')
getSymbols("VBLTX", src = "yahoo", from = as.Date("2007-01-01"), to = as.Date("2017-12-31"))
getSymbols("DBC",   src = "yahoo", from = as.Date("2007-01-01"), to = as.Date("2017-12-31"))

bonds  <- na.omit(diff(log(VBLTX$VBLTX.Close)))
names(bonds) <- 'bonds'

cmdtys <- na.omit(diff(log(DBC$DBC.Close )))
names(cmdtys) <- 'cmdtys'

save(bonds, cmdtys, file='./data/bnd_cmty.Rdata')

library(tidyverse)
yield <- read_csv('https://raw.githubusercontent.com/CerebralMastication/Presentations/master/crop_yield_crosssections/data/il_corn_yield.csv')
yield <- yield %>% select(YEAR, plantedYield) %>% filter(YEAR < 2018)
yield <- zoo(yield$plantedYield, order.by=yield$YEAR)
save(yield, file='./data/yield.Rdata')


