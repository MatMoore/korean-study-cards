module State exposing (init, update, subscriptions)

import Random exposing (Generator, generate)
import Types exposing (Model, Msg(NextProblem, Guess, PickNew), NumberProblem)
import Random.List exposing (choose)
import Delay exposing (after)
import Maybe.Extra exposing (toList)


{-| Has a correct guess been made?
    Returns False if the user didn't guess yet, or they guesssed incorrectly.
-}
correctGuess : Model -> Bool
correctGuess model =
    (model.guess /= Nothing)
        && (model.guess == Maybe.map .numeral model.selectedProblem)


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

        PickNew ->
            ( model, generateNext model )

        Guess numeral ->
            if model.guess == Nothing then
                let
                    newModel =
                        { model | guess = Just numeral }

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


koreanNumbers : List NumberProblem
koreanNumbers =
    [ { koreanNumber = "하나", numeral = 1 }
    , { koreanNumber = "둘", numeral = 2 }
    , { koreanNumber = "셋", numeral = 3 }
    , { koreanNumber = "넷", numeral = 4 }
    , { koreanNumber = "다섯", numeral = 5 }
    , { koreanNumber = "여섯", numeral = 6 }
    , { koreanNumber = "일곱", numeral = 7 }
    , { koreanNumber = "여덟", numeral = 8 }
    , { koreanNumber = "아홉", numeral = 9 }
    , { koreanNumber = "열", numeral = 10 }
    ]


sinoKoreanNumbers : List NumberProblem
sinoKoreanNumbers =
    [ { koreanNumber = "일", numeral = 1 }
    , { koreanNumber = "이", numeral = 2 }
    , { koreanNumber = "삼", numeral = 3 }
    , { koreanNumber = "사", numeral = 4 }
    , { koreanNumber = "오", numeral = 5 }
    , { koreanNumber = "육", numeral = 6 }
    , { koreanNumber = "칠", numeral = 7 }
    , { koreanNumber = "팔", numeral = 8 }
    , { koreanNumber = "구", numeral = 9 }
    , { koreanNumber = "십", numeral = 10 }
    ]


init : ( Model, Cmd Msg )
init =
    let
        model =
            { selectedProblem = Nothing
            , otherProblems =
                koreanNumbers ++ sinoKoreanNumbers
            , guess = Nothing
            }
    in
        ( model, generateNext model )
