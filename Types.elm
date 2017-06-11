module Types exposing (..)


type alias NumberProblem =
    { koreanNumber : String
    , numeral : Int
    }


type alias Model =
    { selectedProblem : Maybe NumberProblem
    , otherProblems : List NumberProblem
    , guess : Maybe Int
    }


type Msg
    = Guess Int
    | NextProblem ( Maybe NumberProblem, List NumberProblem )
