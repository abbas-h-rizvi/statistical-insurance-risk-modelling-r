# Copula Modelling of Insurance Claim Frequency and Severity
# Portfolio adaptation of collaborative MSc Actuarial Science coursework
# Bayes Business School

required_packages <- c("insuranceData", "copula", "fitdistrplus")

missing_packages <- required_packages[
  !sapply(required_packages, requireNamespace, quietly = TRUE)
]

if (length(missing_packages) > 0) {
  stop(
    "Please install the following packages before running this script: ",
    paste(missing_packages, collapse = ", ")
  )
}

library(insuranceData)
library(copula)
library(fitdistrplus)

# Load example motor-insurance data
data(dataCar)

# Use observations with positive claim cost
d <- subset(dataCar, claimcst0 > 0)

claim_frequency <- d$numclaims
claim_severity <- d$claimcst0

# Fit marginal distributions
fit_frequency <- fitdist(claim_frequency, "pois")
fit_severity <- fitdist(claim_severity, "lnorm")

# Transform observations using fitted marginal CDFs
u_frequency <- ppois(
  claim_frequency,
  lambda = fit_frequency$estimate
)

u_severity <- plnorm(
  claim_severity,
  meanlog = fit_severity$estimate["meanlog"],
  sdlog = fit_severity$estimate["sdlog"]
)

u <- cbind(u_frequency, u_severity)

# Fit three copula families by maximum likelihood
fit_gaussian <- fitCopula(
  normalCopula(dim = 2),
  u,
  method = "ml"
)

fit_clayton <- fitCopula(
  claytonCopula(dim = 2),
  u,
  method = "ml"
)

fit_gumbel <- fitCopula(
  gumbelCopula(dim = 2),
  u,
  method = "ml"
)

# Compare reported log-likelihoods
log_likelihoods <- c(
  Gaussian = as.numeric(logLik(fit_gaussian)),
  Clayton = as.numeric(logLik(fit_clayton)),
  Gumbel = as.numeric(logLik(fit_gumbel))
)

cat("\n--- Copula log-likelihoods ---\n")
print(log_likelihoods)

cat("\n--- Gaussian copula ---\n")
print(summary(fit_gaussian))

cat("\n--- Clayton copula ---\n")
print(summary(fit_clayton))

cat("\n--- Gumbel copula ---\n")
print(summary(fit_gumbel))
