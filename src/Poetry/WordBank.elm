module WordBank exposing (..)

import Html exposing (..)
import Html.Attributes as Attr exposing (class, classList, value)
import Html.Events exposing (onClick, onInput)
import Browser exposing (document, Document)



---- MODEL ----


type alias Model =
    { wordBank : List WordBankWord
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


type alias Flags = 
    {}

init : Flags -> ( Model, Cmd Msg )
init flags =
    ( initModel, Cmd.none )


initModel : Model
initModel =
    { wordBank = []
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
            ( initModel, Cmd.none )



--is inWordBank getting set after the word is getting marked as used? ***
---- VIEW ----


view : Model -> Document Msg
view model =
    { title = "NJE: WORD BANK"
    , body =     
        [div []
            (case model.enteringWordBank of
                True ->  
                    [ div
                        [ class "word-bank-input" ]
                        [ textarea
                            [ onInput UpdateWordBankInput
                            , value model.input
                            ]
                            []
                        , div
                            [ class "button-div" ]
                            [ button
                                [ onClick (CreateWordBank model.input) ]
                                [ Html.text "this is my word bank" ]
                            ]
                        ]
                    ]
                    

                False ->
                    [ div
                        [ class "working-div" ]
                        [ displayWholeWordBank model
                        , displayExtraWordsDiv model
                        ]
                    , div
                        [ class "working-div" ]
                        [ displayPoemInput model
                        ]
                    , div
                        [ class "button-div" ]
                        [ button
                            [ onClick Reset ]
                            [ Html.text "start over" ]
                        ]
                    ]                    
            )
        ]
    }



{--
clickableWordBankWord : WordBankWord -> Html Msg
clickableWordBankWord wbWord =
    span
        [ onClick ]
        [] --}


displayWordBankWord : WordBankWord -> Html Msg
displayWordBankWord wbWord =
    span
        [ classList [ ( "used", wbWord.used ), ( "word-bank-word", True ) ] ]
        [ Html.text (wbWord.word ++ " ") ]


displayWholeWordBank : Model -> Html Msg
displayWholeWordBank model =
    div
        [ class "word-bank-display" ]
        (List.map displayWordBankWord model.wordBank)


displayPoemInput : Model -> Html Msg
displayPoemInput model =
    div
        [ class "poem-input" ]
        [ textarea
            [ onInput UpdatePoemInput
            , value model.input
            ]
            []
        ]


displayExtraPoemWord : PoemWord -> Html Msg
displayExtraPoemWord poemW =
    span
        [ class "extra-word" ]
        [ Html.text poemW.word ]


displayExtraWordsDiv : Model -> Html Msg
displayExtraWordsDiv model =
    List.filter (\w -> w.inWordBank == False) model.poem
        |> List.map displayExtraPoemWord
        |> div [ class "extra-words-div" ]



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



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Browser.document
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
