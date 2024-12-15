use v6.d;

unit module DSL::Examples;

use JSON::Fast;

our sub resources {
    %?RESOURCES
}

my %dsl-examples;

sub dsl-examples() is export {
    if %dsl-examples.elems == 0 {
        %dsl-examples = from-json(slurp(%?RESOURCES<dsl-examples.json>.IO))
    }
    return %dsl-examples.clone;
}