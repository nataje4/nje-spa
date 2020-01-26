module ViewHelpers exposing (..)

import Browser exposing (Document)
import Element as El exposing (..)
import Element.Background as Eb exposing (color)
import Element.Font as Ef exposing (..)
import Html exposing (a, text)
import Html.Attributes exposing (class, href, style, disabled)
import Markdown exposing (toHtml)


type ScreenSize
    = Small
    | Medium
    | Large
    | ExtraLarge


findScreenSize : Int -> ScreenSize
findScreenSize width =
    if width <= 450 then
        Small

    else if width <= 800 then
        Medium

    else if width <= 1200 then
        Large

    else
        ExtraLarge


workSans =
    typeface "Work Sans"


arial =
    typeface "Arial"


lato =
    typeface "Lato"


georgia =
    typeface "Georgia"


emphasisFonts : El.Attribute msg
emphasisFonts =
    Ef.family
        [ workSans
        , arial
        , Ef.sansSerif
        ]


mainFonts : El.Attribute msg
mainFonts =
    Ef.family
        [ lato
        , georgia
        , Ef.serif
        ]



--to-do--Implement scaled


bodyStyle : List (El.Attribute msg)
bodyStyle =
    [ mainFonts
    ]


titleStyle : List (El.Attribute msg)
titleStyle =
    [ emphasisFonts
    , Ef.center
    , Ef.size 48
    , paddingEach { noPadding | top = 60, bottom = 20 }
    , Ef.bold
    ]


subtitleStyle : List (El.Attribute msg)
subtitleStyle =
    [ mainFonts
    , center
    , Ef.size 20
    , paddingEach { noPadding | bottom = 50 }
    ]


bottomTextStyle : List (El.Attribute msg)
bottomTextStyle =
    [ emphasisFonts
    , Ef.center
    , Ef.size 32
    , alignBottom
    , Ef.bold
    , paddingEach { noPadding | top = 30, bottom = 40 }
    ]


linkStyle : List (El.Attribute msg)
linkStyle =
    [ Ef.underline
    ]

-- TOD0: Write a button style that takes a boolean statement to see whether a button should be disabled
buttonStyle : Bool -> List (El.Attribute msg)
buttonStyle disableIfTrue =
    if disableIfTrue then 
        [ Eb.color lightGrey
        , padding 5
        , Ef.color white
        , centerX
        ]
    else
        [ Eb.color clay
        , padding 5
        , Ef.color white
        , centerX
        ]

noPadding =
    { top = 0
    , right = 0
    , bottom = 0
    , left = 0
    }


black : El.Color
black =
    rgb255 0 0 0


white : El.Color
white =
    rgb255 255 255 255


darkGrey : El.Color
darkGrey =
    rgb255 60 60 60

lightGrey : El.Color
lightGrey =
    rgb255 180 180 180

whitesmoke : El.Color
whitesmoke =
    rgb255 230 230 230 


lightBlue : El.Color
lightBlue =
    rgb255 112 151 170

clay : El.Color
clay = 
    rgb255 184 115 95

darkGreen: El.Color
darkGreen = 
    rgb255 9 35 39 

sand: El.Color
sand = 
    rgb255 173 162 150  

menuItemStyle : List (Attribute msg)
menuItemStyle =
    [ emphasisFonts, padding 20, Ef.size 18, Ef.color white, width (fillPortion 1) ]


menuLink : String -> String -> Element msg
menuLink text_ url =
    column
        menuItemStyle
        [ link [ El.centerX, El.centerY ]
            { url = url
            , label = paragraph [ Ef.center ] [ El.text text_ ]
            }
        ]


navMenu : Element msg
navMenu =
    let
        spacingEl : Element msg
        spacingEl =
            column
                [ width (fillPortion 3)
                ]
                [ none ]
    in
    El.row
        [ Eb.color black
        , width fill
        , height (px 60)
        , spacing 10
        ]
        [ spacingEl
        , menuLink "HOME" "#"
        , menuLink "CODE" "#/code"
        , menuLink "POETRY" "#/poetry"
        , spacingEl
        ]


footer : Element msg
footer =

    El.row
        [ width fill
        , height (px 60)
        , spacing 10
        , paddingEach { noPadding | top = 100, bottom = 50 }
        ]
        [ paragraph
            [ emphasisFonts
            , Ef.size 12
            , Ef.color black
            , center
            ]
            [ El.text "COPYRIGHT 2020 NATALIEJANEEDSON.COM"
            ]
        ]



-- menu icon or something like that


documentMsgHelper : String -> List (Element msg) -> Browser.Document msg
documentMsgHelper title elements =
    --"elements" will always be a list of rows.
    { title = title
    , body =
        [ El.layout
            bodyStyle
            (El.column
                [ width fill
                , height fill
                ]
                (elements
                    ++ [ footer ]
                    |> (++) [ navMenu ]
                )
            )
        ]
    }


titleSideSpacer : Element msg
titleSideSpacer =
    El.column [ El.width (fillPortion 1) ] [ none ]


titleEl : ScreenSize -> List (Element msg) -> Element msg
titleEl screenSize textElements =
    case screenSize of
        ExtraLarge ->
            textColumn [ El.width (fillPortion 2) ] textElements

        _ ->
            textColumn [ El.width (fillPortion 3) ] textElements


bodySideSpacer : ScreenSize -> Element msg
bodySideSpacer screenSize =
    case screenSize of
        ExtraLarge ->
            El.column [ El.width (fillPortion 2) ] [ none ]

        _ ->
            El.column [ El.width (fillPortion 1) ] [ none ]


bodyEl : List (Element msg) -> Element msg
bodyEl elements =
    column [ El.width (fillPortion 5) ] elements


basicLayoutHelper : ScreenSize -> String -> String -> List (El.Element msg) -> Browser.Document msg
basicLayoutHelper screenSize title subtitle bodyRows =
    let
        browserTitle : String
        browserTitle =
            "NJE: " ++ title
    in
    documentMsgHelper browserTitle
        [ El.column [ width fill ]
            [ El.row [ centerX ]
                [ titleSideSpacer
                , titleEl screenSize
                    [ paragraph titleStyle [ El.text title ]
                    , paragraph subtitleStyle [ El.text subtitle ]
                    ]
                , titleSideSpacer
                ]
            , El.row [ centerX ]
                [ bodySideSpacer screenSize
                , bodyEl bodyRows
                , bodySideSpacer screenSize
                ]
            ]
        ]


pictureLink : String -> String -> String -> String -> Int -> Element msg
pictureLink linkString imgSrc desc bottomText fillPortion_ =
    link
        ([ width (fillPortion fillPortion_), padding 10 ] ++ linkStyle)
        { url = linkString
        , label =
            El.column [ width (fill |> maximum 300) ]
                [ El.row []
                    [ image
                        [ width fill
                        , centerX
                        , alignTop
                        ]
                        { src = imgSrc
                        , description = desc
                        }
                    ]
                , El.row [ width (fill |> maximum 300) ] [ El.paragraph bottomTextStyle [ El.text bottomText ] ]
                ]
        }


pictureDownloadLink : String -> String -> String -> String -> Int -> Element msg
pictureDownloadLink downloadLinkString imgSrc desc bottomText fillPortion_ =
    download
        ([ width (fillPortion fillPortion_), padding 10 ] ++ linkStyle)
        { url = downloadLinkString
        , label =
            El.column [ width (fill |> maximum 300) ]
                [ El.row []
                    [ image
                        [ width fill
                        , centerX
                        , alignTop
                        ]
                        { src = imgSrc
                        , description = desc
                        }
                    ]
                , El.row [ width (fill |> maximum 300) ] [ El.paragraph bottomTextStyle [ El.text bottomText ] ]
                ]
        }



emailLink : String -> Element msg
emailLink email =
    El.html (a [ href ("mailto:" ++ email), style "color" "black" ] [ Html.text email ])
