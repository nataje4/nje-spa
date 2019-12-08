module Home exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Browser
import Browser.Events exposing (onResize)
import Browser.Dom exposing (getViewport, Viewport)
import ViewHelpers exposing (pictureLink)
import Element exposing (Device, DeviceClass(..), Orientation(..))


---- MODEL ----



type alias Model =
    { windowSize : Flags
    }

init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initModel flags, Cmd.none )

initModel flags =
    { windowSize = flags
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
    (model, Cmd.none )


---- VIEW ----


view : Model  -> Browser.Document msg
view model =
    { title = "NJE"
    , body =
        [ div [class "body-div"]
            [ h1 [class "title"] [ text "NATALIE JANE EDSON" ]
            , p [class "subtitle"] [text "is a poet, programmer, and aspiring polymath based in Portland, OR. She has a lot to say about her work—what do you want to know about?"]
            , div [class "row"]
                [ pictureLink "two-per-row" "/#/code" "/assets/cat.gif" "CODE" 
                , pictureLink "two-per-row" "/#/poetry" "/assets/ocean-square.gif" "POETRY" 
                ]
            ]
        ]
    }


