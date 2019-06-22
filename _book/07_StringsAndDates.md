




# Strings and Dates {#StringsAndDates}

Introduction {-#I_sect17_d1e17434}
------------

Strings? Dates? In a statistical programming package?

As soon as you read files or print reports, you need strings. When you
work with real-world problems, you need dates.

R has facilities for both strings and dates. They are clumsy compared to
string-oriented languages such as Perl, but then it’s a matter of the
right tool for the job. We wouldn’t want to perform logistic regression
in Perl. 

Some of this clunkyness with strings and dates has been improved through the tidyverse packages `stringr` and `lubridate`. As with other chapters in this book, the examples here will pull from both Base R as well as add-on packages that make life easier, faster, and more convenient. 

### Classes for Dates and Times {-}

R has a variety of classes for working with dates and times, which is
nice if you prefer having a choice but annoying if you prefer living
simply. There is a critical distinction among the classes: some are
date-only classes, some are datetime classes. All classes can handle
calendar dates (e.g., March 15, 2019), but not all can represent a
datetime (11:45 AM on March 1, 2019).

The following classes are included in the base distribution of R:

`Date`

:   The `Date` class can represent a calendar date but not a clock time.
    It is a solid, general-purpose class for working with dates,
    including conversions, formatting, basic date arithmetic, and
    time-zone handling. Most of the date-related recipes in this book
    are built on the `Date` class.

`POSIXct`

:   This is a datetime class, and it can represent a moment in time with
    an accuracy of one second. Internally, the datetime is stored as the
    number of seconds since January 1, 1970, and so it's a very
    compact representation. This class is recommended for storing
    datetime information (e.g., in data frames).

`POSIXlt`

:   This is also a datetime class, but the representation is stored in a
    nine-element list that includes the year, month, day, hour, minute,
    and second. This representation makes it easy to extract date parts,
    such as the month or hour. Obviously, this is much
    less compact than the `POSIXct` class; hence, it is normally used for
    intermediate processing and not for storing data.

The base distribution also provides functions for easily converting
between representations: `as.Date`, `as.POSIXct`, and `as.POSIXlt`.

The following helpful packages are available for downloading from CRAN:

`chron`

:   The `chron` package can represent both dates and times but without
    the added complexities of handling time zones and Daylight Saving
    Time. It’s therefore easier to use than `Date` but less powerful
    than `POSIXct` and `POSIXlt`. It would be useful for work in
    econometrics or time series analysis.

`lubridate`

:   This is a tidyverse package designed to
    make working with dates and times easier while keeping the important
    bells and whistles such as time zones. It’s especially clever
    regarding datetime arithmetic. This package introduces some helpful constructs like durations, periods, and intervals. `lubridate` is part of the tidyverse, so it is installed when you `install.packages('tidyverse')` but it is not part of "core tidyverse," so it does not get loaded when you run `library(tidyverse)`. This means you must explicitly load it by running `library(lubridate)`. 

`mondate`

:   This is a specialized package for handling dates in units of months
    in addition to days and years. It can be helpful in accounting and
    actuarial work, for example, where month-by-month calculations
    are needed.

`timeDate`

:   This is a high-powered package with well-thought-out facilities for
    handling dates and times, including date arithmetic, business days,
    holidays, conversions, and generalized handling of time zones. It
    was originally part of the `Rmetrics` software for financial modeling,
    where precision in dates and times is critical. If you have a
    demanding need for date facilities, consider this package.

Which class should you select? The article [“Date and Time Classes in R”
by Gabor Grothendieck and Thomas Petzoldt](https://cran.r-project.org/doc/Rnews/Rnews_2004-1.pdf) offers this general advice:

> When considering which class to use, always choose the least complex
> class that will support the application. That is, use `Date` if
> possible, otherwise use `chron` and otherwise use the POSIX classes.
> Such a strategy will greatly reduce the potential for error and
> increase the reliability of your application.

### See Also {-}

See `help(DateTimeClasses)` for more details regarding the built-in
facilities. See the June 2004 article
[“Date and Time Classes in R”](http://cran.r-project.org/doc/Rnews/Rnews_2004-1.pdf)
by Gabor Grothendieck and Thomas Petzoldt for a great introduction to the date
and time facilities.
The June 2001 article
[“Date-Time Classes”](http://cran.r-project.org/doc/Rnews/Rnews_2001-2.pdf)
by Brian Ripley and Kurt Hornik discusses the two POSIX classes in particular.
Chapter 16, ["Dates and Times"](http://r4ds.had.co.nz/dates-and-times.html), from the book _R for Data Science_ by Garrett Grolemund and Hadley Wickham provides a great intro to `lubridate`.


Getting the Length of a String {#recipe-id093}
------------------------------

### Problem {-#problem-id093}

You want to know the length of a string.

### Solution {-#solution-id093}

Use the `nchar` function, not the `length` function.

### Discussion {-#discussion-id093}

The `nchar` function takes a string and returns the number of characters
in the string:


```r
nchar("Moe")
#> [1] 3
nchar("Curly")
#> [1] 5
```

If you apply `nchar` to a vector of strings, it returns the length of
each string:


```r
s <- c("Moe", "Larry", "Curly")
nchar(s)
#> [1] 3 5 5
```

You might think the `length` function returns the length of a string.
Nope. It returns the length of a *vector*. When you apply the `length`
function to a single string, R returns the value `1` because it views that
string as a singleton vector—a vector with one element:


```r
length("Moe")
#> [1] 1
length(c("Moe", "Larry", "Curly"))
#> [1] 3
```

Concatenating Strings {#recipe-id040}
---------------------

### Problem {-#problem-id040}

You want to join together two or more strings into one string.

### Solution {-#solution-id040}

Use the `paste` function.

### Discussion {-#discussion-id040}

The `paste` function concatenates several strings together. In other
words, it creates a new string by joining the given strings end to end:


```r
paste("Everybody", "loves", "stats.")
#> [1] "Everybody loves stats."
```

By default, `paste` inserts a single space between pairs of strings,
which is handy if that’s what you want and annoying otherwise. The `sep`
argument lets you specify a different separator. Use an empty string
(`""`) to run the strings together without separation:


```r
paste("Everybody", "loves", "stats.", sep = "-")
#> [1] "Everybody-loves-stats."
paste("Everybody", "loves", "stats.", sep = "")
#> [1] "Everybodylovesstats."
```

It's a common idiom to want to concatenate strings together with no separator at all. The function `paste0` makes this very convenient:


```r
paste0("Everybody", "loves", "stats.")
#> [1] "Everybodylovesstats."
```


The function is very forgiving about nonstring arguments. It tries to
convert them to strings using the `as.character` function silently behind the scene:


```r
paste("The square root of twice pi is approximately", sqrt(2 * pi))
#> [1] "The square root of twice pi is approximately 2.506628274631"
```

If one or more arguments are vectors of strings, `paste` will generate
all combinations of the arguments (because of recycling):


```r
stooges <- c("Moe", "Larry", "Curly")
paste(stooges, "loves", "stats.")
#> [1] "Moe loves stats."   "Larry loves stats." "Curly loves stats."
```

Sometimes you want to join even those combinations into one big string.
The `collapse` parameter lets you define a top-level separator and
instructs `paste` to concatenate the generated strings using that
separator:


```r
paste(stooges, "loves", "stats", collapse = ", and ")
#> [1] "Moe loves stats, and Larry loves stats, and Curly loves stats"
```

Extracting Substrings {#recipe-id041}
---------------------

### Problem {-#problem-id041}

You want to extract a portion of a string according to position.

### Solution {-#solution-id041}

Use `substr(*string*,*start*,*end*)` to extract the substring that begins at
`*start*` and ends at `*end*`.

### Discussion {-#discussion-id041}

The `substr` function takes a string, a starting point, and an ending
point. It returns the substring between the starting and ending points:


```r
substr("Statistics", 1, 4) # Extract first 4 characters
#> [1] "Stat"
substr("Statistics", 7, 10) # Extract last 4 characters
#> [1] "tics"
```

Just like many R functions, `substr` lets the first argument be a vector
of strings. In that case, it applies itself to every string and returns
a vector of substrings:


```r
ss <- c("Moe", "Larry", "Curly")
substr(ss, 1, 3) # Extract first 3 characters of each string
#> [1] "Moe" "Lar" "Cur"
```

In fact, all the arguments can be vectors, in which case `substr` will
treat them as parallel vectors. From each string, it extracts the
substring delimited by the corresponding entries in the starting and
ending points. This can facilitate some useful tricks. For example, the
following code snippet extracts the last two characters from each
string; each substring starts on the penultimate character of the
original string and ends on the final character:


```r
cities <- c("New York, NY", "Los Angeles, CA", "Peoria, IL")
substr(cities, nchar(cities) - 1, nchar(cities))
#> [1] "NY" "CA" "IL"
```

You can extend this trick into mind-numbing territory by exploiting the
Recycling Rule, but we suggest you avoid the temptation.

Splitting a String According to a Delimiter {#recipe-id276}
-------------------------------------------

### Problem {-#problem-id276}

You want to split a string into substrings. The substrings are separated
by a delimiter.

### Solution {-#solution-id276}

Use `strsplit`, which takes two arguments: the string and the delimiter
of the substrings:


```r
strsplit(string, delimiter)
```

The *`delimiter`* can be either a simple string or a regular expression.

### Discussion {-#discussion-id276}

It is common for a string to contain multiple substrings separated by
the same delimiter. One example is a filepath, whose components are
separated by slashes (`/`):


```r
path <- "/home/mike/data/trials.csv"
```

We can split that path into its components by using `strsplit` with a
delimiter of `/`:


```r
strsplit(path, "/")
#> [[1]]
#> [1] ""           "home"       "mike"       "data"       "trials.csv"
```

Notice that the first “component” is actually an empty string because
nothing preceded the first slash.

Also notice that `strsplit` returns a list and that each element of the
list is a vector of substrings. This two-level structure is necessary
because the first argument can be a vector of strings. Each string is
split into its substrings (a vector), and then those vectors are returned in
a list. 

If you are operating only on a single string, you can pop out the first element like this:

```r
strsplit(path, "/")[[1]]
#> [1] ""           "home"       "mike"       "data"       "trials.csv"
```

This example splits three filepaths and returns a three-element
list:


```r
paths <- c(
  "/home/mike/data/trials.csv",
  "/home/mike/data/errors.csv",
  "/home/mike/corr/reject.doc"
)
strsplit(paths, "/")
#> [[1]]
#> [1] ""           "home"       "mike"       "data"       "trials.csv"
#> 
#> [[2]]
#> [1] ""           "home"       "mike"       "data"       "errors.csv"
#> 
#> [[3]]
#> [1] ""           "home"       "mike"       "corr"       "reject.doc"
```

The second argument of `strsplit` (the *`delimiter`* argument) is
actually much more powerful than these examples indicate. It can be a
regular expression, letting you match patterns far more complicated than
a simple string. In fact, to turn off the regular expression feature (and
its interpretation of special characters), you must include the
`fixed=TRUE` argument.

### See Also {-#see_also-id276}

To learn more about regular expressions in R, see the help page for
`regexp`. 
See O’Reilly’s [*Mastering Regular
Expressions*](http://oreilly.com/catalog/9780596528126/), by Jeffrey E.F.
Friedl, to learn more about regular expressions in general.

Replacing Substrings {#recipe-id277}
--------------------

### Problem {-#problem-id277}

Within a string, you want to replace one substring with another.

### Solution {-#solution-id277}

Use `sub` to replace the first instance of a substring:


```r
sub(old, new, string)
```

Use `gsub` to replace all instances of a substring:


```r
gsub(old, new, string)
```

### Discussion {-#discussion-id277}

The `sub` function finds the first instance of the old substring within
string and replaces it with the new substring:


```r
str <- "Curly is the smart one. Curly is funny, too."
sub("Curly", "Moe", str)
#> [1] "Moe is the smart one. Curly is funny, too."
```

`gsub` does the same thing, but it replaces *all* instances of the
substring (a global replace), not just the first:


```r
gsub("Curly", "Moe", str)
#> [1] "Moe is the smart one. Moe is funny, too."
```

To remove a substring altogether, simply set the new substring to be
empty:


```r
sub(" and SAS", "", "For really tough problems, you need R and SAS.")
#> [1] "For really tough problems, you need R."
```

The old argument can be regular expression, which allows you to match
patterns much more complicated than a simple string. This is actually
assumed by default, so you must set the `fixed=TRUE` argument if you
don’t want `sub` and `gsub` to interpret `old` as a regular expression.

### See Also {-#see_also-id277}

To learn more about regular expressions in R, see the help page for
`regexp`. See [*Mastering Regular
Expressions*](http://oreilly.com/catalog/9780596528126/) to learn more
about regular expressions in general.


Generating All Pairwise Combinations of Strings {#recipe-id109}
-----------------------------------------------

### Problem {-#problem-id109}

You have two sets of strings, and you want to generate all combinations
from those two sets (their Cartesian product).

### Solution {-#solution-id109}

Use the `outer` and `paste` functions together to generate the matrix of
all possible combinations:


```r
m <- outer(strings1, strings2, paste, sep = "")
```

### Discussion {-#discussion-id109}

The `outer` function is intended to form the outer product. However, it
allows a third argument to replace simple multiplication with any
function. In this recipe we replace multiplication with string
concatenation (`paste`), and the result is all combinations of strings.

Suppose you have four test sites and three treatments:


```r
locations <- c("NY", "LA", "CHI", "HOU")
treatments <- c("T1", "T2", "T3")
```

We can apply `outer` and `paste` to generate all combinations of test
sites and treatments like so:


```r
outer(locations, treatments, paste, sep = "-")
#>      [,1]     [,2]     [,3]    
#> [1,] "NY-T1"  "NY-T2"  "NY-T3" 
#> [2,] "LA-T1"  "LA-T2"  "LA-T3" 
#> [3,] "CHI-T1" "CHI-T2" "CHI-T3"
#> [4,] "HOU-T1" "HOU-T2" "HOU-T3"
```

The fourth argument of `outer` is passed to `paste`. In this case, we
passed `sep="-"` in order to define a hyphen as the separator between
the strings.

The result of `outer` is a matrix. If you want the combinations in a
vector instead, flatten the matrix using the `as.vector` function.

In the special case when you are combining a set with itself and order
does not matter, the result will be duplicate combinations:


```r
outer(treatments, treatments, paste, sep = "-")
#>      [,1]    [,2]    [,3]   
#> [1,] "T1-T1" "T1-T2" "T1-T3"
#> [2,] "T2-T1" "T2-T2" "T2-T3"
#> [3,] "T3-T1" "T3-T2" "T3-T3"
```
Or we can use `expand.grid` to get a pair of vectors representing all combinations:


```r
expand.grid(treatments, treatments)
#>   Var1 Var2
#> 1   T1   T1
#> 2   T2   T1
#> 3   T3   T1
#> 4   T1   T2
#> 5   T2   T2
#> 6   T3   T2
#> 7   T1   T3
#> 8   T2   T3
#> 9   T3   T3
```

But suppose we want all *unique* pairwise combinations of treatments. We
can eliminate the duplicates by removing the lower triangle (or upper
triangle). The `lower.tri` function identifies that triangle, so
inverting it identifies all elements *outside* the lower triangle:


```r
m <- outer(treatments, treatments, paste, sep = "-")
m[!lower.tri(m)]
#> [1] "T1-T1" "T1-T2" "T2-T2" "T1-T3" "T2-T3" "T3-T3"
```


### See Also {-#see_also-id109}

See Recipe \@ref(recipe-id140), ["Concatenating Strings"](#recipe-id040), for using `paste` to generate
combinations of strings.
The [`gtools` package on CRAN](https://cran.r-project.org/web/packages/gtools/index.html) has the functions `combinations` and `permutation`, which may be of help with related tasks. 

Getting the Current Date {#recipe-id045}
------------------------

### Problem {-#problem-id045}

You need to know today’s date.

### Solution {-#solution-id045}

The `Sys.Date` function returns the current date:


```r
Sys.Date()
#> [1] "2019-06-22"
```

### Discussion {-#discussion-id045}

The `Sys.Date` function returns a `Date` object. In the preceding
example it seems to return a string because the result is printed inside
double quotes. What really happened, however, is that `Sys.Date`
returned a `Date` object and then R converted that object into a string
for printing purposes. You can see this by checking the class of the
result from `Sys.Date`:


```r
class(Sys.Date())
#> [1] "Date"
```

### See Also {-#see_also-id045}

See Recipe \@ref(recipe-id044), ["Converting a Date into a String"](#recipe-id044).

Converting a String into a Date {#recipe-id043}
-------------------------------

### Problem {-#problem-id043}

You have the string representation of a date, such as `"2018-12-31"`, and
you want to convert that into a `Date` object.

### Solution {-#solution-id043}

You can use `as.Date`, but you must know the format of the string. By
default, `as.Date` assumes the string looks like *yyyy-mm-dd*. To handle
other formats, you must specify the `format` parameter of `as.Date`. Use
`format="%m/%d/%Y"` if the date is in American style, for instance.

### Discussion {-#discussion-id043}

This example shows the default format assumed by `as.Date`, which is the
ISO 8601 standard format of *yyyy-mm-dd*:


```r
as.Date("2018-12-31")
#> [1] "2018-12-31"
```

The `as.Date` function returns a `Date` object that (as in the prior recipe) is being
converted here back to a string for printing; this explains the double quotes
around the output.

The string can be in other formats, but you must provide a `format`
argument so that `as.Date` can interpret your string. See the help page
for the `stftime` function for details about allowed formats.

Being simple Americans, we often mistakenly try to convert the usual
American date format (*mm/dd/yyyy*) into a `Date` object, with these
unhappy results:


```r
as.Date("12/31/2018")
#> Error in charToDate(x): character string is not in a standard unambiguous format
```

Here is the correct way to convert an American-style date:


```r
as.Date("12/31/2018", format = "%m/%d/%Y")
#> [1] "2018-12-31"
```

Observe that the `Y` in the format string is capitalized to indicate a
four-digit year. If you’re using two-digit years, specify a lowercase `y`.

Converting a Date into a String {#recipe-id044}
-------------------------------

### Problem {-#problem-id044}

You want to convert a `Date` object into a character string, usually
because you want to print the date.

### Solution {-#solution-id044}

Use either `format` or `as.character`:


```r
format(Sys.Date())
#> [1] "2019-06-22"
as.character(Sys.Date())
#> [1] "2019-06-22"
```

Both functions allow a `format` argument that controls the formatting.
Use `format="%m/%d/%Y"` to get American-style dates, for example:


```r
format(Sys.Date(), format = "%m/%d/%Y")
#> [1] "06/22/2019"
```

### Discussion {-#discussion-id044}

The `format` argument defines the appearance of the resulting string.
Normal characters, such as slash (`/`) or hyphen (`-`) are simply copied
to the output string. Each two-letter combination of a percent sign
(`%`) followed by another character has special meaning. Some common
ones are:

`%b`  

:   Abbreviated month name (“Jan”)

`%B`  

:   Full month name (“January”)

`%d`  

:   Day as a two-digit number

`%m`  

:   Month as a two-digit number

`%y`  

:   Year without century (00–99)

`%Y`  

:   Year with century

See the help page for the `strftime` function for a complete list of
formatting codes.

Converting Year, Month, and Day into a Date {#recipe-id241}
-------------------------------------------

### Problem {-#problem-id241}

You have a date represented by its year, month, and day in different variables. You want to
merge these elements into a single `Date` object representation.

### Solution {-#solution-id241}

Use the `ISOdate` function:


```r
ISOdate(year, month, day)
```

The result is a `POSIXct` object that you can convert into a `Date`
object:


```r
year <- 2018
month <- 12
day <- 31
as.Date(ISOdate(year, month, day))
#> [1] "2018-12-31"
```

### Discussion {-#discussion-id241}

It is common for input data to contain dates encoded as three numbers:
year, month, and day. The `ISOdate` function can combine them into a
`POSIXct` object:


```r
ISOdate(2020, 2, 29)
#> [1] "2020-02-29 12:00:00 GMT"
```

You can keep your date in the `POSIXct` format. However, when working
with pure dates (not dates and times), we often convert to a `Date`
object and truncate the unused time information:


```r
as.Date(ISOdate(2020, 2, 29))
#> [1] "2020-02-29"
```

Trying to convert an invalid date results in `NA`:


```r
ISOdate(2013, 2, 29) # Oops! 2013 is not a leap year
#> [1] NA
```

`ISOdate` can process entire vectors of years, months, and days, which
is quite handy for mass conversion of input data. The following example
starts with the year/month/day numbers for the third Wednesday in
January of several years and then combines them all into `Date` objects:


```r
years <- 2010:2014
months <- rep(1, 5)
days <- 5:9
ISOdate(years, months, days)
#> [1] "2010-01-05 12:00:00 GMT" "2011-01-06 12:00:00 GMT"
#> [3] "2012-01-07 12:00:00 GMT" "2013-01-08 12:00:00 GMT"
#> [5] "2014-01-09 12:00:00 GMT"
as.Date(ISOdate(years, months, days))
#> [1] "2010-01-05" "2011-01-06" "2012-01-07" "2013-01-08" "2014-01-09"
```

Purists will note that the vector of months is redundant and that the
last expression can therefore be further simplified by invoking the
Recycling Rule:


```r
as.Date(ISOdate(years, 1, days))
#> [1] "2010-01-05" "2011-01-06" "2012-01-07" "2013-01-08" "2014-01-09"
```

You can also extend this recipe to handle year, month, day, hour,
minute, and second data by using the `ISOdatetime` function (see the
help page for details):


```r
ISOdatetime(year, month, day, hour, minute, second)
```

Getting the Julian Date {#recipe-id042}
-----------------------

### Problem {-#problem-id042}

Given a `Date` object, you want to extract the Julian date—which is, in
R, the number of days since January 1, 1970.

### Solution {-#solution-id042}

Either convert the `Date` object to an integer or use the `julian`
function:


```r
d <- as.Date("2019-03-15")
as.integer(d)
#> [1] 17970
jd <- julian(d)
jd
#> [1] 17970
#> attr(,"origin")
#> [1] "1970-01-01"
attr(jd, "origin")
#> [1] "1970-01-01"
```

### Discussion {-#discussion-id042}

A Julian “date” is simply the number of days since a more-or-less
arbitrary starting point. In the case of R, that starting point is
January 1, 1970, the same starting point as Unix systems. So the Julian
date for January 1, 1970 is zero, as shown here:


```r
as.integer(as.Date("1970-01-01"))
#> [1] 0
as.integer(as.Date("1970-01-02"))
#> [1] 1
as.integer(as.Date("1970-01-03"))
#> [1] 2
```

Extracting the Parts of a Date {#recipe-id046}
------------------------------

### Problem {-#problem-id046}

Given a `Date` object, you want to extract a date part such as the day
of the week, the day of the year, the calendar day, the calendar month,
or the calendar year.

### Solution {-#solution-id046}

Convert the `Date` object to a `POSIXlt` object, which is a list of date
parts. Then extract the desired part from that list:


```r
d <- as.Date("2019-03-15")
p <- as.POSIXlt(d)
p$mday        # Day of the month
#> [1] 15
p$mon         # Month (0 = January)
#> [1] 2
p$year + 1900 # Year
#> [1] 2019
```

### Discussion {-#discussion-id046}

The `POSIXlt` object represents a date as a list of date parts. Convert
your `Date` object to `POSIXlt` by using the `as.POSIXlt` function,
which will give you a list with these members:

`sec`

:   Seconds (0–61)

`min`

:   Minutes (0–59)

`hour`

:   Hours (0–23)

`mday`

:   Day of the month (1–31)

`mon`

:   Month (0–11)

`year`

:   Years since 1900

`wday`

:   Day of the week (0–6, 0 = Sunday)

`yday`

:   Day of the year (0–365)

`isdst`

:   Daylight Saving Time flag

Using these date parts, we can learn that April 2, 2020, is a Thursday
(`wday` = 4) and the 93rd day of the year (because `yday` = 0 on January
1):


```r
d <- as.Date("2020-04-02")
as.POSIXlt(d)$wday
#> [1] 4
as.POSIXlt(d)$yday
#> [1] 92
```

A common mistake is failing to add 1900 to the year, giving the
impression you are living a long, long time ago:


```r
as.POSIXlt(d)$year # Oops!
#> [1] 120
as.POSIXlt(d)$year + 1900
#> [1] 2020
```

Creating a Sequence of Dates {#recipe-id047}
----------------------------

### Problem {-#problem-id047}

You want to create a sequence of dates, such as a sequence of daily,
monthly, or annual dates.

### Solution {-#solution-id047}

The `seq` function is a generic function that has a version for `Date`
objects. It can create a `Date` sequence similarly to the way it creates
a sequence of numbers.

### Discussion {-#discussion-id047}

A typical use of `seq` specifies a starting date (`from`), ending date
(`to`), and increment (`by`). An increment of 1 indicates daily dates:


```r
s <- as.Date("2019-01-01")
e <- as.Date("2019-02-01")
seq(from = s, to = e, by = 1) # One month of dates
#>  [1] "2019-01-01" "2019-01-02" "2019-01-03" "2019-01-04" "2019-01-05"
#>  [6] "2019-01-06" "2019-01-07" "2019-01-08" "2019-01-09" "2019-01-10"
#> [11] "2019-01-11" "2019-01-12" "2019-01-13" "2019-01-14" "2019-01-15"
#> [16] "2019-01-16" "2019-01-17" "2019-01-18" "2019-01-19" "2019-01-20"
#> [21] "2019-01-21" "2019-01-22" "2019-01-23" "2019-01-24" "2019-01-25"
#> [26] "2019-01-26" "2019-01-27" "2019-01-28" "2019-01-29" "2019-01-30"
#> [31] "2019-01-31" "2019-02-01"
```

Another typical use specifies a starting date (`from`), increment
(`by`), and number of dates (`length.out`):


```r
seq(from = s, by = 1, length.out = 7) # Dates, one week apart
#> [1] "2019-01-01" "2019-01-02" "2019-01-03" "2019-01-04" "2019-01-05"
#> [6] "2019-01-06" "2019-01-07"
```

The increment (`by`) is flexible and can be specified in days, weeks,
months, or years:


```r
seq(from = s, by = "month", length.out = 12)   # First of the month for one year
#>  [1] "2019-01-01" "2019-02-01" "2019-03-01" "2019-04-01" "2019-05-01"
#>  [6] "2019-06-01" "2019-07-01" "2019-08-01" "2019-09-01" "2019-10-01"
#> [11] "2019-11-01" "2019-12-01"
seq(from = s, by = "3 months", length.out = 4) # Quarterly dates for one year
#> [1] "2019-01-01" "2019-04-01" "2019-07-01" "2019-10-01"
seq(from = s, by = "year", length.out = 10)    # Year-start dates for one decade
#>  [1] "2019-01-01" "2020-01-01" "2021-01-01" "2022-01-01" "2023-01-01"
#>  [6] "2024-01-01" "2025-01-01" "2026-01-01" "2027-01-01" "2028-01-01"
```

Be careful with `by="month"` near month-end. In this example, the end of
February overflows into March, which is probably not what you wanted:


```r
seq(as.Date("2019-01-29"), by = "month", len = 3)
#> [1] "2019-01-29" "2019-03-01" "2019-03-29"
```

