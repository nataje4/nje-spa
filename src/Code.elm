module Code exposing (..)

import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src)
import Browser

---- MODEL ----


type alias Model =
    {}


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( {}, Cmd.none )

initModel : Model 
initModel = 
    {}

type alias Flags = 
    {}

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


