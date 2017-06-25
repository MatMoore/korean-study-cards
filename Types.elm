module Types exposing (..)

import Dict exposing (Dict)


type alias NumberProblem =
    { question : String
    , answer : String
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
    , guess : Maybe String
    }


type Msg
    = Guess String
    | PickNew
    | SelectProblemSet String
    | NextProblem ( Maybe NumberProblem, List NumberProblem )
