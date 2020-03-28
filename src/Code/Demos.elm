module Code.Demos exposing (..)

import Browser exposing (Document)
import Element as El exposing (..)
import ViewHelpers exposing (..)



---- MODEL ----


type alias Model =
    { width : Int
    , data : String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initModel flags, Cmd.none )


initModel flags =
    { width = flags.width
    , data = flags.data
    }


type alias Flags =
    { width : Int
    , data : String
    }



---- UPDATE ----



update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



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
