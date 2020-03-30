module FireDance exposing (..)

import Browser exposing (Document)
import Element as El exposing (..)
import Element.Font as Ef exposing (size, center)
import Element.Border as Eb exposing (color, width, solid)
import ViewHelpers exposing (..)
import Time exposing (Month(..))
import Msg exposing (Msg(..), FireDanceMsg(..))
import Model exposing (..)
import Type exposing (..)
import Task exposing (Task, perform)


---- MODEL ----

init : Flags -> ( Model, Cmd Msg )
init flags =
    (basicInitModel flags FireDance, Cmd.batch [getDay, getMonth])



isApril7th : Model -> Bool
isApril7th model = 
    (&&) (model.month == Apr) (model.day == 7)


whatDayIsIt : Task x Int
whatDayIsIt =
    Task.map2 Time.toDay Time.here Time.now

getDay : Cmd Msg
getDay = 
    Task.perform (\x -> UpdateDay x |> GotFireDanceMsg) whatDayIsIt

whatMonthIsIt : Task x Time.Month
whatMonthIsIt =
    Task.map2 Time.toMonth Time.here Time.now

getMonth : Cmd Msg
getMonth = 
    Task.perform (\x -> UpdateMonth x |> GotFireDanceMsg) whatMonthIsIt



---- VIEW ----


view : Model -> Browser.Document msg
view model =
    let

        screensize = 
            findScreenSize model.width

    in
        basicLayoutHelper screensize "FIRE DANCE" subtitleText (bodyRows model)


subtitleText : String 
subtitleText = 
    ""

bodyRows : Model -> List (Element msg)
bodyRows model  = 
    --[ row [] [paragraph [] [text ( [(Debug.toString model.day), (Debug.toString model.month)] |> String.concat )]] 
    [ image 
        [ El.width fill, padding 10 ] 
        { src = "assets/firedance.jpg"
        , description = "people dancing around a fire"
        }
    , row [paddingEach {noPadding | top= 30}] 
        [ textColumn [] 
            [ paragraph []
                [ text 
                    """
                    Fire Dance is a virtual poetry event and fundraiser in honor of my birthday, which will be held 
                    on April 7th, (my actual birthday!) at 7:30 PM. The suggested donation is $3-10, and all proceeds 
                    will go to the 
                    """
                , link linkStyle 
                    { url = "https://www.pdxartistrelief.com/"
                    , label = text "Portland Area Artists Emergency Relief Fund"
                    }
                , text 
                    ". The event will be held over ZOOM, which is an easy to use platform for video calling—you can download it "
                , link linkStyle
                    { url = "https://www.pdxartistrelief.com/"
                    , label = text "here"
                    }
                , text ". Once you have the application downloaded, all you have to do to join in is click the link below. "
                ]
            ]
        ]
    , showLink model
    ]


showLink: Model ->  Element msg 
showLink model = 
    let 
        linkViewmsg : List (Element msg)
        linkViewmsg = 
            if (isApril7th model) then 
                [ text "You can join us for the gathering "
                , link linkStyle 
                    { url = "https://zoom.us/s/3986782691"
                    , label = text "here"
                    }
                , text "."
                ]
            else
                [ text "The link will appear here on the day of the event."
                ]

    in 
        row [paddingEach {noPadding | top= 30}, El.width fill]
            [ textColumn [padding 30, Ef.size 16, Eb.solid, Eb.width 5, Eb.color sand, centerX ]
                [ paragraph [ centerX, centerY, center ] [El.text "The link to the ZOOM meeting will appear here on the day of the event."] ]
            ]
