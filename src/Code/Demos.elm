module Code.Demos exposing (..)

import Element as El exposing (..)
import ViewHelpers exposing (..)
import Browser exposing (Document)



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
            documentMsgHelper "NJE: DEMOS"
    in
    viewHelper
        [ El.row [ centerX ]
            [ El.column [ El.width (fillPortion 1) ] [ El.none ]
            , textColumn [ El.width (fillPortion 2) ]
                [ paragraph titleStyle [ El.text "CODE DEMOS" ]
                , paragraph subtitleStyle [ El.text "This page is under construction. Please check back soon!" ]
                ]
            , El.column [ El.width (fillPortion 1) ] [ none ]
            ]
        ]
