module Poetry.Tools exposing (..)

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


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----

view : Model -> Browser.Document msg
view model =
    let
        viewHelper =
            documentMsgHelper "NJE: POETRY TOOLS"

        screensize = 
            findScreenSize model.width
    in
    viewHelper
        [ El.row [ centerX ]
            [ titleSideSpacer
            , titleEl screensize
                [ paragraph titleStyle [ El.text "POETRY TOOLS" ]
                , paragraph subtitleStyle [ El.text "This page is under construction. Please check back soon!" ]
                ]
            , titleSideSpacer
            ]
        ]
