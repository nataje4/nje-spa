module Home exposing (..)

--import Html exposing (..)
import Html.Attributes exposing (..)
import Browser
import Browser.Events exposing (onResize)
import Browser.Dom exposing (getViewport, Viewport)
import ViewHelpers exposing (pictureLink)
import Element as El exposing ()


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
    let 
        device: El.Device 
        device = 
            classifyDevice model.windowSize

        body : El.el msg
        body = 
            case (device.class, device.orientation) of 
                (BigDesktop, _) ->
                    El
                (Desktop, _) ->

                (_, _) ->



    in 
        { title = "NJE"
        , body =
            El.layout 
                []
        }       body


