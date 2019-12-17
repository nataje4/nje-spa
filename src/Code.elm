module Code exposing (..)

import Html exposing (Html)
import Browser
import Element as El exposing (..)
import ViewHelpers exposing (..)


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
    [ text "CODE"
    ]

subtitleText : List (Element msg)
subtitleText =
    [ text
        """ 
            Natalie is a self-taught programmer based in Portland, Oregon. She earned her B.A. in Applied Mathematics 
            from the University of Oregon in 2014 and has been working as a web developer since 2016. She is an experienced 
            remote and freelance worker with a strong focus on Python and Elm. (This website is written as a single page application
            in Elm and styled with mdgriffith's 
        """
    , link linkStyle
        { url = "https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest"
        , label = text "elm-ui"
        }
    , text " package.) You can contact her with programming-related inquiries"
    , link linkStyle
        { url = "#"
        , label = text "here"
        }
    , text " or find her on twitter "
    , link linkStyle
        { url = "https://www.twitter.com/nataje4"
        , label = text "@nataje4"
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
                                , pictureLink "https://www.github.com/nataje4" "assets/blackcattyping2.png" "click here to go to my github page" "GITHUB"  1
                                , pictureLink "#" "assets/blackcattyping2.png" "click here to see some samples of my work" "DEMOS" 1
                                , pictureLink "#" "assets/blackcattyping2.png" "click here to view the latest version of my resume" "RESUME" 1
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
                                , pictureLink "https://www.github.com/nataje4" "assets/blackcattyping2.png" "click here to go to my github page" "GITHUB"  1
                                , pictureLink "#" "assets/blackcattyping2.png" "click here to see some samples of my work" "DEMOS" 1
                                , pictureLink "#" "assets/blackcattyping2.png" "click here to view the latest version of my resume" "RESUME" 1
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
                            , El.row [centerX] [pictureLink "https://www.github.com/nataje4" "assets/blackcattyping2.png" "click here to bgo to my github page" "GITHUB"  1]
                            , El.row [centerX] [pictureLink "#" "assets/blackcattyping2.png" "click here to see asome samples of my work" "DEMOS" 1]
                            , El.row [centerX] [pictureLink "#" "assets/blackcattyping2.png" "click here tto view the latest version of my resume" "RESUME" 1]
                            ]
                        ) --}      

    in 
        { title = "NJE: CODE"
        , body = [body]
        }