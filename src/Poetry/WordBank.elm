module Poetry.WordBank exposing (..)

import Browser exposing (Document, document)
import Element as El exposing (..)
import Element.Font as Ef exposing (center, color)
import Element.Input as Ei exposing (..)
import ViewHelpers exposing (..)



---- MODEL ----


type alias Model =
    { width : Int
    , data : String
    , wordBank : List WordBankWord
    , poem : List PoemWord
    , input : String
    , enteringWordBank : Bool
    }


type alias WordBankWord =
    { id : Int
    , word : String
    , used : Bool
    }


type alias PoemWord =
    { word : String
    , inWordBank : Bool
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initModel flags, Cmd.none )


type alias Flags =
    { width : Int
    , data : String
    }


initModel : Flags -> Model
initModel flags =
    { width = flags.width
    , data = flags.data
    , wordBank = []
    , poem = []
    , input = ""
    , enteringWordBank = True
    }



---- UPDATE ----


type Msg
    = UpdateWordBankInput String
    | CreateWordBank String
    | UpdatePoemInput String
    | Reset


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateWordBankInput str ->
            ( { model | input = str }, Cmd.none )

        CreateWordBank str ->
            if (String.isEmpty model.input) then 
                (model, Cmd.none)
            else 
                ( { model
                    | input = ""
                    , enteringWordBank = False
                    , wordBank = inputToWordBank str
                  }
                , Cmd.none
                )

        UpdatePoemInput str ->
            let
                resetWordBank : List WordBankWord
                resetWordBank =
                    setAllWordBankWordsToUnused model.wordBank

                newPoemVersion : List PoemWord
                newPoemVersion =
                    poemInputIntoPoemWords model str

                newWordBank : List WordBankWord
                newWordBank =
                    resetWordBank |> (\w0rdBank -> List.foldr updateWordBank w0rdBank newPoemVersion)
            in
            ( { model
                | poem = newPoemVersion
                , wordBank = resetWordBank |> (\w0rdBank -> List.foldr updateWordBank w0rdBank newPoemVersion)
                , input = str
              }
            , Cmd.none
            )

        Reset ->
            ( initModel { width = model.width, data = "" }, Cmd.none )



--is inWordBank getting set after the word is getting marked as used? ***
---- VIEW ----


view : Model -> Document Msg
view model =
    basicLayoutHelper (findScreenSize model.width) "WORD BANK" "" (displayBody model)



{--
clickableWordBankWord : WordBankWord -> Html Msg
clickableWordBankWord wbWord =
    span
        [ onClick ]
        [] --}
-- We want the display body to be a list of rows


displayBody : Model -> List (Element Msg)
displayBody model =
    if model.enteringWordBank then
        [ displayWordBankInput model
        , row [ width fill ] [ displayCreateWordBankButton model ]
        ]

    else if (findScreenSize model.width == Large) || (findScreenSize model.width == ExtraLarge) then
        [ row
            [ width fill ]
            [ displayWordBankWithExtraWords model
            , displayPoemInput model
            ]
        ]

    else
        [ row [ width fill ] [ displayWordBankWithExtraWords model ]
        , row [ width fill ] [ displayPoemInput model ]
        ]


displayCreateWordBankButton : Model -> Element Msg
displayCreateWordBankButton model =
    button (buttonStyle (String.isEmpty model.input))
        { onPress = Just (CreateWordBank model.input)
        , label = El.text "ENTER"
        }


displayResetButton : Model -> Element Msg
displayResetButton model =
    button (buttonStyle False) 
        { onPress = Just Reset
        , label = El.text "RESET"
        }


displayWordBankWord : WordBankWord -> Element Msg
displayWordBankWord wbWord =
    if wbWord.used then
        el [ Ef.color whitesmoke, padding 5 ] (El.text (wbWord.word ++ " "))

    else
        el [ Ef.color black, padding 5 ] (El.text (wbWord.word ++ " "))


displayWordBank : Model -> Element Msg
displayWordBank model =
    El.textColumn
        [ width fill, Ef.center ]
        [ paragraph [] (List.map displayWordBankWord model.wordBank) ]


displayExtraPoemWord : PoemWord -> Element Msg
displayExtraPoemWord poemW =
    el [ Ef.color lightBlue ] (El.text (poemW.word ++ " "))

displayExtraWords : Model -> Element Msg
displayExtraWords model =
    List.filter (\w -> w.inWordBank == False) model.poem
        |> List.map displayExtraPoemWord
        |> paragraph []
        |> List.singleton
        |> El.textColumn [ width fill, paddingEach { noPadding | top = 20 }, Ef.center ]


displayWordBankWithExtraWords : Model -> Element Msg
displayWordBankWithExtraWords model =
    El.column
        [ width (fillPortion 1), padding 30 ]
        [ row [ width fill ] [ displayWordBank model ], row [ width fill ] [ displayExtraWords model ] ]


displayPoemInput : Model -> Element Msg
displayPoemInput model =
    El.column
        [ width (fillPortion 1), padding 20, alignTop ]
        [ row [ width fill ]
            [ multiline []
                { onChange = UpdatePoemInput
                , text = model.input
                , placeholder = Nothing
                , label = labelAbove [] (El.text "Write poem here:")
                , spellcheck = False
                }
            ]
        , row [ centerX, paddingEach { noPadding | top = 20 } ] [ displayResetButton model ]
        ]


displayWordBankInput : Model -> Element Msg
displayWordBankInput model =
    El.row
        [ width fill, padding 20 ]
        [ multiline []
            { onChange = UpdateWordBankInput
            , text = model.input
            , placeholder = Nothing
            , label = labelAbove [] (El.text "Input source text here:")
            , spellcheck = False
            }
        ]



-- HELPERS


poemInputIntoPoemWords : Model -> String -> List PoemWord
poemInputIntoPoemWords model str =
    str
        |> String.words
        |> List.map (String.filter isNotExtraPunctuation)
        |> List.map (newPoemWord model)


newPoemWord : Model -> String -> PoemWord
newPoemWord model str =
    { word = str
    , inWordBank = poemWordInWordBank model str
    }


findPoemWordInWordBank : Model -> String -> Maybe WordBankWord
findPoemWordInWordBank model str =
    model.wordBank
        |> List.filter (\x -> x.used == False)
        |> List.filter (\x -> String.toLower x.word == String.toLower str)
        |> List.head


poemWordInWordBank : Model -> String -> Bool
poemWordInWordBank model str =
    let
        timesInWordBank : Int
        timesInWordBank =
            List.filter (\w -> w.word == str) model.wordBank
                |> List.length

        timesInPoem : Int
        timesInPoem =
            List.filter (\w -> w.word == str) model.poem
                |> List.length
    in
    if timesInPoem > timesInWordBank then
        False

    else
        True


setToUnused : WordBankWord -> WordBankWord
setToUnused wbw =
    { id = wbw.id
    , word = wbw.word
    , used = False
    }


setAllWordBankWordsToUnused : List WordBankWord -> List WordBankWord
setAllWordBankWordsToUnused w0rdBank =
    List.map setToUnused w0rdBank



{--
toggleToUsedIfPoemWord : PoemWord -> WordBankWord -> WordBankWord
toggleToUsedIfPoemWord poemW wbw =
    case ((String.toLower wbw.word) == (String.toLower poemW.word)) of
        True ->
            toggleWordBankWordUsed wbw

        False ->
            wbw
--}


updateWordBank : PoemWord -> List WordBankWord -> List WordBankWord
updateWordBank poemW w0rdBank =
    List.map (toggleToUsedIfIsFirstUnusedInstanceOfWord poemW w0rdBank) w0rdBank


toggleToUsedIfIsFirstUnusedInstanceOfWord : PoemWord -> List WordBankWord -> WordBankWord -> WordBankWord
toggleToUsedIfIsFirstUnusedInstanceOfWord poemW w0rdBank wordBeingTested =
    case isFirstUnusedInstanceOfWord poemW w0rdBank wordBeingTested of
        True ->
            toggleWordBankWordUsed wordBeingTested

        False ->
            wordBeingTested



-- filter to find first instance of the word in the word bank, then toggle to used if same ID


firstUnusedInstanceOfWord : PoemWord -> List WordBankWord -> Maybe WordBankWord
firstUnusedInstanceOfWord poemW w0rdBank =
    List.filter (\w -> w.used == False) w0rdBank
        |> List.filter (\w -> String.toLower w.word == String.toLower poemW.word)
        |> List.head


isFirstUnusedInstanceOfWord : PoemWord -> List WordBankWord -> WordBankWord -> Bool
isFirstUnusedInstanceOfWord poemW w0rdBank wordBeingTested =
    let
        theFirst : Maybe WordBankWord
        theFirst =
            firstUnusedInstanceOfWord poemW w0rdBank
    in
    case theFirst of
        Just aWordBankWord ->
            isSameWordBankWord aWordBankWord wordBeingTested

        Nothing ->
            False



{--
updateWordBankToIndicateUse : List WordBankWord -> Maybe WordBankWord -> List WordBankWord
updateWordBankToIndicateUse wb wbWord =
    case wbWord of
        Just foo ->
            List.map (helperWordBankScanner foo) wb

        Nothing ->
            wb


helperWordBankScanner : WordBankWord -> WordBankWord -> WordBankWord
helperWordBankScanner compareToThis listMember =
    case isSameWordBankWord compareToThis listMember of
        True ->
            toggleWordBankWordUsed listMember

        False ->
            listMember

--}


isSameWordBankWord : WordBankWord -> WordBankWord -> Bool
isSameWordBankWord a b =
    (==) a.id b.id


toggleWordBankWordUsed : WordBankWord -> WordBankWord
toggleWordBankWordUsed wbWord =
    { wbWord | used = True }



{--
poemWordScansWordBankCompleteProcess : Model -> String -> Model
poemWordScansWordBankCompleteProcess model str =
    let
        newWordBank : List WordBankWord
        newWordBank =
            findPoemWordInWordBank model str
                |> updateWordBankToIndicateUse model.wordBank
--}
---- HELPERS ----


inputToWordBank : String -> List WordBankWord
inputToWordBank str =
    str
        |> String.words
        |> List.map (String.filter isNotExtraPunctuation)
        |> List.indexedMap createWordBankWord


createWordBankWord : Int -> String -> WordBankWord
createWordBankWord id word =
    { id = id
    , word = word
    , used = False
    }


isNotExtraPunctuation : Char -> Bool
isNotExtraPunctuation char =
    String.toList "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'1234567890"
        |> List.member char
