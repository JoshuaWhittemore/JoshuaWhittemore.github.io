# This file was generated, do not modify it. # hide
import StatsPlots

StatsPlots.qqnorm(GLM.residuals(model), 
    qqline = :R, 
    markersize=1, 
    xlabel="Theoretical Quantiles", 
    ylabel="Standardized Residuals",
    title="QQ Plot of Residuals"
)

savefig(joinpath(@OUTPUT, "qq-plot.svg")) # hide