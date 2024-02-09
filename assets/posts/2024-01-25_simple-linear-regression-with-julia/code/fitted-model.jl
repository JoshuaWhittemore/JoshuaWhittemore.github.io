# This file was generated, do not modify it. # hide
using LaTeXStrings

scatter(df.x_acidity, df.y_density, label="acidity vs density", xlabel="acidity", ylabel="density", 
  markershape = :circle,
  markersize = 1,
  legend=false
)

α̂, β̂ = GLM.coef(model)
plot!(fixed_acidity -> α̂ + β̂ * fixed_acidity)


savefig(joinpath(@OUTPUT, "fitted-model.svg")) # hide