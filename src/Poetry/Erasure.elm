module Poetry.Erasure exposing (..)

import Debug exposing (log)
import Html exposing (Html, div, img, text)
import Html.Attributes as Hattr exposing (..)
import Html.Events exposing (onClick, onInput)
import List.Extra as Lex exposing (..)
import Random exposing (..)
import Task exposing (..)
import Time exposing (..)
import Browser exposing (..)
import ViewHelpers exposing (..)
import Element as El exposing (row, html, text)

type alias ClickableWord =
    { text : String
    , erased : Bool
    , position : Int
    }


type alias Model =
    { clickableText : List ClickableWord
    , textEntered : Bool
    , inputText : String
    , percentRandom : Int
    , seed : Random.Seed
    , width : Int
    }


type alias Flags =
    { width : Int
    , data : String
    }

initModel : Flags -> Model
initModel flags =
    { clickableText = []
    , textEntered = False
    , inputText = ""
    , percentRandom = 90
    , seed = Random.initialSeed 42
    , width = flags.width
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initModel flags, now )


textToClickableWords : String -> List ClickableWord
textToClickableWords inputText =
    let
        rawWordsArray =
            String.split " " inputText
    in
    List.map2 createWord rawWordsArray (List.range 1 <| List.length <| rawWordsArray)


createWord : String -> Int -> ClickableWord
createWord string int =
    ClickableWord string False int



---- UPDATE ----


eraseOrBringBack : ClickableWord -> ClickableWord
eraseOrBringBack word =
    case word.erased of
        True ->
            ClickableWord word.text False word.position

        False ->
            ClickableWord word.text True word.position


hasPosition : Int -> ClickableWord -> Bool
hasPosition int word =
    if word.position == int then
        True

    else
        False


now : Cmd Msg
now =
    Task.perform (Just >> GetSeed) Time.now


type Msg
    = ToggleWord ClickableWord
    | MakeTextClickable String
    | UpdateInputText String
    | GoBackToTextEntry
    | Randomize
    | UpdatePercentRandom String
    | GetSeed (Maybe Time.Posix)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleWord word ->
            let
                newText =
                    Lex.updateAt (word.position - 1) eraseOrBringBack model.clickableText
            in
            
                ( { model | clickableText = newText }, Cmd.none )

                
        MakeTextClickable text ->
            let
                clickableText =
                    textToClickableWords model.inputText
            in
            ( { model
                | clickableText = clickableText
                , textEntered = True
              }
            , Cmd.none
            )

        UpdateInputText text ->
            ( { model | inputText = text }, Cmd.none )

        GoBackToTextEntry ->
            ( { model | textEntered = False }, Cmd.none )

        Randomize ->
            ( randomErasure model, Cmd.none )

        UpdatePercentRandom string ->
            ( { model | percentRandom = Maybe.withDefault 0 (String.toInt string) }, Cmd.none )

        GetSeed (Just time) ->
            let
                timeSeed =
                    Random.initialSeed (Time.posixToMillis time)
            in
            ( { model | seed = timeSeed }, Cmd.none )

        GetSeed Nothing ->
            --This would be an error, but I am not too concerned with it... I have a fallback seed
            ( model
            , Cmd.none
            )


desiredAmountErased : Model -> Int
desiredAmountErased model =
    (totalNumberOfWords model * model.percentRandom) // 100



-- Note use of integer division here


currentErasedWords : Model -> List ClickableWord
currentErasedWords model =
    List.filter .erased model.clickableText


currentAmountErased : Model -> Int
currentAmountErased model =
    List.length (currentErasedWords model)


totalNumberOfWords : Model -> Int
totalNumberOfWords model =
    List.length model.clickableText


randomIndex : Model -> Int
randomIndex model =
    randomIndexAndSeed model |> Tuple.first


newSeed : Model -> Random.Seed
newSeed model =
    randomIndexAndSeed model |> Tuple.second


randomErasure : Model -> Model
randomErasure model =
    let
        words : List ClickableWord
        words =
            model.clickableText

        percent : Int
        percent =
            model.percentRandom

        desired : Int
        desired =
            desiredAmountErased model

        current : Int
        current =
            currentAmountErased model

        newModel =
            model
    in
    if current < desired then
        randomErasure (eraseAWord model)

    else if current == desired then
        model

    else
        randomErasure (bringBackAWord model)


eraseAWord : Model -> Model
eraseAWord model =
    let
        erasedWord =
            eraseAtIndex (randomIndex model) model.clickableText
    in
    case erasedWord of
        Just newWords ->
            { model
                | clickableText = newWords
                , seed = newSeed model
            }

        _ ->
            { model | seed = newSeed model }



--DEBUG?)


bringBackAWord : Model -> Model
bringBackAWord model =
    let
        broughtBackWord =
            bringBackAtIndex (randomIndex model) model.clickableText
    in
    case broughtBackWord of
        Just newWords ->
            { model
                | clickableText = newWords
                , seed = newSeed model
            }

        _ ->
            { model | seed = newSeed model }



--DEBUG?


randomIndexAndSeed : Model -> ( Int, Seed )
randomIndexAndSeed model =
    let
        total : Int
        total =
            totalNumberOfWords model

        seed : Random.Seed
        seed =
            model.seed
    in
    Random.step (Random.int 0 (totalNumberOfWords model - 1)) seed


eraseAtIndex : Int -> List ClickableWord -> Maybe (List ClickableWord)
eraseAtIndex index words =
    let
        wordAtIndex =
            Lex.getAt index words
    in
    case wordAtIndex of
        Just word ->
            case word.erased of
                True ->
                    Just words

                False ->
                    Lex.setAt index (eraseOrBringBack word) words
                        |> Just

        Nothing ->
            Nothing


bringBackAtIndex : Int -> List ClickableWord -> Maybe (List ClickableWord)
bringBackAtIndex index words =
    let
        wordAtIndex =
            Lex.getAt index words
    in
    case wordAtIndex of
        Just word ->
            case word.erased of
                True ->
                    Lex.setAt index (eraseOrBringBack word) words
                        |> Just

                False ->
                    Just words

        Nothing ->
            Nothing


isErased : ClickableWord -> Bool
isErased word =
    word.erased == True


isNotErased : ClickableWord -> Bool
isNotErased word =
    word.erased == False



---- VIEW ----


myStyles : List (Html.Attribute Msg)
myStyles =
    [ style "font-family" "Georgia" 
    , style "font-size" "20px" 
    , style "display" "inline-block" 
    , style "margin" "auto" 
    ]
        


htmlLegacyView : Model -> Html Msg
htmlLegacyView model =
    case model.textEntered of
        False ->
            enterYourTextScreen model

        True ->
            div myStyles
                [ div
                    [ style "width" "75%"
                    , style "display" "inline-block"
                    , style "margin" "auto"
                    , style "margin-top" "2em"
                    , style "margin-bottom" "1em"
                    ]
                    (List.map displayClickableWord model.clickableText)
                , Html.br [] []
                , Html.button (onClick GoBackToTextEntry :: appButtonStyle) [ Html.text "Enter different text" ]
                , Html.br [] []
                , Html.div
                    [ style "font-family" "'Arial', sans-serif"
                    , style "font-size" ".75em"
                    , style "display" "inline"
                    , style "width" "150px"
                    ]
                    [ Html.text "Erase "
                    , percentRandomInput
                    , Html.text "% of these words"
                    ]
                , Html.button (onClick Randomize :: appButtonStyle) [ Html.text "Go!" ]
                ]


view : Model -> Document Msg
view model =
    basicLayoutHelper (findScreenSize model.width) "ERASURE" "" [El.text "googoogaga"]
        

appButtonStyle : List (Html.Attribute Msg)
appButtonStyle =
    [ style "padding" "0 5px" 
    , style "border-radius" "0" 
    , style "border-width" "0" 
    , style "color" "black" 
    , style "background" "transparent" 
    , style "font-family" "'Arial', sans-serif" 
    , style "padding-left" "6em" 
    , style "padding-right" "6em" 
    , style "margin-bottom" "30px" 
    , style "display" "inline-block" 
    , style "font-size" ".75em" 
    ]
        


enterYourTextScreen : Model -> Html Msg
enterYourTextScreen model =
    div myStyles
        [ Html.br [] []
        , Html.br [] []
        , Html.textarea
            [ placeholder "Enter your text here"
            , onInput UpdateInputText
            , style "width" "800px"
            , style "height" "200px"
            ]
            []
        , Html.br [] []
        , Html.br [] []
        , Html.button (onClick (MakeTextClickable model.inputText) :: appButtonStyle) [ Html.text "Let's erase stuff!" ]
        ]


percentRandomInput : Html Msg
percentRandomInput =
    div []
        [ Html.input
            [ type_ "text"
            , size 3
            , onInput UpdatePercentRandom
            , style "display" "inline"
            , style "float" "left"
            , style "vertical-align" "middle"
            , style "width" "50px"
            ]
            []
        ]


displayClickableWord : ClickableWord -> Html Msg
displayClickableWord word =
    Html.span
        [ onClick (ToggleWord word), style "color" (wordColor word) ]
        [ Html.text (word.text ++ " ") ]


wordColor : ClickableWord -> String
wordColor word =
    case word.erased of
        True ->
            "whitesmoke"

        False ->
            "black"


      
