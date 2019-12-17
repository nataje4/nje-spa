module ViewHelpers exposing (..)

import Element as El exposing (..)
import Element.Font as Ef exposing (..)
import Element.Background as Bg exposing (color)
import Browser exposing (Document)

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
    , center
    , Ef.size 48
    , paddingEach {noPadding | top =60, bottom = 20}
    , Ef.bold
    ]

subtitleStyle : List (El.Attribute msg)
subtitleStyle = 
    [ mainFonts
    , center
    , Ef.size 20
    , paddingEach {noPadding | bottom = 50}
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

topMenuItemStyle : List (Attribute msg)
topMenuItemStyle = 
    (titleStyle ++ [Ef.size 18]) 

subMenuItemStyle : List (Attribute msg)
subMenuItemStyle = 
    [ Ef.size 16
    , paddingEach {noPadding | left = 15 }
    ]

subSubMenuItemStyle : List (Attribute msg)
subSubMenuItemStyle = 
    [ Ef.size 15
    , paddingEach {noPadding | left = 30 }
    ]

menuLink: List (Attribute msg) -> String -> String -> Element msg 
menuLink style text_ url = 
    paragraph 
        style 
        [ link []
            { url = url 
            , label = text text_
            }
        ]

navMenu: Bool -> ScreenSize -> Element msg
navMenu menuOpen screenSize= 
    case (menuOpen, screenSize) of 
        (True, Small) -> 
            El.row 
                [ Bg.color black
                , width fill
                , height fill
                , spacing 10 
                ]
                [ El.column 
                    [center]
                    [ menuLink topMenuItemStyle "CODE" "#/code" 
                    , menuLink subMenuItemStyle "Demos" "#"
                    , menuLink subSubMenuItemStyle "foo" "#"
                    , menuLink subSubMenuItemStyle "foo" "#"
                    , menuLink topMenuItemStyle "POETRY" ""
                    , menuLink subMenuItemStyle "Shop" "https://www.etsy.com/njepoetry"
                    , menuLink subMenuItemStyle "Events" "#"
                    , menuLink subMenuItemStyle "Tools" "#"
                    , menuLink subSubMenuItemStyle "Erasure" "#"
                    , menuLink subSubMenuItemStyle "Word Bank" "#"
                    , menuLink subSubMenuItemStyle "Homolinguistic Translator" "#"
                    ]
                ]
        (True, _) -> 
            El.column 
                [ Bg.color black
                , width (fillPortion 1)
                , spacing 10 
                , height fill 
                ]
                [ El.row 
                    [centerY]
                    [ menuLink topMenuItemStyle "CODE" "#/code" 
                    , menuLink subMenuItemStyle "Demos" "#"
                    , menuLink subSubMenuItemStyle "foo" "#"
                    , menuLink subSubMenuItemStyle "foo" "#"
                    , menuLink topMenuItemStyle "POETRY" ""
                    , menuLink subMenuItemStyle "Shop" "https://www.etsy.com/njepoetry"
                    , menuLink subMenuItemStyle "Events" "#"
                    , menuLink subMenuItemStyle "Tools" "#"
                    , menuLink subSubMenuItemStyle "Erasure" "#"
                    , menuLink subSubMenuItemStyle "Word Bank" "#"
                    , menuLink subSubMenuItemStyle "Homolinguistic Translator" "#"
                    ]
                ]
        (_,_) -> 
            El.none -- menu icon or something like that 

documentMsgHelper : Bool -> ScreenSize -> String -> List (Element msg) -> Browser.Document msg
documentMsgHelper menuOpen screenSize title elements = 
    --"elements" will always be a list of rows. 
    if (screenSize == Small) || (screenSize == Medium) then 
        { title = title
        , body = 
            [ El.layout 
                bodyStyle 
                (El.column 
                    [centerX]
                    ( navMenu menuOpen screenSize 
                    :: elements
                    )
                )
            ]
        }
    else 
        { title = title
        , body = 
            [El.layout
                bodyStyle
               ( El.row 
                    []
                    [ El.column [] elements
                    , navMenu menuOpen screenSize
                    ]
                )
            ]
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
                        , paddingEach {noPadding | bottom = 40}
                        ]
                        { src = imgSrc
                        , description = desc
                        }
                    ]
                , El.row [] [El.paragraph bottomTextStyle [ text bottomText] ]
                ]
        }
    

