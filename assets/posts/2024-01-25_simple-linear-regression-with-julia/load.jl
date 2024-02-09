# This file was generated, do not modify it. # hide
using DataFrames
import CSV


df = DataFrame(CSV.File("../input/winequality-red.csv"))
select!(df, "density" => :y_density, "fixed acidity" => :x_acidity)

first(df, 5)