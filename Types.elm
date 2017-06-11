module Types exposing (..)


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
