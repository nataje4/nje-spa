module ViewHelpers exposing (..)

import Browser exposing (Document)
import Element as El exposing (..)
import Element.Background as Bg exposing (color)
import Element.Font as Ef exposing (..)
import Html exposing (a, text)
import Html.Attributes exposing (href, style)
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


noPadding =
    { top = 0
    , right = 0
    , bottom = 0
    , left = 0
    }


black : El.Color
black =
    rgb 0.0 0.0 0.0

white : El.Color
white =
    rgb 255.0 255.0 255.0

darkGrey : El.Color
darkGrey =
    rgb 60.0 60.0 60.0


menuItemStyle : List (Attribute msg)
menuItemStyle =
    [emphasisFonts , padding 20, Ef.size 18, Ef.color white, width (fillPortion 1)]

menuLink : String -> String -> Element msg
menuLink text_ url =
    column
        menuItemStyle
        [link [El.centerX, El.centerY]
            { url = url
            , label = paragraph [Ef.center] [El.text text_]
            }
        ]

navMenu : Element msg
navMenu  =
    let
        spacingEl : Element msg
        spacingEl = 
            column 
                [ width (fillPortion 3)
                ]
                [ none ]
    in
        El.row
            [ Bg.color black
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
    let
        spacingEl : Element msg
        spacingEl = 
            column 
                [ width (fillPortion 3)
                ]
                [ none ]
    in
        El.row
            [ width fill
            , height (px 60)
            , spacing 10
            , paddingEach {noPadding | top = 100, bottom = 50}
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
                []
                (elements ++ [footer]
                    |> (++) [navMenu]
                )
            )
        ]
    }

   


pictureLink : String -> String -> String -> String -> Int -> Element msg
pictureLink linkString imgSrc desc bottomText fillPortion_ =
    link
        ([ width (fillPortion fillPortion_), padding 10 ] ++ linkStyle)
        { url = linkString
        , label =
            El.column [width (fill |> maximum 300)]
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
                , El.row [width (fill |> maximum 300)] [ El.paragraph bottomTextStyle [ El.text bottomText ] ]
                ]
        }

emailLink : String -> String -> Element msg 
emailLink text_ email = 
    El.html (a [href ("mailto:" ++ email), style "color" "black"] [Html.text text_])


