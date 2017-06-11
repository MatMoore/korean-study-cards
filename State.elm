module State exposing (init, update, subscriptions)

import Random exposing (Generator, generate)
import Types exposing (Model, Msg(NextProblem, Guess), NumberProblem)
import Random.List exposing (choose)


generateNext : Model -> Cmd Msg
generateNext model =
    generate NextProblem (choose model.otherProblems)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NextProblem ( selectedProblem, otherProblems ) ->
            ( { model | selectedProblem = selectedProblem, otherProblems = otherProblems, guess = Nothing }, Cmd.none )

        Guess numeral ->
            if model.guess == Nothing then
                ( { model | guess = Just numeral }, Cmd.none )
            else
                ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : ( Model, Cmd Msg )
init =
    let
        model =
            { selectedProblem = Nothing
            , otherProblems =
                [ { koreanNumber = "하나", numeral = 1 }
                , { koreanNumber = "둘", numeral = 2 }
                , { koreanNumber = "셋", numeral = 3 }
                , { koreanNumber = "넷", numeral = 4 }
                , { koreanNumber = "다섯", numeral = 5 }
                , { koreanNumber = "여셧", numeral = 6 }
                , { koreanNumber = "일곱", numeral = 7 }
                , { koreanNumber = "여덟", numeral = 8 }
                , { koreanNumber = "아홉", numeral = 9 }
                , { koreanNumber = "열", numeral = 10 }
                ]
            , guess = Nothing
            }
    in
        ( model, generateNext model )
