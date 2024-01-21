
<!-- Where is this used? -->
@def title = "Simple Linear Regression with Julia"

<!-- apparrently this is necessary if you want syntax highlighting to work for code snippets. -->
<!-- but my experience is that the syntax highlighting works either way, so... -->

@def hascode = true

<!-- this is necessary for what?? -->
@def hasmath = true

<!-- the following works, but I'm not sure whether I need to create the 'code' directory, or where it is? -->


```julia:./code/ex3

abstract type Point end
struct PointR2{T<:Real} <: Point
    x::T
    y::T
end
struct PointR3{T<:Real} <: Point
    x::T
    y::T
    z::T
end
function len(p::T) where T<:Point
  sqrt(sum(getfield(p, η)^2 for η ∈ fieldnames(T)))
end

1 + 1

function add(a, b)
    return a + b
end

@show add(1, 1)

```


\output{./code/ex3}


The dataset is from the [UCI Machine Learning Repository](https://archive.ics.uci.edu/dataset/186/wine+quality).[^1]

some stuff, another footnote[^blah] etc etc.

[^1]: this is the text for the first footnote, you can style all this looking at `.fndef` elements; note that the whole footnote definition is _expected to be on the same line_.

[^blah]: and this is a longer footnote with some blah from veggie ipsum: turnip greens yarrow ricebean rutabaga endive cauliflower sea lettuce kohlrabi amaranth water spinach avocado daikon napa cabbage asparagus winter purslane kale. Celery potato scallion desert raisin horseradish spinach carrot soko.


## References (not really)

* \biblabel{noether15}{Noether (1915)} **Noether**,  Körper und Systeme rationaler Funktionen, 1915.
* \biblabel{bezanson17}{Bezanson et al. (2017)} **Bezanson**, **Edelman**, **Karpinski** and **Shah**, [Julia: a fresh approach to numerical computing](https://julialang.org/research/julia-fresh-approach-BEKS.pdf), SIAM review 2017.