# This file was generated, do not modify it. # hide
import StatsModels, GLM

# Define the formula with R-style syntax, e.g. "response ~ explantory_variable"
formula = StatsModels.@formula(y_density ~ x_acidity)
model = GLM.lm(formula, df)