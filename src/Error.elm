module Error exposing (..)

import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src, href)
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
    { title = "NJE: POETRY"
    , body =
        [ div []
            [ img [ src "/logo.svg" ] []
            , h1 [] [ Html.text "You're ERROR!" ]
            ]
        ]
    }



