module Code.Demos exposing (..)

import Browser exposing (Document)
import Element as El exposing (..)
import ViewHelpers exposing (..)
import Model exposing (..)
import Msg exposing (..)
import Type exposing (Page(..))


---- MODEL ----


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( basicInitModel flags CodeDemos, Cmd.none )




---- VIEW ----


view : Model -> Browser.Document msg
view model =
    let
        viewHelper =
            documentMsgHelper "NJE: DEMOS"

        screensize = 
            findScreenSize model.width
    in
    viewHelper
        [ El.row [ centerX ]
            [ titleSideSpacer
            , titleEl screensize
                [ paragraph titleStyle [ El.text "CODE DEMOS" ]
                , paragraph subtitleStyle [ El.text "This page is under construction. Please check back soon!" ]
                ]
            , titleSideSpacer
            ]
        ]
