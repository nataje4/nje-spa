module Submit exposing (..)

import Browser.Navigation exposing (load)
import Msg exposing (..)
import Model exposing (..)
import Type exposing (Page(..))



init : Flags -> ( Model, Cmd Msg )
init flags =
    ( basicInitModel flags Submit, load "mailto:poetry@nataliejaneedson.com?subject=Submission" )