module Error exposing (..)

import Browser
import Element as El exposing (..)
import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (href, src)
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
