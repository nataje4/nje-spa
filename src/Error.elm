module Error exposing (..)

import Browser
import Element exposing (Device, DeviceClass(..), Orientation(..))
import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (href, src)



---- MODEL ----


type alias Model =
    { width : Int
    , data : String
    , menuOpen : Bool
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initModel flags, Cmd.none )


initModel flags =
    { width = flags.width
    , data = flags.data
    , menuOpen = False
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
    { title = "NJE: POETRY"
    , body =
        [ div []
            [ img [ src "/logo.svg" ] []
            , h1 [] [ Html.text "You're ERROR!" ]
            ]
        ]
    }
