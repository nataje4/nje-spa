module ViewHelpers exposing (..)

import Html exposing (a, img, span, div, text, Html)
import Html.Attributes exposing (src, class, href)
import Element as El exposing (..)
import Element.Font as EF exposing (..)

pictureLink: String -> String -> String -> String -> Html msg 
pictureLink perRowClass linkString imgSrc text_ = 
    div 
        [ class "picture-link"
        , class perRowClass
        ]
        [ a 
            [ href linkString  
            ] 
            [ img [src imgSrc, class "square-image"] []
            , span [class "bottom-text"] [Html.text text_]
            ]
        ]

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
    EF.family 
        [ workSans
        , arial
        , EF.sansSerif
        ]

mainFonts : El.Attribute msg
mainFonts = 
    EF.family 
        [ lato
        , georgia
        , EF.serif
        ]

--to-do--Implement scaled 

bodyStyle : List (El.Attribute msg)
bodyStyle = 
    [ mainFonts
    ]

titleStyle : List (El.Attribute msg)
titleStyle = 
    [ emphasisFonts
    , center
    , EF.size 48
    , paddingEach {noPadding | top =60, bottom = 20}
    ]


subtitleStyle : List (El.Attribute msg)
subtitleStyle = 
    [ mainFonts
    , center
    , EF.size 20
    , paddingEach {noPadding | bottom = 50}
    ]

bottomTextStyle : List (El.Attribute msg)
bottomTextStyle = 
    [ emphasisFonts
    , center
    , EF.size 32
    ]

noPadding =
    { top = 0
    , right = 0
    , bottom = 0
    , left = 0
    }
{--.square-image {
    width: 90%;
    max-width: 300px;
    max-height: 300px;
    margin: auto;
    float: top;
    display: block;
    object-fit: contain;
--}