module Poetry exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Browser
import Markdown as MD exposing (toHtml)
import ViewHelpers exposing (pictureLink)


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
    { title = "NJE: POETRY"
    , body =
        [ div [class "body-div"]
            [ h1 [class "title"] [ text "POETRY" ]
            , div
                [class "main-text"] 

                [ p []
                    [text 
                        """
                            Natalie is a poet, educator, and artist based in Portland, Oregon. She self-published
                            her debut chapboook,
                        """
                    , span [ class "italic"] [ text "BALACLAVA"]
                    , text 
                        """
                            , in June 2018 and is currently working on her full-length debut. Her written work focuses 
                            on mental health, love, and the mundane. She is also interested in the intersection of code and poetry and has written 
                            a number of tools to assist in her personal generative writing practice, all of 
                            which will be available on this website soon. 
                        """
                    ]
                ]
            , div [class "row"]
                [ pictureLink "three-per-row" "#" "assets/oceanwater.jpg" "SHOP" 
                , pictureLink "three-per-row" "#" "assets/oceanwater.jpg" "EVENTS" 
                , pictureLink "three-per-row" "#" "assets/oceanwater.jpg" "TOOLS" 
                ]
            
            ]
        ]
    }

---- SUBSCRIPTIONS ----

subscriptions : Model -> Sub Msg
subscriptions model = 
    Sub.none

---- PROGRAM ----


