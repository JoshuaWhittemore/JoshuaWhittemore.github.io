
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

The dataset we'll work with is the ['Wine Quality'](https://archive.ics.uci.edu/ml/datasets/wine+quality) dataset from the [UCI Machine Learning Repository](https://archive.ics.uci.edu/), contributed by Cortez et al[^2].  In particular, we'll use the 'winequality-red.csv' file, which contains 1599 observations of 11 variables.  We'll work with two variables from that file in particular, 'fixed acidity' and 'density'.

'fixed acidity' - is x x x
'density' repressents x x x


We'll use the "fixed acidity" variable as the explanatory/indepenent variable, and the "density" variable as the response/dependent variable.

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
#import Downloads
#
#url = "https://archive.ics.uci.edu/static/public/186/wine+quality.zip"
#mkpath("../input")
#
#zippath = "../input/wine_quality.zip"
#
#Downloads.download(url, zippath)
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

Looking at the first five samples, they all have density that is just a little less than the density of water (1.0) and most of them are slightly acidic, since 7.0 is.  One sample is very acidic (11.2.)

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

The histogram of acidity is unimodal and moderately right skewed.  There appear to be some above a pH of 15.  The model might be improved by removing these outliers, but for now I will leave them in.

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

Now lets explore at the relationship between the two variables with a scatterplot.  We're looking for a linear relationship between the two variables.


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

The scatterplot shows a moderate, positive linear relationship between acidity and density.  Questions: does the variability look constant across x ? 

## Fitting a model

We'll use the `StatsModels` package to create an R-style regression formula, then fit a model to that formula using the `lm` method from the `GLM` (Generalized Linear Models) package.


```julia:./fit
import StatsModels, GLM

# Define the formula with R-style syntax, e.g. "response ~ explantory_variable"
formula = StatsModels.@formula(y_density ~ x_acidity)
model = GLM.lm(formula, df)
```
\show{./fit}

### Understanding the output

After fitting a model to the data, the `lm` command outputs the above table.

* The `coef` column lists the estimated regression coefficients of the model, first the estimated y-intercept and then the estimated regression coefficient for the explanatory variable, acidity.

* A t-statistic is calculated for each coefficient and the corresponding t-value is listed in the 't' column.

* The next column lists a p-value for each t-value.  This p-value is for the null hypothesis that the coefficient for acidity should be 0, i.e., that density and acidity are independent.   However, the p-value is very small, much smaller than 0.001 - it is probably as small as the GLM package can express.  This provides very strong evidence that the coefficient of acidty is not 0, and therefore suggests that there is a linear relationship between acididty and density.

* The last two columns provide 95% confidence intervals for the coefficients.  In particular, there is a 95% probability that the interval (0.000684567, 0.000763748) contains the actual value of the coefficient, $\beta$.

We can get other information about the model by applying functions to the model object.  A table of these functions can be found [here](https://juliastats.org/GLM.jl/stable/#Methods-applied-to-fitted-models).

One useful method is the 'r2' method (r-squared), which can give us an idea of the 'goodness of fit' of the model.

```julia:./r2
round(GLM.r2(model), digits=3)
```

\show{./r2}

This statistic implies that the model explains about 44.6% of the variation in density.  

# The Fitted Model

Taking the estimated coefficients output above, we can now provide the fitted model.  To 5 decimal places, it is

<!-- Writing the fitted model like this is more informative than using y = a + Bx etc. -->

$$ \widehat{\text{density}} =  0.99072 + 0.00072 \times \text{acidity}.  \qquad \text{(to 5 d.p.)} $$

We can interpret the fitted model as saying that for each unit increase in pH, the density increases by 0.00072 g/ml.


Plotting the model against the data we have

```julia:fitted-model

using LaTeXStrings

scatter(df.x_acidity, df.y_density, label="acidity vs density", xlabel="acidity", ylabel="density", 
  markershape = :circle,
  markersize = 1,
  legend=false
)

α̂, β̂ = GLM.coef(model)
plot!(fixed_acidity -> α̂ + β̂ * fixed_acidity)


savefig(joinpath(@OUTPUT, "fitted-model.svg")) # hide
```

\fig{fitted-model}


## Checking the model

A simple linear regression model, like

$$Y = \alpha + \beta x + W_i $$

A linear regression model should satisfy several assumptions in order to be valid and to be then used to make predictions or other inferences.  First, the response variables, $Y_1, Y_2, Y_i,\ldots$ are independent random variables.  Further, each response variable $Y_i$ is normally distributed with a mean of $\alpha + \beta x$ with a constant variance, $\sigma^2$.

Equivalently, we can say that these assumptions satisfied when
- There exists a linear relationship between 
- The random terms, $W_i$ are 

A residual r is the difference between an observed value and a predicted value.  They are estimates of the random terms, $W_i$.  Hence the two assumptions above are equivalent to the following assumptions:

- that the relationship between the explanatory variable and the response variable is linear.
- that the residuals have a zero mean and a constant variance.


After fitting the model, we can check these assumptions with some diagnostic plots.  First we'll look at the residuals plot.  Residual are the differences between the observed response and the predicted response, $r = y - \hat{y}$.  In effect they are estimates of the random terms, $W_i$, which are supposed be normally distributed with a zero mean and a constant variance.

The residuals plot plots the value of the residuals against the explanatory variable.
```julia:residuals
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
```

* It appears that the residuals are evenly distributed above and below the x-axis, so it seems like a reasonable assumption that the mean of the residuals is 0.

* The width of the band scatter from about 5 to 10 appears to be the same - so it's reasonable to think the variance is constant through that range.  Above 10 or so, the band narrows.  this may be due to the smaller number of samples above 10 or it might be due to an actual change in variance.  From this, the assumption of variance seems questionable.

### QQ Plot

Not only should the residuals have zero mean and constant variance, they should also be normally distributed.  We can check this assumption with a QQ plot.

```julia:qq-plot
import StatsPlots

StatsPlots.qqnorm(GLM.residuals(model), 
    qqline = :R, 
    markersize=1, 
    xlabel="Theoretical Quantiles", 
    ylabel="Standardized Residuals",
    title="QQ Plot of Residuals"
)

savefig(joinpath(@OUTPUT, "qq-plot.svg")) # hide
```

\fig{qq-plot}

From about -0.001 to 0.0025, the residuals appear to fall nicely on the line of equality.  However, outside of that range, the residuals appear to deviate systematically.  Hence the assumption that the random terms are normally distributed is questionable, especially outside of that range.

### Independence assumption

Finally, we assume that the random terms are independently distributed.  Satisfying this assumption is mostly a question of study design - how the data are collected.  However, we can plot the residuals in the order in which they were collected (row id) and check for the appearance of any pattern.

```julia:time-order-plot
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
```

\fig{time-order-plot}

Here, there does appear to be a distinct decrease in the mean residual value, by perhaps 0.002 or so.  The assumption that each residual is independent seems questionable.

## Prediction

Not all of the assumptions required for SLR appear to hold.  Nonetheless, SLR may still be robust to violations of those assumptions if the sample size is large.  With that in mind, we can go ahead an make some point and interval predictions for new values of the explanatory variable. 

To obtain a point prediction, we can simply plug in the new value of the explanatory variable into the fitted model, or equivalently, use the GLM.predict function.


```julia:./point-prediction
df_new = DataFrame(x_acidity = [7.0])

print(round.(df_new.x_acidity .* β̂ .+ α̂, digits=5))
print(round.(GLM.predict(model, df_new), digits=5))
```

\show{./point-prediction}

We can also use `GLM.predict` to obtain a prediction interval with a specific confidence level.  

```julia:./interval-prediction

round.(GLM.predict(model, df_new, level=0.95, interval=:prediction), digits=5)

```

\show{./interval-prediction}

Interpreting this interval, we expect that the interval (0.99303  0.99855) contains the true value of the density Y with a probability of 95%.

## Conclusions

The Julia language has some good tools for performing simple linear regression which are quite similar to R.  It allows the user to specify regression formulas in a similar fashion to R.





















~~~
<div style="height: 8in;"></div>
~~~

### References

[^1]: https://en.wikipedia.org/wiki/Linear_regression

[^2]: Silva, F. & Cortez, P. (2002). UCI Machine Learning Repository - Wine Quality (https://archive.ics.uci.edu/dataset/186/wine+quality).
