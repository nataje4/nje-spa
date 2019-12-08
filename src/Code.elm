module Code exposing (..)

import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src)
import Browser
import Element exposing (Device, DeviceClass(..), Orientation(..))


---- MODEL ----



type alias Model =
    { deviceType : Element.Device
    , windowSize : Flags
    }

init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initModel flags, Cmd.none )

initModel flags =
    { deviceType = Element.classifyDevice flags
    , windowSize = flags
    }

type alias Flags = 
    WindowSize

type alias WindowSize =
    { width: Int 
    , height: Int
    }


---- UPDATE ----


type Msg
    = NoOp

update :  Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


---- VIEW ----


view : Model  -> Browser.Document msg
view model =
    { title = "NJE: CODE"
    , body =
        [ div []
            [ img [ src "/logo.svg" ] []
            , h1 [] [ text "You're CODE'!" ]
            ]
        ]
    }

---- SUBSCRIPTIONS ----

subscriptions : Model -> Sub Msg
subscriptions model = 
    Sub.none

---- PROGRAM ----


