




# Simple Programming {#SimpleProgramming}

Introduction {-#intro-SimpleProgramming}
---------------------------------------

R lets you accomplish a lot without knowing anything about programming.
Programming opens the door to accomplishing more, however,
and most serious users eventually perform some level of programming,
starting simply and possibly becoming quite proficient.
While this is not a programming book, this chapter lays out some programming recipes
that R users typically find useful to begin their journey.

If you are already familiar with programming and programming languages,
a few notes here may help you quickly adapt to the technical details of R.
(If these terms are unfamiliar to you, you can skip this section.)

Typeless

:   Variables do not have a fixed type, such as integer or character,
    unlike typed languages such as C and Java. A variable could
    contain a number in one moment and a data frame in the next.

Return value

:   All functions return a value. Normally, a function returns the value
    of the last expression in its body. You can also use `return(expr)`
    anywhere within the body.

Call by value

:   Function parameters are “call by value”—in other words,
    parameters are strictly local variables, and changes
    to those variable do not affect the caller's value.

Local variables

:   You create a local variable simply by assigning a value to it.
    Explicit declaration is not required.
    When the function exits, local variables are lost.
    
Global variables

:   Global variables are held in the user's workspace.
    Within a function you can change a global variable by using the
    `<<-` assignment operator, but this is not encouraged.

Conditional execution

:   The R syntax includes an `if` statement. See `help(Control)`
    for details.

Loops

:   The R syntax also includes `for` loops, `while` loops, and
    `repeat` loops. For details, see `help(Control)`.
    
Case or switch statements

:   A special function called `switch` provides a basic case statement.
    The semantics may strike you as odd, however.
    See `help(switch)` for details.
    
Lazy evaluation

:   R does not immediately evaluate function arguments when the function is called.
    Rather, it waits until the argument is actually used within the function,
    then evaluates it. This gives the language an especially rich and powerful
    semantics. Most of the time, it's not noticeable, but occasionally
    it results in situations that are baffling to programmers familiar only
    with "eager" evaluation, where arguments are evaluated when the function is called.
    
Functional semantics

:   Functions are "first-class citizens" and can be treated like other objects:
    assigned to variables, passed to functions, printed, inspected,
    and so forth.

Object orientation

:   R supports object-oriented programming.
    In fact, there are several different paradigms for object
    orientation, which is a blessing if you enjoy having a choice
    and baffling if you don't.

Choosing Between Two Alternatives: if-else {#recipe-creating_if_logic}
----------------------------------------------------------------------

### Problem {-#problem-creating_if_logic}
You want to write a *conditional branch*
that will choose between two paths based on a simple test.

### Solution {-#solution-creating_if_logic}
An `if` block can implement conditional logic by testing a simple
condition.


```r
if (condition) {
  ## do this if condition is TRUE
} else {
  ## do this if condition is FALSE
}
```

Notice the parentheses around the condition, which are required,
and the curly braces around the subsequent two blocks of code.

### Discussion {-#discussion-creating_if_logic}
The `if` structure lets you choose between two alternative code paths by
testing some condition, such as `x == 0` or `y > 1`,
and then following one path or the other accordingly.
This `if`, for example, checks for negative numbers before calculating a square root:


```r
if (x >= 0) {
  print(sqrt(x))             # do this if x >= 0
} else {
  print("negative number")   # do this otherwise
}
```

You can chain a series of if/else structures to make a series of decisions.
Let's suppose we want a value to be cupped at 0 (no negative values) and capped at 1.
We could code that as follows:


```r
x <- -0.3

if (x < 0) {
  x <- 0
} else if (x > 1) {
  x <- 1
}

print(x)
#> [1] 0
```

It is important that the conditional test (the expression after `if`)
is a *simple* test;
that is, it must return a single, logical value of either `TRUE` or `FALSE`.
A common problem is mistakenly using a *vector* of logical values,
such as this example:


```r
x <- c(-2, -1, 0, 1, 2)

if (x < 0) {
  print("values are negative")
}
#> Warning in if (x < 0) {: the condition has length > 1 and only the first
#> element will be used
#> [1] "values are negative"
```

The problem arises because `x < 0` is ambiguous when `x` is a vector:
are you testing for *all* values being negative or *some* values being negative?
R provides the helper functions `all` and `any` to address the situation.
They take a vector of logical values and reduce them to one, single value.


```r
x <- c(-2, -1, 0, 1, 2)

if (all(x < 0)) {
  print("all are negative")
}

if (any(x < 0)) {
  print("some are negative")
}
#> [1] "some are negative"
```

### See Also {-#see_also-creating_if_logic}
The `if` structure presented here is intended for programming.
There is also a function, `ifelse` that implements
a vectorized if/else structure, useful for transforming entire vectors.
See `help(ifelse)`.


Iterating with a Loop {#recipe-for_loop}
--------------------------------------------

### Problem {-#problem-for_loop}
You want to iterate over the elements of a vector or list.

### Solution {-#solution-for_loop}
A common iteration technique uses the `for` structure.
If `v` is a vector or list, this `for` loop selects each element of `v` one by one,
assigns the element to `x`, and does something with it.


```r
for (x in v) {
  # do something with x
}
```

### Discussion {-#discussion-for_loop}
Programmers from C and Python will recoginze `for` loops.
They are less common in R but still occasionally useful.

For illustration, this `for` loop prints the first five integers and their squares.
It sets `x` to `1`, `2`, `3`, `4`, and `5` successively, executing the body of the loop each time.


```r
for (x in 1:5) {
  cat(x, x^2, "\n")
}
#> 1 1 
#> 2 4 
#> 3 9 
#> 4 16 
#> 5 25
```

We can also iterate over the *subscripts* of a vector or list,
which is useful for updating the data in place.
Here, we initialize `v` with the vector `1:5`, then update its elements
by squaring each one:


```r
v <- 1:5
for (i in 1:5) {
  v[[i]] <- v[[i]] ^ 2
}
print(v)
#> [1]  1  4  9 16 25
```

But, frankly, this also illustrates one reason why loops are less common in R
than in other programming languages.
The vectorized operations of R are fast and easy,
often eliminating the need for looping altogether.
Here is the vectorized version of the previous example:


```r
v <- 1:5
v <- v^2
print(v)
#> [1]  1  4  9 16 25
```

### See Also {-#see_also-for_loop}
Another reason loops are rare is that `map` and similar functions
can process entire vectors and lists at once,
usually more quickly and easily than a loop.
For example, see Recipe \@ref(recipe-id149), ["Applying a Function to Each List Element"](#recipe-id149),
for details on using the `purrr` package to apply functions to lists.


Defining a Function {#recipe-id117}
-----------------------------------

### Problem {-#problem-id117}

You want to define a new R function.

### Solution {-#solution-id117}

Create the function by using the `function` keyword followed by a list of
parameter names and then the function body.


```r
name <- function(param1, ..., paramN) {
          expr1
          .
          .
          .
          exprM
        }
```

Put parentheses around the parameter names.
Put curly braces around the function body,
which is a sequence of one or more expressions.
R will evaluate each expression in order and return the value of the last one,
denoted here as `*exprM*`.

### Discussion {-#discussion-id117}

Function definitions are how you tell R, “Here’s how to calculate
*this*.” For example, R does not have a built-in function for
calculating the coefficient of variation,
but we can create such a function, calling it `cv`:


```r
cv <- function(x) {
  sd(x) / mean(x)
}
```

This function has one parameter, `x`,
and the body of the function is `sd(x) / mean(x)`.

When we call the function with an argument,
R will set the parameter `x` to that value,
then evaluate the body of the function:


```r
cv(1:10)     # Set x = 1:10 and evaluate sd(x)/mean(x)
#> [1] 0.550482
```

Note that the parameter `x` is distinct from any other variable called `x`.
If you have a global variable `x` in your workspace, for example,
that `x` is distinct from this `x` and won't be affected by `cv`.
Furthermore, the parameter `x` exists only while the `cv` function
is executing and disappears after that.

A function can have more than one argument.
This function has two arguments, both integers,
and implements Euclid’s algorithm
for computing their greatest common divisor:


```r
gcd <- function(a, b) {
  if (b == 0) {
    a                # Return a to caller
  } else {
    gcd(b, a %% b)   # Recurseively call ourselves
  }
}

# What's the greatest common denominator of 14 and 21?
gcd(14, 21)
#> [1] 7
```

(This function definition is *recursive* because it calls itself when `b` is nonzero.)

Normally, the function returns the value of the last expression in the function body.
You can choose to return a value earlier, however, by writing `return(*expr*)`,
forcing the function to stop and immediately return `*expr*` to the caller.
We can illustrate this by coding `gcd` in a subtly different way using an explicit `return`. 


```r
gcd <- function(a, b) {
  if (b == 0) {
    return(a)    # Stop and return a
  }
  gcd(b, a %% b)
}
```

When parameter `b` is zero, `gcd` executes `return(a)`, returning that value immediately to the caller.

### See Also {-#see_also-id117}
Functions are a central component of R programming,
so they are covered well in books such as
[*R for Data Science*](http://shop.oreilly.com/product/0636920034407.do) by Hadley Wickham and Garrett Grolemund (O'Reilly) 
and *The Art of R Programming* by Norman Matloff (No Starch Press).


Creating a Local Variable {#recipe-variable}
--------------------------------------------

### Problem {-#problem-variable}
You want to create a variable that is *local* to a function—that is, a variable that is created inside the function, used inside the function,
and removed when the function is done.

### Solution {-#solution-variable}
Inside the function, simply assign a value to the name.
The name automatically becomes a local variable
and will be removed when the function finishes.

### Discussion {-#discussion-variable}
This function will map a vector, `x`, into the unit interval.
It requires two intermediate values, `low` and `high`.


```r
unitInt <- function(x) {
  low <- min(x)
  high <- max(x)
  (x - low) / (high - low)
}
```

The `low` and `high` values are automatically created by the assignment statements.
Because the assignments occur within the function body, the variables
are *local* to the function. That brings two important advantages.

First, the local variables named `low` and `high` are distinct from any global
variables named `low` and `high` in your workspace.
Because they are distinct, there is no "collision":
changes to the local variables do not change the global variables.

Second, local variables disappear when the function is done.
That prevents clutter and automatically frees the space they used.


Choosing Between Multiple Alternatives: switch
---------------------------------------------------

### Problem {-}
A variable can take on several different values.
You want your program to handle each case separately, according to the value.

### Solution {-}
The `switch` function will branch according a value,
letting you select how you handle each case.

### Discussion {-}
The first argument to `switch` is a value for R to consider.
The remaining arguments show how to handle each possible value.
For example, this call to `switch` considers the value of `who`,
then returns one of three possible results:


```r
hair_type = switch(who,
                   Moe = "long",
                   Larry = "fuzzy",
                   Curly = "none")
```

Notice that each expression after the initial `who` is labeled
with a possible value for `who`.
If `who` is `Moe`, then the `switch` returns `"long"`;
if it is `Larry`, the `switch` returns `"fuzzy"`;
and if `Curly`, it returns `"none"`.

Very often, you cannot anticipate all possible values to be considered,
so `switch` lets you define a default for the situation where no label matches.
Simply put the default last with no label.
This `switch`, for example, will translate the contents of `s` from
`"one"`, `"two"`, or `"three"`
into the corresponding integer. It returns `NA` for any other value.


```r
num <- switch(s,
              one = 1,
              two = 2,
              three = 3,
              NA)
```

An annoying quirk of `switch` arises when the labels are integers.
This won't do what you expect, for example.


```r
switch(i,            # Does not work the way you expect
       10 = "ten",
       20 = "twenty",
       30 = "thirty",
       "other")
```

But there is a workaround: convert the integer to a character string,
then use character strings for the labels.


```r
switch(as.character(i),
       "10" = "ten",
       "20" = "twenty",
       "30" = "thirty",
       "other")
```

### See Also {-}
See `help(switch)` for more details.

This sort of feature is quite common in other programming languages,
where it's usually called a *switch* or *case* statement.

The `switch` function works only with scalars.
Switching on the contents of a data frame is more complicated.
See the function `case_when` in the `dplyr` package
for a powerful mechanism to handle that situation.


Defining Defaults for Function Parameters {#recipe-title}
-------------------------------------------------------

### Problem {-#problem-default_params}

You want to define default parameters for a function—that is, values to use when the caller does not provide explicit arguments. 

### Solution {-#solution-default_params}

R lets you set default values for parameters by including them in the `function` definition:


```r
my_fun <- function(param = default_value) {
  ...
}
```

### Discussion {-#discussion-default_params}
Let's create a toy function that greets someone by name.


```r
greet <- function(name) {
  cat("Hello,", name, "\n")
}

greet("Fred")
#> Hello, Fred
```

If we call `greet` without a `name` argument, we get this error:


```r
greet()
#> Error in cat("Hello,", name, "\n") : 
#>   argument "name" is missing, with no default
```

We can change the function definition, however, to define a default name.
In this case, we'll default to the generic name `world`.


```r
greet <- function(name = "world") {
  cat("Hello,", name, "\n")
}
```

Now if we omit the argument, R supplies a default:


```r
greet()
#> Hello, world
```

This mechanism for defaults is handy. Nonetheless, we recommend using it judiciously.
We've seen too many cases where the function *creator* defined defaults
and the function *caller* accepted the defaults without much thought,
leading to questionable results.
For example, if you are using the *k*-nearest neighbors algorithm,
the choice of *k* is critical and providing a default makes no sense.
Sometimes it's better to force the caller to make a choice.

Signaling Errors
-------------------

### Problem {-}
When your code encounters a serious problem,
you want to halt and alert the user.

### Solution {-}
Call the `stop` function, which will print your message and terminate all processing.

### Discussion {-}
It is critical to halt processing when your code encounters fatal errors,
such as this check that an account still has a positive balance:


```r
if (balance < 0) {
  stop("Funds exhausted.")
}
```

This call to `stop` would display the message,
terminate processing, and put the user back at the console prompt:


```
#> Error in eval(expr, envir, enclos): Funds exhausted
```

Problems arise for all sorts of reasons:
bad data, user error, network failures, and bugs in code, to name a few. The list is endless.
It is important that you anticipate potential problems
and code appropriately:

* *Detect* - At a minimum, detect possible errors. Halt if further processing is impossible.
  Undetected errors are a major source of program failures.
* *Report* - If you must halt, give users a reasonable explanation of why.
  That will help them diagnose and fix the problem.
* *Recover* - In some cases, the code may be able to correct the situation
  itself and continue. We recommend, however, warning the user that your code encountered
  a problem and corrected it.
  
Error handling is part of *defensive programming*, the practice of making your code robust.

### See Also {-}
An alternative to `stop` is the `warning` function,
which prints its message and continues without halting.
Be sure, however, that it is actually reasonable to continue.

Protecting Against Errors
-------------------------

### Problem {-}
You anticipate the possibility of fatal errors,
and you want to handle them rather than halt altogether.

### Solution {-}
Use the `possibly` function to "wrap" the problematic code.
It will trap errors and let you respond to them.

### Discussion {-}
The `purrr` package contains a function called `possibly`,
which takes two parameters.
The first parameter is a function, and `possibly` will protect against failures in that function.
The second parameter is a value called `otherwise`.

A concrete example is useful here.
The `read.csv` function tries to read a file,
but it simply halts if the file does not exist.
That could be undesireable. We might want to recover and continue instead.

We can "wrap" the `read.csv` function in a protective layer this way:


```r
library(purrr)
safe_read <- possibly(read.csv, otherwise=NULL)
```

It may seem strange, but `possibly` returns a *new function*.
The new function, called `safe_read` here, behaves exactly like the old function, `read.csv`,
but with one very important difference.
When `read.csv` would fail and halt, `safe_read` will instead return the `otherwise` value (`NULL`)
and let you continue. (If `read.csv` succeeds, you get its usual result: a data frame.)

You could use `safe_read` like this to handle optional files:


```r
details = safe_read("details.csv")    # Try to read details.csv file
if (is.null(details)) {               # NULL means read.csv failed
  cat("Details are not available\n")
} else {
  print(details)                      # We got the contents!
}
```

If the *details.csv* file exists, `safe_read` returns the contents and this code will print them.
If it does not exist, then `read.csv` fails, `safe_read` returns `NULL`,
and this code prints a message.

The `otherwise` value in this case is `NULL`, but it can be anything.
It could be a data frame, for example, which provides a default.
In that case, when the *details.csv* file is unavailable, `safe_read` would return
that default.

### See Also {-}
The `purrr` package contains other functions for protecting against errors.
Check out the `safely` and `quietly` functions.

If you need even higher-powered tools, use `help(tryCatch)` to see the mechanism
behind `possibly`, which has sophisticated bells and whistles for handling
both errors and warnings. It mirrors the familiar try/catch paradigm of
other programming languages.

Creating an Anonymous Function {#recipe-anon-function}
------------------------------------------------------

### Problem {-}
You are using tidyverse functions such as `map` or `discard`
that require a function.
You want a shortcut for easily defining the required function.

### Solution {-}
Use the `function` keyword to define a function with parameters and a body,
but instead of giving the function a name, simply use its definition inline.

### Discussion {-}
It may seem strange to create a function with no name,
but it can be a handy convenience.

In Recipe \@ref(recipe-id060), ["Removing List Elements Using a Condition"](#recipe-id060), we defined a function, `is_na_or_null`,
and used it to remove `NA` and `NULL` elements from a list:


```r
is_na_or_null <- function(x) {
  is.na(x) || is.null(x)
}

lst %>%
  discard(is_na_or_null)
```

Sometimes, writing a tiny, one-off function such as `is_na_or_null` is annoying.
You can avoid that hassle by using the function definition directly,
not giving it a name:


```r
lst %>%
  discard(function(x) is.na(x) || is.null(x))
```

This kind of function is called an *anonymous function*, for the obvious reason that
it has no name.

### See Also {-}
Function definitions are described in Recipe \@ref(recipe-id117), ["Defining a Function"](#recipe-id117).

Creating a Collection of Reusable Functions
-------------------------------------------

### Problem {-}
You want to reuse one or more functions across several scripts.

### Solution {-}
Save the functions in a local file, say *myLibrary.R*, then use the `source`
function to load those functions into your script.


```r
source("myLibrary.R")
```

### Discussion {-}
Quite often, you will write functions that are useful in several scripts.
For example, you could have one function that loads, checks, and cleans your data;
now you want to reuse that function in every script that needs the data.

Most beginners simply cut and paste the reusable function into each script,
duplicating the code.
That creates a serious problem. What if you discover a bug in that duplicated code?
Or what if you must change the code to accommodate new circumstances?
You're forced to hunt down every copy and make the identical change everywhere,
an annoying and error-prone process.

Instead, create a file, say *myLibrary.R*, and save the function definition there.
The file contents could look like this:


```r
loadMyData <- function() {
  # code for data loading, checking, and cleaning here
}
```

Then, inside each script use the `source` function to read the code from the file.


```r
source("myLibrary.R")
```

When you run the script, the `source` function reads the indicated file,
just as if you'd typed the file contents there at that location in the script.
It's better than cutting and pasting because
you've isolated the function's definition into one, known place.

This example has only one function in the sourced file,
but the file can contain multiple functions, of course.
We suggest gathering related functions into their own file,
creating a group of related, reusable functions.

### See Also {-}
This recipe is a very simple method for reusing code,
appropriate for small projects.
A more powerful approach is to create your own R package of functions,
which is especially useful for collaborating with other people.
Package creation is a large topic, but getting started is pretty easy.
We suggest the excellent book *R Packages* by Hadley Wickham (O'Reilly),
available in printed form or [online](http://r-pkgs.had.co.nz).


Automatically Reindent Code {#recipe-indent}
------------------------------------------------------

### Problem {-#problem-indent}

You want to reformat your code so that it lines up nicely and is indented consistently. 

### Solution {-#solution-indent}
To consistently indent a block of code, highlight the text in RStudio,
then press Ctrl-i (Windows or Linux) or press Cmd-i (Mac). 

### Discussion {-#discussion-indent}
One of the many features of the RStudio IDE is that it helps with routine code maintenance, such as reformatting.
When you're editing code it's easy to end up with indentation that is inconsistent and a little confusing.
The IDE can fix that.

Take the following code, for example:


```r
for (i in 1:5) {
    if (i >= 3) {
  print(i**2)
} else {
  print(i * 3)
}
  }
```

While that's valid code, it can be tricky to read because of the odd indentation.
If we highlight the text in the RStudio IDE and press Ctrl-i (or Cmd-i on Mac), then our code gets consistent indentation:


```r
for (i in 1:5) {
  if (i >= 3) {
    print(i**2)
  }
  else {
    print(i * 3)
  }
}
```

### See Also {-#see_also-indent}
RStudio has several helpful features for code editing.
You can access cheat sheets by clicking Help → Cheatsheets
or by going directly to [https://www.rstudio.com/resources/cheatsheets/](https://www.rstudio.com/resources/cheatsheets/).
