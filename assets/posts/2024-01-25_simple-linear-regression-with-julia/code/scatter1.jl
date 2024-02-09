# This file was generated, do not modify it. # hide
scatter(df.x_acidity, df.y_density,
  title="acidity vs density", 
  xlabel="acidity", 
  ylabel="density", 
  markersize = 1, 
  legend=false
)
savefig(joinpath(@OUTPUT, "scatter1.svg")) # hide