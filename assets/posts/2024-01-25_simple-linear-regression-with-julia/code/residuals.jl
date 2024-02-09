# This file was generated, do not modify it. # hide
scatter(df.x_acidity, GLM.residuals(model), 
  label="Residuals", 
  xlabel="acidity, pH", 
  ylabel="residual density", 
  title="Residuals Plot",
  msize=1,
  legend=false
)

hline!([0], linestyle= :solid)  # Add a horizontal line at zero
savefig(joinpath(@OUTPUT, "residuals.svg")) # hide