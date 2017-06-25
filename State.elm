module State exposing (init, update, subscriptions)

import Random exposing (Generator, generate)
import Types exposing (Model, Msg(NextProblem, Guess, PickNew, SelectProblemSet), NumberProblem, ProblemSet)
import Random.List exposing (choose)
import Delay exposing (after)
import Maybe.Extra exposing (toList)
import Dict
import Debug


{-| Has a correct guess been made?
    Returns False if the user didn't guess yet, or they guesssed incorrectly.
-}
correctGuess : Model -> Bool
correctGuess model =
    (model.guess /= Nothing)
        && (model.guess == Maybe.map .answer model.selectedProblem)


generateNext : Model -> Cmd Msg
generateNext model =
    generate NextProblem (choose model.otherProblems)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NextProblem ( selectedProblem, otherProblems ) ->
            ( { model
                | selectedProblem = selectedProblem
                , otherProblems = (toList model.selectedProblem) ++ otherProblems
                , guess = Nothing
              }
            , Cmd.none
            )

        SelectProblemSet problemSetId ->
            case Dict.get problemSetId model.allProblemSets of
                Just problemSet ->
                    let
                        newModel =
                            { model | otherProblems = problemSet.problems, selectedProblem = Nothing, selectedProblemSet = problemSetId }
                    in
                        ( newModel, generateNext newModel )

                _ ->
                    ( model, Cmd.none )

        PickNew ->
            ( model, generateNext model )

        Guess answer ->
            if model.guess == Nothing then
                let
                    newModel =
                        { model | guess = Just answer }

                    delayTime =
                        if (correctGuess newModel) then
                            100
                        else
                            2000
                in
                    ( newModel, Delay.after delayTime PickNew )
            else
                ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


questions : ProblemSet
questions =
    { name = "Korean numbers 1-10"
    , problems =
        [ { question = "하나", answer = "1" }
        , { question = "둘", answer = "2" }
        , { question = "셋", answer = "3" }
        , { question = "넷", answer = "4" }
        , { question = "다섯", answer = "5" }
        , { question = "여섯", answer = "6" }
        , { question = "일곱", answer = "7" }
        , { question = "여덟", answer = "8" }
        , { question = "아홉", answer = "9" }
        , { question = "열", answer = "10" }
        ]
    }


questions20_100 : ProblemSet
questions20_100 =
    { name = "Korean numbers 20-100"
    , problems =
        [ { question = "스물", answer = "20" }
        , { question = "서른", answer = "30" }
        , { question = "마흔", answer = "40" }
        , { question = "쉰", answer = "50" }
        , { question = "예순", answer = "60" }
        , { question = "일흔", answer = "70" }
        , { question = "여든", answer = "80" }
        , { question = "아흔", answer = "90" }
        , { question = "온", answer = "100" }
        ]
    }


sinoquestions : ProblemSet
sinoquestions =
    { name = "Sino-Korean numbers 1-10"
    , problems =
        [ { question = "일", answer = "1" }
        , { question = "이", answer = "2" }
        , { question = "삼", answer = "3" }
        , { question = "사", answer = "4" }
        , { question = "오", answer = "5" }
        , { question = "육", answer = "6" }
        , { question = "칠", answer = "7" }
        , { question = "팔", answer = "8" }
        , { question = "구", answer = "9" }
        , { question = "십", answer = "10" }
        ]
    }


init : ( Model, Cmd Msg )
init =
    let
        model =
            { selectedProblemSet = "korean"
            , guess = Nothing
            , allProblemSets =
                Dict.fromList [ ( "korean", questions ), ( "korean20-100", questions20_100 ), ( "sino-korean", sinoquestions ) ]
            , selectedProblem = Nothing
            , otherProblems = questions.problems
            }
    in
        ( model, generateNext model )
