module Main exposing (..)

import Html exposing (program)
import Random
import Views exposing (view)
import Types exposing (Model, Msg)


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
                ]
            }
    in
        ( model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


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
