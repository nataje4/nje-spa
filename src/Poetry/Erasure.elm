module Poetry.Erasure exposing (..)

import Browser exposing (..)
import Debug exposing (log)
import Element as El exposing (..)
import Element.Events as Ee exposing (onClick)
import Element.Font as Ef exposing (color)
import Element.Input as Ei exposing (..)
import Html exposing (Html, div, img, text)
import List.Extra as Lex exposing (..)
import Random exposing (..)
import Task exposing (..)
import Time exposing (..)
import ViewHelpers exposing (..)


type alias ClickableWord =
    { text : String
    , erased : Bool
    , position : Int
    }

type SubPage 
    = EnterTextScreen
    | EraseWords
    | PreviewPoemText

type alias Model =
    { clickableText : List ClickableWord
    , subpage : SubPage
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
    , subpage = EnterTextScreen
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



update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleWord word ->
            let
                newText =
                    Lex.updateAt (word.position - 1) eraseOrBringBack model.clickableText
            in
            ( { model | clickableText = newText }, Cmd.none )

        

        UpdateInputText text ->
            ( { model | inputText = text }, Cmd.none )

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
        
        MakeTextClickable text ->
            let
                clickableText =
                    textToClickableWords model.inputText
            in
            if (String.isEmpty model.inputText) then 
                (model, Cmd.none)
            else 
                ( { model
                    | clickableText = clickableText
                    , subpage = EraseWords
                  }
                , Cmd.none
                )

        UpdateSubPage page -> 
            ( {model | subpage = page}, Cmd.none)


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
--displayBody has to be a list of rows


displayBody : Model -> List (Element Msg)
displayBody model =
    if model.subpage == EnterTextScreen then
        [ displayEnterTextScreen model ]

    {--
    else if (findScreenSize model.width == Large) || (findScreenSize model.width == ExtraLarge) then
        [ row [ width fill ]
            [ column [ width (fillPortion 3), padding 20 ]
                [ row [ width fill ]
                    [ textColumn [ paddingEach { noPadding | bottom = 20 } ]
                        [ paragraph [] (List.map displayClickableWord model.clickableText)
                        ]
                    ]
                , row [ width fill ]
                    [ el [ centerX ] (displayResetButton model)
                    ]
                ]
            , column [ width (fillPortion 1), padding 20, alignTop]
                [ displayPercentRandomInput model
                , el [ paddingEach { noPadding | top = 20 }, centerX ] (displayRandomizeButton model)
                ]
            ]
        ]
        --}
    else if model.subpage == EraseWords then 
        [ row [ width fill, padding 20 ]
            [ column [ width (fillPortion 1), centerX ] [ displayPercentRandomInput model ]
            , column [ width (fillPortion 1), centerX ] [ displayRandomizeButton model ]
            , column [ width (fillPortion 1), centerX ] [ displayTogglePreviewTextButton model ]
            ]
        , row [ width fill, padding 20 ]
            [ textColumn [ width fill ]
                [ paragraph [] (List.map displayClickableWord model.clickableText)
                ]
            ]
        , row [ width fill ]
            [ el [ centerX ] (displayResetButton model)
            ]
        ]
    else 
        [ row [ width fill, padding 20 ]
            [ column [ width (fillPortion 1), centerX ] [ displayTogglePreviewTextButton model ]
            ]
        , row [ width fill, padding 20 ]
            [ textColumn [ width fill ]
                [ List.filter (\x -> x.erased == False) model.clickableText
                    |> List.map displayClickableWord
                    |> paragraph []
                ]
            ]
        ]


view : Model -> Document Msg
view model =
    basicLayoutHelper (findScreenSize model.width) "ERASURE" "" (displayBody model)


displayEnterTextScreen : Model -> Element Msg
displayEnterTextScreen model =
    row [ width fill ]
        [ column [width fill] 
            [ multiline [padding 5]
                { onChange = UpdateInputText
                , text = model.inputText
                , placeholder = Nothing
                , label = labelAbove [] (El.text "Input source text here:")
                , spellcheck = False
                }
            , El.el [padding 20, centerX] 
                (button 
                    (buttonStyle (String.isEmpty model.inputText))
                    { onPress = Just (MakeTextClickable model.inputText)
                    , label = El.text "ENTER"
                    }
                )
            ]
        ]


displayResetButton : Model -> Element Msg
displayResetButton model =
    button (buttonStyle False)
        { onPress = Just (UpdateSubPage EnterTextScreen)
        , label = El.text "RESET TEXT"
        }


displayRandomizeButton : Model -> Element Msg
displayRandomizeButton model =
    button (buttonStyle (model.percentRandom == 0))
        { onPress = Just Randomize
        , label = El.text "RANDOMIZE"
        }

displayTogglePreviewTextButton : Model -> Element Msg 
displayTogglePreviewTextButton model = 
    let 
        selectedWords : List ClickableWord
        selectedWords = 
            List.filter (\x -> x.erased == False) model.clickableText

    in
    case model.subpage of 
            EraseWords -> 
                button (buttonStyle (List.isEmpty selectedWords))
                    { onPress = Just (UpdateSubPage PreviewPoemText)
                    , label = El.text "PREVIEW POEM TEXT"
                    }
            _ -> 
                button (buttonStyle (List.isEmpty selectedWords))
                    { onPress = Just (UpdateSubPage EraseWords)
                    , label = El.text "GO BACK"
                    }                




displayPercentRandomInput : Model -> Element Msg
displayPercentRandomInput model =
    Ei.text [ width (px 50)]
        { onChange = UpdatePercentRandom
        , text = String.fromInt model.percentRandom
        , placeholder = Nothing
        , label = labelLeft [centerY] (El.text "Percent of words to erase: ")
        }


displayClickableWord : ClickableWord -> Element Msg
displayClickableWord word =
    El.el
        [ onClick (ToggleWord word), Ef.color (wordColor word), padding 5]
        (El.text (word.text ++ " "))


wordColor : ClickableWord -> El.Color
wordColor word =
    case word.erased of
        True ->
            whitesmoke

        False ->
            black
