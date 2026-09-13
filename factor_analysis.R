# Exploratory Factor Analysis
# Portfolio adaptation of collaborative MSc Actuarial Science coursework
# Bayes Business School

data_file <- "dataset1.txt"

if (!file.exists(data_file)) {
  stop(
    "Data file 'dataset1.txt' was not found. ",
    "Place an authorised copy in the repository root before running this script."
  )
}

# Load data; first column contains subject IDs
dat <- read.table(
  data_file,
  header = TRUE,
  row.names = 1
)

# Reverse-score negatively worded items
reverse_items <- c("X1", "X9", "X10", "X11", "X12", "X22", "X25")

for (item in reverse_items) {
  dat[[item]] <- 7 - dat[[item]]
}

# Remove rows with missing values
dat <- na.omit(dat)

# Correlation matrix and eigenvalues
fa_cor <- cor(dat)
fa_eigen <- eigen(fa_cor)

cat("\n--- Eigenvalues ---\n")
print(fa_eigen$values)

cat("\n--- Cumulative variance proportion ---\n")
print(cumsum(fa_eigen$values) / ncol(dat))

# Five-factor model without rotation
fa_none <- factanal(
  x = dat,
  factors = 5,
  rotation = "none"
)

cat("\n--- Five-factor model: no rotation ---\n")
print(fa_none)

# Five-factor model with PROMAX rotation
fa_promax <- factanal(
  x = dat,
  factors = 5,
  rotation = "promax"
)

cat("\n--- Five-factor model: PROMAX rotation ---\n")
print(fa_promax, cut = 0.2)

# Bartlett factor scores
fa_scores <- factanal(
  x = dat,
  factors = 5,
  rotation = "promax",
  scores = "Bartlett"
)

cat("\n--- Bartlett factor scores ---\n")
print(head(fa_scores$scores))
