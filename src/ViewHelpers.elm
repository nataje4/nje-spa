module ViewHelpers exposing (..)

import Html.Attributes exposing (src, class, href)
import Element as El exposing (..)
import Element.Font as EF exposing (..)

type ScreenSize
    = Small
    | Medium 
    | Large 
    | ExtraLarge 

findScreenSize : Int -> ScreenSize 
findScreenSize width =  
    if width <= 600 then 
        Small 
    else if width <= 900 then 
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
    , EF.bold
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
    , alignBottom
    , EF.bold
    ]

linkStyle : List (El.Attribute msg)
linkStyle = 
    [ EF.underline
    ]

noPadding =
    { top = 0
    , right = 0
    , bottom = 0
    , left = 0
    }


pictureLink: String -> String -> String -> String -> Int -> Element msg 
pictureLink linkString imgSrc desc bottomText fillPortion_ = 
    link 
        ([width (fillPortion fillPortion_), padding 10 ] ++ linkStyle) 
        { url = linkString
        , label = 
            El.column []
                [ El.row []
                    [ image 
                        [ width (fill |> maximum 300)
                        , centerX 
                        , alignTop 
                        , paddingEach {noPadding | bottom = 10}
                        ]
                        { src = imgSrc
                        , description = desc
                        }
                    ]
                , El.row [] [El.paragraph bottomTextStyle [ text bottomText] ]
                ]
        }
    

