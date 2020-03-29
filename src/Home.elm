module Home exposing (..)

--import Html exposing (..)

import Browser
import Browser.Dom exposing (Viewport, getViewport)
import Browser.Events exposing (onResize)
import Element as El exposing (..)
import Html exposing (Html)
import ViewHelpers exposing (..)
import Msg exposing (..)
import Model exposing (..)
import Type exposing (Page(..))


---- MODEL ----

init : Flags -> ( Model, Cmd Msg )
init flags =
    ( basicInitModel flags Home, Cmd.none )


---- VIEW ----


titleText : List (El.Element msg)
titleText =
    [ El.text
        "NATALIE JANE EDSON"
    ]


subtitleText : List (El.Element msg)
subtitleText =
    [ El.text
        """is a poet, programmer, and aspiring polymath based in Portland, OR. She has a lot 
        to say about her work—what do you want to know about?
        """
    ]


view : Model -> Browser.Document msg
view model =
    let
        screenSize : ScreenSize
        screenSize =
            findScreenSize model.width

        viewHelper : List (Element msg) -> Browser.Document msg
        viewHelper =
            documentMsgHelper "NJE"
    in
    case screenSize of
        ExtraLarge ->
            viewHelper
                [ El.column []
                    [ El.row [ centerX ]
                        [ El.column [ El.width (fillPortion 2) ] [ none ]
                        , textColumn [ El.width (fillPortion 3) ]
                            [ paragraph titleStyle titleText
                            , paragraph subtitleStyle subtitleText
                            ]
                        , El.column [ El.width (fillPortion 2) ] [ none ]
                        ]
                    , El.row [ centerX ]
                        [ El.column [ El.width (fillPortion 2) ] [ none ]
                        , pictureLink "#/code" "assets/cat.gif" "gif of a cat typing furiously on a computer" "CODE" 1
                        , pictureLink "#/poetry" "assets/ocean-square.gif" "gif of the surface of the ocean" "POETRY" 1
                        , El.column [ El.width (fillPortion 2) ] [ none ]
                        ]
                    ]
                ]

        Large ->
            viewHelper
                [ El.column []
                    [ El.row [ centerX ]
                        [ El.column [ El.width (fillPortion 1) ] [ none ]
                        , textColumn [ El.width (fillPortion 3) ]
                            [ paragraph titleStyle titleText
                            , paragraph subtitleStyle subtitleText
                            ]
                        , El.column [ El.width (fillPortion 1) ] [ none ]
                        ]
                    , El.row [ centerX ]
                        [ El.column [ El.width (fillPortion 1) ] [ none ]
                        , pictureLink "#/code" "assets/cat.gif" "gif of a cat typing furiously on a computer" "CODE" 1
                        , pictureLink "#/poetry" "assets/ocean-square.gif" "gif of the surface of the ocean" "POETRY" 1
                        , El.column [ El.width (fillPortion 1) ] [ none ]
                        ]
                    ]
                ]

        _ ->
            viewHelper
                [ El.column [ centerX ]
                    [ El.row []
                        [ El.column [ El.width (fillPortion 1) ] [ none ]
                        , textColumn [ El.width (fillPortion 3) ]
                            [ paragraph titleStyle titleText
                            , paragraph subtitleStyle subtitleText
                            ]
                        , El.column [ El.width (fillPortion 1) ] [ none ]
                        ]
                    , El.row [ centerX ] [ pictureLink "#/code" "assets/cat.gif" "gif of a cat typing furiously on a computer" "CODE" 1 ]
                    , El.row [ centerX ] [ pictureLink "#/poetry" "assets/ocean-square.gif" "gif of the surface of the ocean" "POETRY" 1 ]
                    ]
                ]
