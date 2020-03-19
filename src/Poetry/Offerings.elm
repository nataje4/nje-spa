module Poetry.Offerings exposing (..)

import Browser exposing (Document)
import Element as El exposing (..)
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


view : Model -> Browser.Document msg
view model =
    let
        viewHelper =
            documentMsgHelper "NJE: OFFERINGS"

        screensize = 
            findScreenSize model.width
    in
        sectionViewHelper "EVENTS" eventListings
            |> basicLayoutHelper screensize "POETRY OFFERINGS" "" 

    {--viewHelper
        [ El.row [ centerX ]
            [ titleSideSpacer
            , titleEl screensize
                [ paragraph titleStyle [ El.text "POETRY OFFERINGS" ]
                ]
            , titleSideSpacer
            ]
        , El.row [ centerX ]
            [ bodySideSpacer screensize
            , bodyEl
                [ paragraph sectionTitleStyle [ El.text "EVENTS" ]
                , paragraph bodyStyle 
                    [ El.text 
                        """
                        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Blandit libero volutpat sed cras ornare arcu dui vivamus. Enim facilisis gravida neque convallis a cras semper. Adipiscing diam donec adipiscing tristique risus nec feugiat in fermentum. Nibh tellus molestie nunc non. Et leo duis ut diam quam nulla porttitor massa. Accumsan lacus vel facilisis volutpat est. In hac habitasse platea dictumst vestibulum rhoncus est pellentesque elit. Risus in hendrerit gravida rutrum quisque non tellus orci ac. Eu facilisis sed odio morbi. Consequat interdum varius sit amet mattis vulputate.
                        """
                    ]
                , paragraph sectionTitleStyle [ El.text "WORKSHOPS" ]
                , paragraph bodyStyle 
                    [ El.text 
                        """
                        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Blandit libero volutpat sed cras ornare arcu dui vivamus. Enim facilisis gravida neque convallis a cras semper. Adipiscing diam donec adipiscing tristique risus nec feugiat in fermentum. Nibh tellus molestie nunc non. Et leo duis ut diam quam nulla porttitor massa. Accumsan lacus vel facilisis volutpat est. In hac habitasse platea dictumst vestibulum rhoncus est pellentesque elit. Risus in hendrerit gravida rutrum quisque non tellus orci ac. Eu facilisis sed odio morbi. Consequat interdum varius sit amet mattis vulputate.
                        """
                    ]
                , paragraph sectionTitleStyle [ El.text "SERVICES" ]
                , paragraph bodyStyle 
                    [ El.text 
                        """
                        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Blandit libero volutpat sed cras ornare arcu dui vivamus. Enim facilisis gravida neque convallis a cras semper. Adipiscing diam donec adipiscing tristique risus nec feugiat in fermentum. Nibh tellus molestie nunc non. Et leo duis ut diam quam nulla porttitor massa. Accumsan lacus vel facilisis volutpat est. In hac habitasse platea dictumst vestibulum rhoncus est pellentesque elit. Risus in hendrerit gravida rutrum quisque non tellus orci ac. Eu facilisis sed odio morbi. Consequat interdum varius sit amet mattis vulputate.
                        """
                    ]
                ]
            , bodySideSpacer screensize
            ]
        ]
        --}
eventListings : List (Listing msg)
eventListings = 
    [ 
        { imgSrc = "assets/firedance.jpg"
        , imgDescription = "people dancing around a fire"
        , title = "Fire Dance: a Virtual Poetry Reading"
        , text =
            paragraph bodyStyle 
                [ El.text
                    """
                        In lieu of a birthday reading for myself, I am hosting a virtual get-together and poetry reading on April 7th at 7:30 pm. 
                        I want to spotlight local Portland poets who may be suffering given the current circumstances. Additional information and updates can be found 
                        on the facebook
                    """
                , link linkStyle
                    { url = "https://www.facebook.com/events/2343370595956435/"
                    , label = El.text "event page"
                    }
                , El.text "."
                ]
        }
    ]
