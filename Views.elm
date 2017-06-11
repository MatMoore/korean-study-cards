module Views exposing (view)

import Types exposing (Model, Msg(Guess), NumberProblem)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Button =
    { numeral : Int
    , markCorrect : Bool
    , markIncorrect : Bool
    , markRealAnswer : Bool
    }


type alias NumberCard =
    { question : String
    , buttonRows : List (List Button)
    }


button : Maybe Int -> Int -> Int -> Button
button maybeGuess answer numeral =
    let
        markCorrect =
            (maybeGuess == Just numeral) && (answer == numeral)

        markIncorrect =
            (maybeGuess == Just numeral) && (answer /= numeral)

        markRealAnswer =
            (maybeGuess /= Nothing) && (not markCorrect) && (answer == numeral)
    in
        { numeral = numeral
        , markCorrect = markCorrect
        , markIncorrect = markIncorrect
        , markRealAnswer = markRealAnswer
        }


numberCard : Maybe Int -> NumberProblem -> NumberCard
numberCard maybeGuess numberProblem =
    { question = numberProblem.koreanNumber
    , buttonRows =
        [ List.range 1 3 |> List.map (button maybeGuess numberProblem.numeral)
        , List.range 4 6 |> List.map (button maybeGuess numberProblem.numeral)
        , List.range 7 9 |> List.map (button maybeGuess numberProblem.numeral)
        , [ button maybeGuess numberProblem.numeral 10 ]
        ]
    }


wrapColumn12 : Html Msg -> Html Msg
wrapColumn12 html =
    div [ class "col s12 m6" ]
        [ html ]


wrapColumn4 : Html Msg -> Html Msg
wrapColumn4 html =
    div [ class "col s4" ]
        [ html ]


wrapRow : List (Html Msg) -> Html Msg
wrapRow nodes =
    div [ class "row" ]
        nodes


buttonView : Button -> Html Msg
buttonView button =
    let
        classValue =
            if button.markCorrect then
                "waves-effect waves-light btn green"
            else if button.markIncorrect then
                "waves-effect waves-light btn red"
            else if button.markRealAnswer then
                "waves-effect waves-light btn green pulse"
            else
                "waves-effect waves-light btn blue"
    in
        a
            [ class classValue
            , href "#"
            , onClick (Guess button.numeral)
            ]
            [ toString button.numeral |> text ]
            |> wrapColumn4


buttonRowView : List Button -> Html Msg
buttonRowView buttons =
    List.map buttonView buttons |> wrapRow


cardView : List (Html Msg) -> List (Html Msg) -> Html Msg
cardView cardContents cardActions =
    div [ class "card blue-grey darken-1" ]
        [ div [ class "card-content white-text center-align" ] cardContents
        , div [ class "card-action button-grid blue lighten-3" ] cardActions
        ]


reallyBig : String -> Html Msg
reallyBig str =
    span [ class "really-big" ] [ text str ]


noChildNodes =
    text ""


numberCardView : NumberCard -> Html Msg
numberCardView card =
    cardView
        [ reallyBig card.question ]
        (List.map buttonRowView card.buttonRows)
        |> wrapColumn12


view : Model -> Html Msg
view model =
    case model.selectedProblem of
        Just problem ->
            numberCardView (numberCard model.guess problem)

        Nothing ->
            numberCardView { question = "Loading...", buttonRows = [] }
