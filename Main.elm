module Main exposing (..)

import Html exposing (program)
import Views exposing (view)
import State exposing (init, update, subscriptions)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
