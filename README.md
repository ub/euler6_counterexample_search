# Euler's sum of powers conjecture: 6th power counterexample search
## Introduction
 [Euler's sum of powers conjecture](https://en.wikipedia.org/wiki/Euler's_sum_of_powers_conjecture) (extension of Fermat Theorem) 
 has been proven wrong in second half of 20th century.
 
 There are known counterexamples for 4th and 5th powers found with the help of computer search. 
 Up to date there is no countexample found for 6th power yet.
 
 I.e. currently (as of November 2016) there is no A,B,C,D, E and F natural numbers known such that
 
 
A<sup>6</sup> + B<sup>6</sup> + C<sup>6</sup> + D<sup>6</sup> + E<sup>6</sup>  = F<sup>6</sup> 

In early 2016 I started my afterwork research project to apply my software engineering knowledge
to attempt as extensive search as possible with computational resources available to me.

Starting from August 2016 I spent most  of my spare afterwork time for this project. 
The code in this repo is a working prototype developed with Ruby. There's some need for some refactoring,
such as excluding gratutitous code duplication (DRYing), improving names for classes and modules, 
probably applying code design patterns and Ruby idioms to make source more
readable and understandalbe, but otherwise I consider current version as reasonably complete, tested and usable.
 
Main purpose of this Ruby code project is to serve as a prototype, testing ground 
for algorithmical optimization and verification as well as self-documentation of practical approaches. 




## Euler6CounterexampleSearch


This project is a Ruby implementation of counterexample search for Euler's conjecture
 of the sum of 6th powers. 
 
Intermediate results are persisted in relational database (sqlite3 is configured) with
the help of ActiveRecord ORM.
 
Hypothesis is an ActiveRecord model with three attributes:

 * `value`
 * `terms_count`
 * `parent`
 
 Each hypothesis is either reduced (replaced with equivalent set of subgoals:
 i.e. hypotheses with  `terms_count` decreased by 1) or refuted (proved that it could not
 be represented as a sum of `terms_count` 6th powers)
 
 A hypothesis could be true iff at least one of it's subgoals is true.
 
 Reduction is applied recursively until we find hypotheses with `terms_count` equal to 1.
 Such a hypothesis is true if it's `value` is an  exact 6th power of a natural number.
 
 
Search process consists of sequential hypotheses reduction and filtering (refutation).




### Installation
You may need to install development version of sqlite3 library and slqlite3 binary as
a prerequisite ( if it has not been installed already). On debian-based distros (ubuntu, mint, etc)
this is done with
```
$ sudo apt-get install libsqlite3-dev sqlite3
```

After checking out the repo, run `bin/setup` to install gems and setup the database. 



### Usage

#### 1. Regular search
Seed database with initial hypotheses based on 6th powers of integers in range [1, 117649):
```
$ bin/generate5
```

Here '5' in command name refers to number of 6th power summands we must find in attempt to prove the hypotheses.

You may modify hardcoded range to generate hypotheses in other interval
```ruby
      def generate
        (1...117649).each.lazy.select do |x|
```

All search stages in proper order are launched with an trivial shell script 
```
$  ./runall.sh
```

Each stage prints time it took for numerical computations and saving the results to database along with 
sizes of input and output data sets.
 
Last stage `bin/process1` also prints number of hypotheses it has confirmed (zero in the default range).
  

Use `bin/rake db:reset` to clear the database.

#### 2. Search algorithm verification with injected values
Only the first step differs. Instead of true 6th powers database is seeded with randomly generated
'pseudo 6th powers' -- numbers which actually *are* the sums of five integer 6th powers.
```
$ bin/generate_pseudo5
```

After `./runall.sh` finishes the found solutions could be printed via
```
$ bin/generate_pseudo5
```

Due to inefficiencies still left in the code some solutions are duplicated --
 To view the actual count of different solutions (confirmed hypothesis)
 you may use the following command
``` 
 bin/solutions | uniq | wc -l
```



### Development

After checking out the repo, run `bin/setup` to install dependencies. 
Then, run `rake spec` to run the tests. 
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

### Plans for improvement

1. The ruby code could be refactored to improve readability/maintainability. 
Also some optimizations are not used consistently in all possible places. 
2.  My next step would be implementing algorithms developed here 
in multi-threaded C++ code as a separate   project on Github. 
I am aiming for at least an order of magnitude efficiency gain.


### Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ub/euler6_counterexample_search.


### License

The code is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

