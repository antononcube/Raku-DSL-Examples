#!/usr/bin/env raku
use v6.d;

use DSL::Examples;
use LLM::Functions;
use LLM::Prompts;

#.say for |dsl-examples()<WL><QRMon>;

my $from = 'Russian';
my $conf4o = llm-configuration('chatgpt', model => 'gpt-4o', temperature => 0.4, max-tokens => 2048);
my $conf41 = llm-configuration('chatgpt', model => 'gpt-4.1-mini', temperature => 0.4, max-tokens => 2048);
my $conf53 = llm-configuration('chatgpt', model => 'gpt-5.3-chat-latest', temperature => 0.4, max-tokens => 2048);
my &llm-pipeline-segment = llm-example-function(dsl-examples(:$from)<WL><QRMon>, e => $conf41);
my $sep = dsl-workflow-separators()<WL><QRMon>;

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
        ],
        Portuguese => [
            "Use a série temporal dfTemperatureData",
            "Exiba o resumo dos dados",
            "Faça regressão quantílica com 20 nós e probabilidades: 0.03, 0.5, 0.97",
            "Use \{laranja, azul, laranja\} para plotar as curvas de regressão",
            "Use cinza para plotar os dados",
            "Gráfico de data com proporção de aspecto 1/3 e tamanho da imagem 1000",
            "Exiba o gráfico de erro com erros absolutos",
            "Use cinza claro, vermelho e vermelho para plotar os dados",
            "Use preto para plotar as curvas de regressão",
            "Exiba um gráfico de data para os outliers com proporção de aspecto 1/3 e tamanho da imagem 1000"
        ],
        Russian => [
            "Используй временной ряд dfTemperatureData",
            "Выведи сводку данных",
            "Выполни квантильную регрессию с 20 узлами и вероятностями: 0.03, 0.5, 0.97",
            "Используй \{оранжевый, синий, оранжевый\} для построения кривых регрессии",
            "Используй серый для построения данных",
            "Диаграмма по дате с соотношением сторон 1/3 и размером изображения 1000",
            "Построй график ошибок с абсолютными ошибками",
            "Используй светло-серый, красный и красный для построения данных",
            "Используй черный для построения кривых регрессии",
            "Построй диаграмму по дате для выбросов с соотношением сторон 1/3 и размером изображения 1000"
        ]
        ;

my $tStart = now;
say "Translation start...\n";

# Simple en bloc translation
#.&llm-pipeline-segment.say for %commands{$from};

# Translation per each command
my $res =
        %commands{$from}
                .map({ .&llm-pipeline-segment })
                .map({ .subst(/:i Output ':'?/):g })
                .join($sep);
say $res;

my $tEnd = now;
say "\n\t...DONE";
say "Translation time {$tEnd - $tStart}.";