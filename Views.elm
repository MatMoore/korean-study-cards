module Views exposing (view)

import Types exposing (Model, Msg, NumberProblem)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Button =
    { numeral : Int
    , isCorrect : Bool
    }


type alias NumberCard =
    { question : String
    , buttonRows : List (List Button)
    }


button : Int -> Int -> Button
button answer numeral =
    { numeral = numeral
    , isCorrect = answer == numeral
    }


numberCard : NumberProblem -> NumberCard
numberCard numberProblem =
    { question = numberProblem.koreanNumber
    , buttonRows =
        [ List.range 1 3 |> List.map (button numberProblem.numeral)
        , List.range 4 6 |> List.map (button numberProblem.numeral)
        , List.range 7 9 |> List.map (button numberProblem.numeral)
        , [ button numberProblem.numeral 10 ]
        ]
    }


wrapColumn : Html Msg -> Html Msg
wrapColumn html =
    div [ class "col s12 m6" ]
        [ html ]


cardView : Html Msg -> Html Msg -> Html Msg
cardView cardContent cardAction =
    div [ class "card blue-grey darken-1" ]
        [ div [ class "card-content white-text" ] [ cardContent ]
        , div [ class "card-action button-grid" ] [ cardAction ]
        ]


reallyBig : String -> Html Msg
reallyBig str =
    span [ class "really-big" ] [ text str ]


noChildNodes =
    text ""


numberCardView : NumberCard -> Html Msg
numberCardView card =
    cardView (reallyBig card.question) noChildNodes |> wrapColumn


view : Model -> Html Msg
view model =
    case model.selectedProblem of
        Just problem ->
            numberCardView (numberCard problem)

        Nothing ->
            numberCardView { question = "Loading...", buttonRows = [] }
