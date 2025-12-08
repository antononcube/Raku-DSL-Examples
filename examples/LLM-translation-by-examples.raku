#!/usr/bin/env raku
use v6.d;

use DSL::Examples;
use LLM::Functions;
use ML::FindTextualAnswer;

# I want to have those functions am not that willing to have a dependency on "LLM::Functions" in "DSL::Examples".
# So, maybe it is better if these functions are in "ML::TemplateEngine".

# Natural language labels to be understood by LLMs
my @mlLabels =
        'Classification', 'Latent Semantic Analysis', 'Quantile Regression', 'Recommendations',
        'Data Transformation', 'Tries with Frequencies';

# Map natural language labels to workflow names in "DSL::Examples"
my %toMonNames = @mlLabels Z=> <ClCon LSAMon QRMon SMRMon DataReshaping TriesWithFrequencies>;

# Change the result of &llm-classify result into workflow names
my &llm-ml-workflow = -> $spec { my $res = llm-classify($spec, @mlLabels, request => 'which of these workflows characterizes it'); %toMonNames{$res} // $res };

## Workflow translation
sub llm-pipeline-segment($lang, :$workflow-name = 'DataReshaping') is export {
    llm-example-function(dsl-examples(){$lang}{$workflow-name})
}

proto sub llm-examples-translation($spec, :w(:$workflow) = Whatever, :l(:$lang) = 'Raku', :s(:$split) = False) is export {*}

multi sub llm-examples-translation($spec,
                                   :w(:$workflow) is copy = Whatever,
                                   Str:D :l(:$lang) = 'Raku',
                                   Bool:D :s(:$split) = False) {

    if $workflow.isa(Whatever) { $workflow = &llm-ml-workflow($spec) }

    die 'The argument $spec is expected to be a string or Whatever.'
    unless $workflow ~~ Str:D;

    die "Cannot find workflow for {(:$lang)} and {(:$workflow)}."
    unless dsl-examples{$lang}{$workflow}:exists;

    my &llm-pipeline-segment = llm-example-function(dsl-examples(:$lang, :$workflow));

    my %langSeparator = dsl-workflow-separators;

    return do if $split {
        my @commands = $spec.lines;
        @commands.map({ .&llm-pipeline-segment }).map({ .subst(/:i Output \h* ':'?/, :g).trim }).join(%langSeparator{$lang})
    } else {
        &llm-pipeline-segment($spec).subst(";\n", %langSeparator{$lang}{$workflow}):g
    }
}

my $spec = q:to/END/;
create from @dsTitanic;
apply LSI functions IDF, None, Cosine;
recommend by profile for passengerSex:male, and passengerClass:1st;
join across with @dsTitanic on "id";
echo the pipeline value;
END

say '&llm-ml-workflow($spec) : ', &llm-ml-workflow($spec);

say "CODE:";
say llm-examples-translation($spec)