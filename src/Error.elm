module Error exposing (..)

import Browser
import Element as El exposing (..)
import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (href, src)
import ViewHelpers exposing (..)
import Model exposing (..)
import Msg exposing (..)
import Type exposing (Page(..))


---- MODEL ----

init : Flags -> ( Model, Cmd Msg )
init flags =
    ( basicInitModel flags Error, Cmd.none )




---- VIEW ----


view : Model -> Browser.Document msg
view model =
    let
        viewHelper =
            documentMsgHelper "NJE: ERROR"

        screensize = 
            findScreenSize model.width
    in
    viewHelper
        [ El.row [ centerX ]
            [ titleSideSpacer
            , titleEl screensize
                [ paragraph titleStyle [ El.text "PAGE NOT FOUND" ]
                , paragraph subtitleStyle [ El.text "Looks like the page you're looking for does not exist. Are you sure you typed in the right URL?" ]
                ]
            , titleSideSpacer
            ]
        ]
