
<!-- Where is this used? -->
@def title = "Simple Linear Regression with Julia"

<!-- apparrently this is necessary if you want syntax highlighting to work for code snippets. -->
<!-- but my experience is that the syntax highlighting works either way, so... -->

@def hascode = true

<!-- this is necessary for what?? -->
@def hasmath = true

<!-- the following works, but I'm not sure whether I need to create the 'code' directory, or where it is? -->


\toc

### Introduction

Wikipedia defines [linear regression](https://en.wikipedia.org/wiki/Linear_regression) to be "a statistical model which estimates the linear relationship between a scalar response and one or more explanatory variables (also known as dependent and independent variables)."[^1]  Simple linear regression (SLR) is a special case of linear regression where there is only one explanatory variable, as opposed to multiple linear regression which uses more than one.

The model for simple linear regression is

$$Y_i = \alpha + \beta x_i + W_i$$

Where $Y_i$ is the response variable, $x_i$ is the explanatory variable, $\alpha$ is the y-intercept, $\beta$ is the slope, and $W_i$ is the random (error) term.  The random term is assumed to be normally distributed with mean zero and constant variance $\sigma^2$, i.e. $W_i \sim N(0, \sigma^2)$.

In this post we will use Julia to perform simple linear regression.

### Dataset

The dataset we'll work with is the ['Wine Quality'](https://archive.ics.uci.edu/ml/datasets/wine+quality) dataset from the [UCI Machine Learning Repository](https://archive.ics.uci.edu/), contributed by Cortez et al[^2].  In particular, we'll use the 'winequality-red.csv' file, which contains 1599 observations of 11 variables.  We'll use the "fixed acidity" variable as the explanatory/indepenent variable, and the "density" variable as the response/dependent variable.

To get started, we'll add the packages we'll need to the environment.
  
<!-- ```julia:./packages
using Pkg

Pkg.add.(split("
  CSV
  DataFrames
  Downloads
  GLM
  LaTeXStrings
  Plots
  StatsBase
  StatsModels
  StatsPlots
  ZipFile
"))
``` -->

Next, we'll download the dataset, 

```julia:./download
import Downloads

url = "https://archive.ics.uci.edu/static/public/186/wine+quality.zip"
mkpath("../input")

zippath = "../input/wine_quality.zip"

Downloads.download(url, zippath)
```

and then unzip it.  Note that in many cases I'll choose to import a package rather than use `using` since it makes it easy to see which package a function came from.

```julia:./unzip
#import ZipFile
#
#zarchive = ZipFile.Reader(zippath)
#
#for f in zarchive.files
#  println(f.name)
#  fpath = joinpath("../input/", f.name)
#  write(fpath, read(f, String))
#end
#
#close(zarchive)
```

\show{./unzip}

Now we'll read the data into a DataFrame
```julia:./load
using DataFrames
import CSV


df = DataFrame(CSV.File("../input/winequality-red.csv"))
select!(df, "density" => :y_density, "fixed acidity" => :x_acidity)

first(df, 5)

```

\show{./load}

# Exploratory Data Analysis

Before we fit a model, we'll do some exploratory data analysis to get a feel for the data.  Looking at the explanatory variable, acidity first, we have the following summary stats:

```julia:./eda1
import StatsBase

StatsBase.describe(df.x_acidity)
```

\show{./eda1}

So the mean acidity is 8.3 and the standard deviation is 1.7.  There are no missing values.  Plotting a histogram of acidity we have.


```julia:hist1
using Plots
gr()

histogram(df.x_acidity, xlabel="acidity", ylabel="count", legend=false)

savefig(joinpath(@OUTPUT, "hist1.svg")) # hide
```

\fig{hist1}

The histogram of acidity is unimodal and moderately right skewed.  There are some outliers above a pH of 15.  The model might be improved by removing these outliers, but for now I will leave them in.

Looking at the density, the summary stats are as follows.

```julia:./eda2
import StatsBase

StatsBase.describe(df.y_density)
```

\show{./eda2}

Again there are 1599 observations with no missing values.  The mean is 0.996747 and the standard deviation is 0.001887.

```julia:hist2
histogram(df.y_density, label="density", xlabel="density", ylabel="count", legend=false)

savefig(joinpath(@OUTPUT, "hist2.svg")) # hide
```

\fig{hist2}

The histogram of density is unimodal and appears to be mostly synmmetric.

Finally, we'll look at a scatterplot of acidity vs. denisty.


```julia:scatter1

scatter(df.x_acidity, df.y_density,
  title="acidity vs density", 
  xlabel="acidity", 
  ylabel="density", 
  markersize = 1, 
  legend=false
)
savefig(joinpath(@OUTPUT, "scatter1.svg")) # hide
```

\fig{scatter1}

The scatterplot shows a moderate, positive linear relationship between acidity and density.

## Fitting a model

We'll use the `StatsModels` package to create an R-style regression formula, then fit a model to that formula using the `lm` method from the `GLM` (Generalized Linear Models) package.


```julia:./fit
import StatsModels, GLM

formula = StatsModels.@formula(y_density ~ x_acidity)
model = GLM.lm(formula, df)

println(model)

α̂, β̂ = round.(GLM.coef(model), digits=5)
@show α̂
@show β̂

@show round(GLM.r2(model), digits=2);
```
\show{./fit}

The estimated coefficients of the model are listed in the `Coef.` column of the output above.  So then the fitted model is 

$$ \widehat{\text{density}} =  0.99072 + 0.00072 \times \text{acidity}.  \qquad \text{(to 5 d.p.)} $$

This model can be interpreted as saying that for for each unit increase in acidity, the density increases by 0.00072.

In the fitting process, a t-statistic is calculated for each coefficient.  The coefficient for acidity has a corresponding t-value of 35.88, which corresponds to a very small probability, $ \lll 0.001$.  This provides strong evidence to reject the null model - which is the model where acidity is not related to density.

(say something about the confidence intervals)

The $r^2$ value tells us that the model explains 45% of the variation in the density.
















~~~
<div style="height: 8in;"></div>
~~~

### References

[^1]: https://en.wikipedia.org/wiki/Linear_regression

[^2]: Silva, F. & Cortez, P. (2002). UCI Machine Learning Repository - Wine Quality (https://archive.ics.uci.edu/dataset/186/wine+quality).
