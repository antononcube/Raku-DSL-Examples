#!/usr/bin/env raku
use v6.d;

use DSL::Examples;
use LLM::Functions;
use LLM::Prompts;

#.say for |dsl-examples()<WL><QRMon>;

my $from = 'Bulgarian';
my $conf4o = llm-configuration('chatgpt', model => 'gpt-4o', temperature => 0.4, max-tokens => 1024);
my &llm-pipeline-segment = llm-example-function(dsl-examples(:$from)<WL><QRMon>);

my %commands =
        Bulgarian => [
                "Изполвай времевия ред dfTemperatureData",
                "Покажи обобщение на данните",
                "Изчисли квантилна регресия със 20 възела и вероятности: 0.03, 0.5, 0.97",
                "Ползвай \{orange, blue, orange\} за регресионните криви",
                "Данните да бъдат показин във сиво",
                "Графика с аспектна пропорция 1/3 и ширина 1000",
                "Покажи графиката с грешките ползвайки абсолютни грешки",
                "Ползвай леко сиво, червено и червено за чертането на данните",
                "Ползвай черно за чертаенето на регресионните криви",
                "Покажи чертеж с времева ос на извънредните стойности с аспект пропорциа 1/3 и ширина на чертежа 1000"
        ],
        English => [
                "Use the time series dfTemperatureData",
                "Echo data summary",
                "Do quantile regression with 20 knots and probabilities: 0.03, 0.5, 0.97",
                "Use \{orange, blue, orange\} for regression curves plotting",
                "Use gray for data plotting",
                "Date plot with aspect ratio 1/3 and image size 1000",
                "Give the error plot with absolute errors",
                "Use light gray, red, and red for data plotting",
                "Use Black for regression curves plotting",
                "Give a date plot for the outliers with aspect ratio 1/3 and image size 1000"
        ]
        ;

my $tStart = now;
say "Translation start...\n";

.&llm-pipeline-segment.say for %commands{$from};

my $tEnd = now;
say "\n\t...DONE";
say "Translation time {$tEnd - $tStart}.";