module Home exposing (..)

--import Html exposing (..)
import Html.Attributes exposing (..)
import Browser
import Browser.Events exposing (onResize)
import Browser.Dom exposing (getViewport, Viewport)
import ViewHelpers exposing (..)
import Element as El exposing (..)


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

view : Model  -> Browser.Document msg
view model =
    let 
        device: El.Device 
        device = 
            classifyDevice model.windowSize

        body : El.Element msg
        body = 
            case (device.class, device.orientation) of 
                (BigDesktop, _) ->
                    El.row [] 
                        [ El.column [El.width (fillPortion 2)] [ none]
                        , textColumn [El.width (fillPortion 3)] 
                            [ paragraph titleStyle titleText
                            , paragraph subtitleStyle subtitleText
                            ]
                        , El.column [El.width (fillPortion 2)] [ none]
                        ]
                    
                (Desktop, _) ->
                    El.row [] 
                        [ El.column [El.width (fillPortion 1)] [ none]
                        , textColumn [El.width (fillPortion 3)] 
                            [ paragraph titleStyle titleText
                            , paragraph subtitleStyle subtitleText
                            ]
                        , El.column [El.width (fillPortion 1)] [ none]
                        ]
                    
                (_, _) ->
                    El.row [] 
                        [ El.column [El.width (fillPortion 1)] [ none]
                        , textColumn [El.width (fillPortion 3)] 
                            [ paragraph titleStyle titleText
                            , paragraph subtitleStyle subtitleText
                            ]
                        , El.column [El.width (fillPortion 1)] [ none]
                        ]
                    


    in 
        { title = "NJE"
        , body =
            [El.layout 
                []
                body
            ]
        }


