module ViewHelpers exposing (..)

import Browser exposing (Document)
import Element as El exposing (..)
import Element.Background as Bg exposing (color)
import Element.Font as Ef exposing (..)


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
    , center
    , Ef.size 32
    , alignBottom
    , Ef.bold
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


menuItemStyle : List (Attribute msg)
menuItemStyle =
    [emphasisFonts , padding 20, Ef.size 18, Ef.color white, center, width (fillPortion 1)]

menuLink : String -> String -> Element msg
menuLink text_ url =
    column
        menuItemStyle
        [link []
            { url = url
            , label = text text_
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
                (navMenu :: elements)
            )
        ]
    }

   


pictureLink : String -> String -> String -> String -> Int -> Element msg
pictureLink linkString imgSrc desc bottomText fillPortion_ =
    link
        ([ width (fillPortion fillPortion_), padding 10 ] ++ linkStyle)
        { url = linkString
        , label =
            El.column []
                [ El.row []
                    [ image
                        [ width (fill |> maximum 300)
                        , centerX
                        , alignTop
                        , paddingEach { noPadding | bottom = 40 }
                        ]
                        { src = imgSrc
                        , description = desc
                        }
                    ]
                , El.row [] [ El.paragraph bottomTextStyle [ text bottomText ] ]
                ]
        }
