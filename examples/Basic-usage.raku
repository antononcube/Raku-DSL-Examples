#!/usr/bin/env raku
use v6.d;

use DSL::Examples;
use LLM::Functions;
use LLM::Prompts;

#.say for |dsl-examples()<WL><QRMon>;

my $conf4o = llm-configuration('chatgpt', model => 'gpt-4o', temperature => 0.4, max-tokens => 1024);
my &llm-pipeline-segment = llm-example-function(dsl-examples()<WL><QRMon>);

my @commands =
        "Use the time series dfTemperatureData",
        "Echo data summary",
        "Do quantile regression with 20 knots and probabilities: 0.03, 0.5, 0.97",
        "Use \{orange, blue, orange\} for regression curves plotting",
        "Use gray for data plotting",
        "Date plot with aspect ratio 1/3 and image size 1000",
        "Give the error plot with absolute errors",
        "Use light gray, red, and red for data plotting",
        "Use Black for regression curves plotting",
        "Give a date plot for the outliers with aspect ratio 1/3 and image size 1000";

my $tStart = now;
say "Translation start...\n";

.&llm-pipeline-segment.say for @commands;

my $tEnd = now;
say "\..DONE";
say "Translation time {$tEnd - $tStart}.";