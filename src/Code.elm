module Code exposing (..)

import Browser
import Element as El exposing (..)
import Html exposing (Html)
import ViewHelpers exposing (..)



---- MODEL ----


type alias Model =
    { width : Int
    , data : String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initModel flags, Cmd.none )


initModel flags =
    { width = flags.width
    , data = flags.data
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
    , text " package.) You can contact her with programming-related inquiries at "
    , emailLink "code@nataliejaneedson.com"
    , text " or find her on twitter "
    , link linkStyle
        { url = "https://www.twitter.com/nataje4"
        , label = text "@nataje4"
        }
    , text "."
    ]


view : Model -> Browser.Document msg
view model =
    let
        screenSize : ScreenSize
        screenSize =
            findScreenSize model.width

        viewHelper : List (Element msg) -> Browser.Document msg
        viewHelper =
            documentMsgHelper "NJE: CODE"

        githubLink : Element msg
        githubLink =
            pictureLink "https://www.github.com/nataje4" "assets/blackcattyping2.png" "click here to go to my github page" "GITHUB" 1

        demosLink : Element msg
        demosLink =
            pictureLink "#/code/demos" "assets/blackcattyping2.png" "click here to see some samples of my work" "DEMOS" 1

        resumeLink : Element msg
        resumeLink =
            pictureLink "/assets/NatalieJaneEdsonResume2020.pdf" "assets/blackcattyping2.png" "click here to view the latest version of my resume" "RESUME" 1
    in
    case screenSize of
        ExtraLarge ->
            viewHelper
                [ El.column []
                    [ El.row [ centerX ]
                        [ El.column [ El.width (fillPortion 1) ] [ none ]
                        , textColumn [ El.width (fillPortion 2) ]
                            [ paragraph titleStyle titleText
                            , paragraph subtitleStyle subtitleText
                            ]
                        , El.column [ El.width (fillPortion 1) ] [ none ]
                        ]
                    , El.row [ centerX ]
                        [ El.column [ El.width (fillPortion 2) ] [ none ]
                        , githubLink
                        , demosLink
                        , resumeLink
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
                        , githubLink
                        , demosLink
                        , resumeLink
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
                    , El.row [ centerX ] [ githubLink ]
                    , El.row [ centerX ] [ demosLink ]
                    , El.row [ centerX ] [ resumeLink ]
                    ]
                ]
