module Types exposing (..)

import Dict exposing (Dict)


type alias NumberProblem =
    { koreanNumber : String
    , numeral : Int
    }


type alias ProblemSet =
    { problems : List NumberProblem
    , name : String
    }


type alias ProblemSetMenu =
    Dict String ProblemSet


type alias Model =
    { selectedProblemSet : String
    , selectedProblem : Maybe NumberProblem
    , otherProblems : List NumberProblem
    , allProblemSets : ProblemSetMenu
    , guess : Maybe Int
    }


type Msg
    = Guess Int
    | PickNew
    | SelectProblemSet String
    | NextProblem ( Maybe NumberProblem, List NumberProblem )
