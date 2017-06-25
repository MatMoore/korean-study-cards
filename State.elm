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
            case Dict.get problemSetId (Dict.fromList model.allProblemSets) of
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


places1 : ProblemSet
places1 =
    { name = "Places I"
    , problems =
        [ { question = "방", answer = "room" }
        , { question = "책방", answer = "bookshop" }
        , { question = "공항", answer = "airport" }
        , { question = "기차역", answer = "train station" }
        , { question = "지하철역", answer = "underground station" }
        , { question = "병원", answer = "hospital" }
        , { question = "식당", answer = "restaurant" }
        , { question = "화장실", answer = "restroom" }
        , { question = "백화점", answer = "department store" }
        , { question = "호텔", answer = "hotel" }
        , { question = "커피숍", answer = "coffee shop" }
        , { question = "공원", answer = "park" }
        , { question = "은행", answer = "bank" }
        ]
    }


places2 : ProblemSet
places2 =
    { name = "Places II"
    , problems =
        [ { question = "서점", answer = "bookshop" }
        , { question = "대학교", answer = "university" }
        , { question = "대사관", answer = "embassy" }
        , { question = "도서관", answer = "library" }
        , { question = "약국", answer = "pharmacy" }
        , { question = "우체국", answer = "post office" }
        , { question = "회사", answer = "company" }
        , { question = "슈퍼마켓", answer = "supermarket" }
        , { question = "극장", answer = "cinema" }
        , { question = "문구점", answer = "stationary shop" }
        , { question = "집", answer = "house" }
        , { question = "사무실", answer = "office" }
        ]
    }


init : ( Model, Cmd Msg )
init =
    let
        model =
            { selectedProblemSet = "korean"
            , guess = Nothing
            , allProblemSets =
                [ ( "korean", questions )
                , ( "korean20-100", questions20_100 )
                , ( "sino-korean", sinoquestions )
                , ( "places1", places1 )
                , ( "places2", places2 )
                ]
            , selectedProblem = Nothing
            , otherProblems = questions.problems
            }
    in
        ( model, generateNext model )
