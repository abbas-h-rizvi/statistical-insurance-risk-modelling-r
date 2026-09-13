# ARIMA Time-Series Modelling
# Portfolio adaptation of collaborative MSc Actuarial Science coursework
# Bayes Business School

data_file <- "ARIMAsim2.dat"

if (!file.exists(data_file)) {
  stop(
    "Data file 'ARIMAsim2.dat' was not found. ",
    "Place an authorised copy in the repository root before running this script."
  )
}

dir.create("figures", showWarnings = FALSE)

# Load three simulated series
dat <- read.table(
  data_file,
  sep = "",
  header = TRUE
)

ts_data <- ts(dat)

ts1 <- ts_data[, 1]
ts2 <- ts_data[, 2]
ts3 <- ts_data[, 3]

# Save overview plots
png(
  "figures/arima_series_overview.png",
  width = 1200,
  height = 900,
  res = 140
)
plot(ts_data, main = "Simulated Time Series")
dev.off()

# Candidate models for Series 1
fit_ts1_ar1 <- arima(ts1, order = c(1, 0, 0))
fit_ts1_ar2 <- arima(ts1, order = c(2, 0, 0))
fit_ts1_arma11 <- arima(ts1, order = c(1, 0, 1))
fit_ts1_arma21 <- arima(ts1, order = c(2, 0, 1))

cat("\n--- Series 1 candidate AIC values ---\n")
print(AIC(
  fit_ts1_ar1,
  fit_ts1_ar2,
  fit_ts1_arma11,
  fit_ts1_arma21
))

fit_ts1 <- arima(ts1, order = c(2, 0, 1))

# Candidate models for Series 2
fit_ts2_ar1 <- arima(ts2, order = c(1, 0, 0))
fit_ts2_ar2 <- arima(ts2, order = c(2, 0, 0))
fit_ts2_ma1 <- arima(ts2, order = c(0, 0, 1))
fit_ts2_ma2 <- arima(ts2, order = c(0, 0, 2))
fit_ts2_arma11 <- arima(ts2, order = c(1, 0, 1))

cat("\n--- Series 2 candidate AIC values ---\n")
print(AIC(
  fit_ts2_ar1,
  fit_ts2_ar2,
  fit_ts2_ma1,
  fit_ts2_ma2,
  fit_ts2_arma11
))

fit_ts2 <- arima(ts2, order = c(0, 0, 2))

# Candidate models for Series 3 after first differencing
fit_ts3_ima1 <- arima(ts3, order = c(0, 1, 1))
fit_ts3_ari1 <- arima(ts3, order = c(1, 1, 0))
fit_ts3_ari2 <- arima(ts3, order = c(2, 1, 0))
fit_ts3_ima2 <- arima(ts3, order = c(0, 1, 2))
fit_ts3_arima11 <- arima(ts3, order = c(1, 1, 1))

cat("\n--- Series 3 candidate AIC values ---\n")
print(AIC(
  fit_ts3_ima1,
  fit_ts3_ari1,
  fit_ts3_ari2,
  fit_ts3_ima2,
  fit_ts3_arima11
))

fit_ts3 <- arima(ts3, order = c(2, 1, 0))

# Residual Ljung-Box checks
cat("\n--- Residual Ljung-Box tests ---\n")
print(Box.test(resid(fit_ts1), type = "Ljung-Box", lag = 10))
print(Box.test(resid(fit_ts2), type = "Ljung-Box", lag = 10))
print(Box.test(resid(fit_ts3), type = "Ljung-Box", lag = 10))

# Residual diagnostic figure for selected models
png(
  "figures/arima_residual_acf.png",
  width = 1200,
  height = 900,
  res = 140
)

par(mfrow = c(3, 1))
acf(resid(fit_ts1), main = "Residual ACF: ARIMA(2,0,1)")
acf(resid(fit_ts2), main = "Residual ACF: ARIMA(0,0,2)")
acf(resid(fit_ts3), main = "Residual ACF: ARIMA(2,1,0)")

dev.off()

cat("\n--- Selected model coefficients ---\n")
print(coef(fit_ts1))
print(coef(fit_ts2))
print(coef(fit_ts3))
