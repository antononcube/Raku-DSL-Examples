# DSL::Examples

Raku data package with examples of DSL commands translations to programming code. (Suitable for LLM training.)

-----

## Installation

From [Zef ecosystem](https://raku.land):

```
zef install DSL::Examples;
```

From GitHub:

```
zef install https://github.com/antononcube/Raku-DSL-Examples.git
```

-----

## Usage examples

Get all examples:

```raku
use DSL::Examples;
use Data::TypeSystem;

dsl-examples() 
    ==> deduce-type(:tally)
```

Get the examples for Latent Semantic Analysis (**LSA**) **Mon**adic pipeline segments in Python:

```raku
dsl-examples('Python', 'LSAMon')
    ==> deduce-type(:tally)
```

Make an LLM example function for translation of LSA workflow building commands:

```raku
use LLM::Functions;
my &llm-pipeline-segment = llm-example-function(dsl-examples()<WL><LSAMon>);
```

Run the function over 

```raku
my @commands = 
"use the dataset aAbstracts",
"make the document-term matrix without stemming",
"exract 40 topics using the method non-negative matrix factorization",
"show the topics";

@commands
.map({ .&llm-pipeline-segment })
.join("⟹\n")
```

-----

## References

### Packages

[AAp1] Anton Antonov,
[LLM::Functions Raku package](https://github.com/antononcube/Raku-LLM-Functions), 
(2023-2024),
[GitHub/antononcube](https://github.com/antononcube).

[AAp2] Anton Antonov,
[LLM::Prompts Raku package](https://github.com/antononcube/Raku-LLM-Prompts), 
(2023-2024),
[GitHub/antononcube](https://github.com/antononcube).

### Videos

[AAv1] Anton Antonov,
["Robust LLM pipelines (Mathematica, Python, Raku)"](https://youtu.be/QOsVTCQZq_s),
(2024),
[YouTube/AAA4prediction](https://www.youtube.com/@AAA4prediction).