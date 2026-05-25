use v6.d;

unit module DSL::Examples;

use JSON::Fast;

our sub resources {
    %?RESOURCES
}

#==========================================================
# Retrieval
#==========================================================
sub dsl-retrieve(:$lang = Whatever, :$workflow = Whatever, :%dsl-data!) {

    with $lang {
        die "The value of \$lang is expected to be Whatever or one of '{%dsl-data.keys.join("', '")}'."
        unless %dsl-data{$lang}:exists
    }

    die 'The value of $workflow is expected to be a string or Whatever.'
    unless $workflow.isa(Whatever) || $workflow ~~ Str:D;

    return do given ($lang, $workflow) {
        when (Whatever, Whatever) { %dsl-data }
        when $_.head ~~ Str:D && $_.tail.isa(Whatever) { %dsl-data{$_.head} }
        when $_.head.isa(Whatever) && $_.tail ~~ Str:D { %dsl-data.map(*{$_.tail}) }
        when $_.head ~~ Str:D && $_.tail ~~ Str:D { %dsl-data{$_.head}{$_.tail} }
        default { %dsl-data }
    }
}

#==========================================================
# Examples
#==========================================================
my %dsl-examples;

sub get-dsl-examples($from is copy = 'English') {
    my @known-from-languages = <bulgarian english russian>;

    # Make examples with all language
    # if $from.isa(Whatever) { }

    die "Unknown language to translate from. Known languages are {@known-from-languages.join(', ')}."
    unless $from ~~ Str:D && $from.lc ∈ @known-from-languages;

    if %dsl-examples{$from}:!exists {
        my $file = "dsl-examples-{$from.lc}.json";
        %dsl-examples{$from} = from-json(slurp(%?RESOURCES{$file}.IO))
    }

    return %dsl-examples{$from}.clone;
}

proto sub dsl-examples(|) is export {*}

multi sub dsl-examples($lang = Whatever, $workflow = Whatever, Str:D $from = 'English') {
    return dsl-examples(:$lang, :$workflow, :$from);
}

multi sub dsl-examples(:to(:l(:$lang)) = Whatever, :w(:$workflow) = Whatever, Str:D :$from = 'English') {
    my %dsl-data = get-dsl-examples($from);
    return dsl-retrieve(:$lang, :$workflow, :%dsl-data);
}

#==========================================================
# Separators
#==========================================================
my %dsl-workflow-separators;

sub get-dsl-workflow-separators() {
    if %dsl-workflow-separators.elems == 0 {
        %dsl-workflow-separators = from-json(slurp(%?RESOURCES<dsl-workflow-separators.json>.IO))
    }
    return %dsl-workflow-separators.clone;
}

proto sub dsl-workflow-separators(|) is export {*}

multi sub dsl-workflow-separators($lang = Whatever, $workflow = Whatever) {
    return dsl-workflow-separators(:$lang, :$workflow);
}

multi sub dsl-workflow-separators(:to(:l(:$lang)) = Whatever, :w(:$workflow) = Whatever) {
    my %dsl-data = get-dsl-workflow-separators();
    return dsl-retrieve(:$lang, :$workflow, :%dsl-data);
}