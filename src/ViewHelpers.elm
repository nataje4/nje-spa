module ViewHelpers exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

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
            , span [class "bottom-text"] [text text_]
            ]
        ]