
<!-- Where is this used? -->
@def title = "Simple Linear Regression with Julia"

<!-- apparrently this is necessary if you want syntax highlighting to work for code snippets. -->
@def hascode = false

<!-- this is necessary for what?? -->
@def hasmath = true

<!-- the following works, but I'm not sure whether I need to create the 'code' directory, or where it is? -->


```julia:./code/ex3

1 + 1

function add(a, b)
    return a + b
end

@show add(1, 1)

```


\output{./code/ex3}