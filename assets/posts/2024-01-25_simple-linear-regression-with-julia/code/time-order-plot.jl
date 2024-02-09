# This file was generated, do not modify it. # hide
scatter(rownumber.(eachrow(df)), GLM.residuals(model),
  xlabel="observation id", 
  ylabel="residual", 
  xticks=0:200:1600,
  yticks=-0.006:0.001:0.006,
  title="Residuals vs. Sample Index",
  msize=1,
  legend=false
)

savefig(joinpath(@OUTPUT, "time-order-plot.svg")) # hide