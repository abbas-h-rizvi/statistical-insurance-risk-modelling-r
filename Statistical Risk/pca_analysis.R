# Principal Component Analysis
# Portfolio adaptation of collaborative MSc Actuarial Science coursework
# Bayes Business School

data_file <- "dataset3.txt"

if (!file.exists(data_file)) {
  stop(
    "Data file 'dataset3.txt' was not found. ",
    "Place an authorised copy in the repository root before running this script."
  )
}

dir.create("figures", showWarnings = FALSE)

# Load and inspect data
data3 <- read.table(
  data_file,
  header = TRUE
)

cat("\n--- Dataset dimensions ---\n")
print(dim(data3))

cat("\n--- Summary ---\n")
print(summary(data3))

# Standardise variables before PCA
data_scaled <- scale(data3)

# Fit PCA
pca <- prcomp(data_scaled)

cat("\n--- PCA summary ---\n")
print(summary(pca))

# Eigenvalues and cumulative variance
eigenvalues <- pca$sdev^2
cumulative_variance <- summary(pca)$importance[3, ]

cat("\n--- Eigenvalues ---\n")
print(eigenvalues)

cat("\n--- Cumulative variance explained ---\n")
print(cumulative_variance)

cat("\n--- Loadings ---\n")
print(pca$rotation)

# Scree plot
png(
  "figures/pca_scree_plot.png",
  width = 1000,
  height = 700,
  res = 140
)
plot(
  pca,
  type = "l",
  main = "PCA Scree Plot"
)
dev.off()

# Cumulative variance plot
png(
  "figures/pca_cumulative_variance.png",
  width = 1000,
  height = 700,
  res = 140
)
plot(
  cumulative_variance,
  type = "b",
  xlab = "Principal Component",
  ylab = "Cumulative Proportion of Variance",
  main = "Cumulative Variance Explained"
)
abline(h = 0.7, lty = 2)
abline(h = 0.8, lty = 2)
dev.off()

# PC1-PC2 score plot with loading vectors
loadings <- pca$rotation[, 1:2]

png(
  "figures/pca_score_loading_plot.png",
  width = 1000,
  height = 750,
  res = 140
)

plot(
  pca$x[, 1],
  pca$x[, 2],
  xlab = "PC1",
  ylab = "PC2",
  pch = 16,
  main = "PC1-PC2 Score Plot with Variable Loadings"
)

arrows(
  0, 0,
  loadings[, 1] * 5,
  loadings[, 2] * 5,
  length = 0.1,
  lwd = 2
)

text(
  loadings[, 1] * 5,
  loadings[, 2] * 5,
  labels = rownames(loadings),
  pos = 3,
  cex = 0.7
)

dev.off()
