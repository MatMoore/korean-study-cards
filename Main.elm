module Main exposing (..)

import Html exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Random


type alias NumberProblem =
    { koreanNumber : String
    , numeral : Int
    }


type alias Model =
    { selectedProblem : Maybe NumberProblem
    , otherProblems : List NumberProblem
    }


type Msg
    = Guess Int
    | NextProblem NumberProblem


init : ( Model, Cmd msg )
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
                , { koreanNumber = "열하나", numeral = 11 }
                ]
            }
    in
        ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    text "hello"


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
