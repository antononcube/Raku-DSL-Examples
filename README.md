# DSL::Examples

Raku data package with examples of DSL commands translations to programming code. (

The DSL examples are suitable for 
[LLM few-shot training](https://www.prompthub.us/blog/the-few-shot-prompting-guide). 
The sub `llm-example-function` provided by 
["LLM::Functions"](https://github.com/antononcube/Raku-LLM-Functions), [AAp2],
can be effectively used to create translation functions utilizing those examples.

The utilization of such LLM-translation functions is exemplified below.
Also in the presentation ["Robust LLM pipelines (Mathematica, Python, Raku)"](https://youtu.be/QOsVTCQZq_s):
- [Short introduction](https://youtu.be/QOsVTCQZq_s?t=89)
- [Detailed explanations](https://www.youtube.com/watch?v=QOsVTCQZq_s&t=2840s)

Similar translations -- with much less computational resources -- are achieved with 
grammar-based DSL translators; see 
["DSL::Translators"](https://github.com/antononcube/Raku-DSL-Translators), [AAp1].

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
    ==> deduce-type()
```
```
# Assoc(Atom((Str)), Tuple([Assoc(Atom((Str)), Assoc(Atom((Str)), Atom((Str)), 20), 1), Assoc(Atom((Str)), Tuple([Assoc(Atom((Str)), Atom((Str)), 20), Assoc(Atom((Str)), Atom((Str)), 26), Assoc(Atom((Str)), Atom((Str)), 17)]), 3), Assoc(Atom((Str)), Tuple([Assoc(Atom((Str)), Atom((Str)), 17), Assoc(Atom((Str)), Atom((Str)), 20), Assoc(Atom((Str)), Atom((Str)), 27), Assoc(Atom((Str)), Atom((Str)), 20)]), 4), Assoc(Atom((Str)), Tuple([Assoc(Atom((Str)), Atom((Str)), 20), Assoc(Atom((Str)), Atom((Str)), 23), Assoc(Atom((Str)), Atom((Str)), 15)]), 3)]), 4)
```

Tabulate all languages and available workflow examples:

```raku, results=asis
use Data::Translators;
dsl-examples().map({ $_.key X $_.value.keys }).flat(1).map({ <language workflow> Z=> $_ })».Hash.sort.Array
==> to-dataset()
==> to-html(field-names => <language workflow>)
```
<table border="1"><thead><tr><th>language</th><th>workflow</th></tr></thead><tbody><tr><td>Python</td><td>LSAMon</td></tr><tr><td>Python</td><td>QRMon</td></tr><tr><td>Python</td><td>SMRMon</td></tr><tr><td>R</td><td>LSAMon</td></tr><tr><td>R</td><td>QRMon</td></tr><tr><td>R</td><td>SMRMon</td></tr><tr><td>Raku</td><td>SMRMon</td></tr><tr><td>WL</td><td>ClCon</td></tr><tr><td>WL</td><td>LSAMon</td></tr><tr><td>WL</td><td>QRMon</td></tr><tr><td>WL</td><td>SMRMon</td></tr></tbody></table>


Get the examples for Latent Semantic Analysis (**LSA**) **Mon**adic pipeline segments in Python:

```raku
dsl-examples('Python', 'LSAMon')
    ==> deduce-type(:tally)
```
```
# Assoc(Atom((Str)), Atom((Str)), 15)
```

Make an LLM example function for translation of LSA workflow building commands:

```raku
use LLM::Functions;
my &llm-pipeline-segment = llm-example-function(dsl-examples()<WL><LSAMon>);
```
```
# LLM::Function(-> **@args, *%args { #`(Block|5857331590416) ... }, 'chatgpt')
```

Run the LLM function over a list of DSL commands: 

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
```
# Output: LSAMonUnit[aAbstracts]⟹
# Output: LSAMonMakeDocumentTermMatrix["StemmingRules"->{},"StopWords"->Automatic]⟹
# Output: LSAMonExtractTopics["NumberOfTopics"->40, Method->"NNMF"]⟹
# Output: LSAMonEchoTopicsTable[]
```

-----

## References

### Packages

[AAp1] Anton Antonov,
[DSL::Translators Raku package](https://github.com/antononcube/Raku-DSL-Translators),
(2020-2024),
[GitHub/antononcube](https://github.com/antononcube).

[AAp2] Anton Antonov,
[LLM::Functions Raku package](https://github.com/antononcube/Raku-LLM-Functions), 
(2023-2024),
[GitHub/antononcube](https://github.com/antononcube).

[AAp3] Anton Antonov,
[LLM::Prompts Raku package](https://github.com/antononcube/Raku-LLM-Prompts), 
(2023-2024),
[GitHub/antononcube](https://github.com/antononcube).

### Videos

[AAv1] Anton Antonov,
["Robust LLM pipelines (Mathematica, Python, Raku)"](https://youtu.be/QOsVTCQZq_s),
(2024),
[YouTube/AAA4prediction](https://www.youtube.com/@AAA4prediction).