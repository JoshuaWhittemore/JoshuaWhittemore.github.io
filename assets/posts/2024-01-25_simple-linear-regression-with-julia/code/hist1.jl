# This file was generated, do not modify it. # hide
using Plots
gr()

histogram(df.x_acidity, xlabel="acidity", ylabel="count", legend=false)

savefig(joinpath(@OUTPUT, "hist1.svg")) # hide