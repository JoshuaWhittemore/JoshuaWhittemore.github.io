# This file was generated, do not modify it. # hide
histogram(df.y_density, label="density", xlabel="density", ylabel="count", legend=false)

savefig(joinpath(@OUTPUT, "hist2.svg")) # hide