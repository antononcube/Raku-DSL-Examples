use v6.d;

unit module DSL::Examples;

use JSON::Fast;

our sub resources {
    %?RESOURCES
}

my %dsl-examples;

sub get-dsl-examples() {
    if %dsl-examples.elems == 0 {
        %dsl-examples = from-json(slurp(%?RESOURCES<dsl-examples.json>.IO))
    }
    return %dsl-examples.clone;
}

proto sub dsl-examples(|) is export {*}

multi sub dsl-examples($lang = Whatever, $workflow = Whatever) {
    return dsl-examples(:$lang, :$workflow);
}

multi sub dsl-examples(:l(:$lang) = Whatever, :w(:$workflow) = Whatever) {
    my %res = get-dsl-examples();

    with $lang {
        die "The value of \$lang is expected to be Whatever or one of '{%res.keys.join("', '")}'."
        unless %res{$lang}:exists
    }

    die 'The value of $workflow is expected to be a string or Whatever.'
    unless $workflow.isa(Whatever) || $workflow ~~ Str:D;

    return do given ($lang, $workflow) {
        when (Whatever, Whatever) { %res }
        when $_.head ~~ Str:D && $_.tail.isa(Whatever) { %res{$_.head} }
        when $_.head.isa(Whatever) && $_.tail ~~ Str:D { %res.map(*{$_.tail}) }
        when $_.head ~~ Str:D && $_.tail ~~ Str:D { %res{$_.head}{$_.tail} }
        default { %res }
    }
}

