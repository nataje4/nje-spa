module Poetry exposing (..)

import Html exposing (Html)
import Browser
import Element as El exposing (..)
import ViewHelpers exposing (..)
import Element.Font as EF exposing (italic)

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
    ( model, Cmd.none )



---- VIEW ----

titleText : List (Element msg)
titleText =
    [ text "POETRY"
    ]

subtitleText : List (Element msg)
subtitleText =
    [ text
        """ 
            Natalie is a poet, educator, and artist based in Portland, Oregon. She self-published                
            her debut chapboook,
        """
    , el [EF.italic] (text "BALACLAVA")
    , text 
        """
            , in June 2018 and is currently working on her full-length debut. Her written work focuses 
            on mental health, love, and the mundane. She is also interested in the intersection of code and poetry 
            and has written a number of tools to assist in her personal generative writing practice, all of 
            which will be available on this website soon. You can contact her with poetry-related inquiries  
        """
    , link linkStyle 
        { url = "#"
        , label = text "here"
        }
    , text " or find her on twitter "
    , link linkStyle 
        { url = "https://www.twitter.com/nataliejedson"
        , label = text "@nataliejedson"
        }
    , text "."
    ]


view : Model  -> Browser.Document msg
view model =
    let 
        screenSize : ScreenSize
        screenSize = 
            findScreenSize model.windowSize.width

        body : Html msg
        body = 
            case screenSize of 

                ExtraLarge ->
                    El.layout 
                        bodyStyle 
                        (El.column []  
                            [ El.row [centerX] 
                                [ El.column [El.width (fillPortion 1)] [ none]
                                , textColumn [El.width (fillPortion 2)] 
                                    [ paragraph titleStyle titleText
                                    , paragraph subtitleStyle subtitleText
                                    ]
                                , El.column [El.width (fillPortion 1)] [ none]
                                ]
                            , El.row [centerX] 
                                [ El.column [El.width (fillPortion 2)] [none]
                                , pictureLink "#" "assets/oceanwater.jpg" "click here to be taken to my etsy shop" "SHOP"  1
                                , pictureLink "#" "assets/oceanwater.jpg" "click here to see a list of my events" "EVENTS" 1
                                , pictureLink "#" "assets/oceanwater.jpg" "click here to be taken to a list of the tools I've created" "TOOLS" 1
                                , El.column [El.width (fillPortion 2)] [none]
                                ]
                            ]
                        )
                    
                  
                    
                Large ->
                    El.layout 
                        bodyStyle   
                        (El.column []
                            [ El.row [centerX] 
                                [ El.column [El.width (fillPortion 1)] [ none]
                                , textColumn [El.width (fillPortion 3)] 
                                    [ paragraph titleStyle titleText
                                    , paragraph subtitleStyle subtitleText
                                    ]
                                , El.column [El.width (fillPortion 1)] [ none]
                                ]
                            , El.row [centerX] 
                                [ El.column [El.width (fillPortion 1)] [none]
                                , pictureLink "#" "assets/oceanwater.jpg" "click here to be taken to my etsy shop" "SHOP"  1
                                , pictureLink "#" "assets/oceanwater.jpg" "click here to see a list of my events" "EVENTS" 1
                                , pictureLink "#" "assets/oceanwater.jpg" "click here to be taken to a list of the tools I've created" "TOOLS" 1
                                , El.column [El.width (fillPortion 1)] [none]
                                ]
                            ]
                        )
                    
                _ ->
                    El.layout 
                        bodyStyle   
                        (El.column [centerX]
                            [ El.row [] 
                                [ El.column [El.width (fillPortion 1)] [ none]
                                , textColumn [El.width (fillPortion 3)] 
                                    [ paragraph titleStyle titleText
                                    , paragraph subtitleStyle subtitleText
                                    ]
                                , El.column [El.width (fillPortion 1)] [ none]
                                ]
                            , El.row [centerX] [pictureLink "#" "assets/oceanwater.jpg" "click here to be taken to my etsy shop" "SHOP"  1]
                            , El.row [centerX] [pictureLink "#" "assets/oceanwater.jpg" "click here to see a list of my events" "EVENTS" 1]
                            , El.row [centerX] [pictureLink "#" "assets/oceanwater.jpg" "click here to be taken to a list of the tools I've created" "TOOLS" 1]
                            ]
                        ) --}      

    in 
        { title = "NJE: POETRY"
        , body = [body]
        }

        