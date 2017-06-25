module Views exposing (view)

import Types exposing (Model, Msg(Guess, SelectProblemSet), ProblemSet, NumberProblem)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dict


type alias Button =
    { buttonText : String
    , markCorrect : Bool
    , markIncorrect : Bool
    , markRealAnswer : Bool
    }


type alias NumberCard =
    { question : String
    , buttonRows : List (List Button)
    }


button : Maybe String -> String -> String -> Button
button maybeGuess answer buttonText =
    let
        markCorrect =
            (maybeGuess == Just buttonText) && (answer == buttonText)

        markIncorrect =
            (maybeGuess == Just buttonText) && (answer /= buttonText)

        markRealAnswer =
            (maybeGuess /= Nothing) && (not markCorrect) && (answer == buttonText)
    in
        { buttonText = buttonText
        , markCorrect = markCorrect
        , markIncorrect = markIncorrect
        , markRealAnswer = markRealAnswer
        }


chunks : Int -> List a -> List (List a)
chunks maxLength list =
    if (maxLength == 0) || (list == []) then
        [ list ]
    else
        (List.take maxLength list) :: (List.drop maxLength list |> chunks maxLength)


{-| If a string contains numbers, sort numerically, else sort lexicographically
-}
numberwang : String -> ( Int, String )
numberwang str =
    let
        number =
            String.toInt str |> Result.withDefault 99999
    in
        ( number, str )


numberCard : Maybe String -> NumberProblem -> List NumberProblem -> NumberCard
numberCard maybeGuess numberProblem otherProblems =
    let
        allAnswers =
            numberProblem.answer :: List.map (.answer) otherProblems |> List.sortBy numberwang |> List.map (button maybeGuess numberProblem.answer)

        buttonRows =
            chunks 3 allAnswers
    in
        { question = numberProblem.question
        , buttonRows = buttonRows
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
            , onClick (Guess button.buttonText)
            ]
            [ button.buttonText |> text ]
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
    div
        []
        [ viewProblem model, viewMenu model ]


buttonForProblemSet : String -> ( String, ProblemSet ) -> Html Msg
buttonForProblemSet selectedId ( problemSetId, problemSet ) =
    let
        isChecked =
            selectedId == problemSetId

        extraAttrs =
            if isChecked then
                [ checked True ]
            else
                []

        attrs =
            [ name "problem-set", id problemSetId, type_ "radio", onClick (SelectProblemSet problemSetId), class "waves-effect waves-light btn" ]
                ++ extraAttrs
    in
        p []
            [ input
                attrs
                []
            , label [ for problemSetId ] [ text problemSet.name ]
            ]


viewMenu : Model -> Html Msg
viewMenu model =
    Html.form
        [ action "#" ]
        (List.map
            (buttonForProblemSet model.selectedProblemSet)
            (model.allProblemSets)
        )


viewProblem : Model -> Html Msg
viewProblem model =
    case model.selectedProblem of
        Just problem ->
            numberCardView (numberCard model.guess problem model.otherProblems)

        Nothing ->
            numberCardView { question = "Loading...", buttonRows = [] }
