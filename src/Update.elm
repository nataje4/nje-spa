module Update exposing (..)

import Browser exposing (..)
import Browser.Navigation as Nav exposing (..)
import Code exposing (init)
import Code.Demos exposing (init)
import Error exposing (init)
import Home exposing (init)
import List.Extra as Lex exposing (..)
import Model exposing (..) 
import Msg exposing (Msg(..), ErasureMsg(..), WordBankMsg(..))
import Poetry exposing (init)
import Poetry.Erasure exposing (init, textToClickableWords, eraseOrBringBack, randomErasure)
import Poetry.Offerings exposing (init)
import Poetry.Tools exposing (init)
import Poetry.WordBank exposing (init, inputToWordBank, updateWordBank, poemInputIntoPoemWords, setAllWordBankWordsToUnused)
import Random exposing (initialSeed)
import Route exposing (..)
import Time exposing (posixToMillis)
import Type exposing (..)
import Url exposing (..)




update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedLink urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    case url.fragment of
                        Nothing ->
                            -- If we got a link that didn't include a fragment,
                            -- it's from one of those (href "") attributes that
                            -- we have to include to make the RealWorld CSS work.
                            --
                            -- In an application doing path routing instead of
                            -- fragment-based routing, this entire
                            -- `case url.fragment of` expression this comment
                            -- is inside would be unnecessary.
                            ( model, Cmd.none )

                        Just _ ->
                            ( model
                            , Nav.load (Url.toString url)
                            )

                Browser.External href ->
                    ( model
                    , Nav.load href
                    )

        ChangedUrl url ->
            let
                route =
                    Route.fromUrl url
            in
            changeRouteTo route (routeToModel model route)

        ResizeWindow width _ ->
            ({model | width =width} , Cmd.none )

        -- ERASURE MSGS -- 

        GotErasureMsg (ToggleWord word) ->
            let
                newText =
                    Lex.updateAt (word.position - 1) eraseOrBringBack model.clickableText
            in
            ( { model | clickableText = newText }, Cmd.none )


        GotErasureMsg (UpdateInputText text) ->
            ( { model | inputText = text }, Cmd.none )

        GotErasureMsg (Randomize) ->
            ( randomErasure model, Cmd.none )

        GotErasureMsg (UpdatePercentRandom string) ->
            ( { model | percentRandom = Maybe.withDefault 0 (String.toInt string) }, Cmd.none )

        GotErasureMsg (GetSeed (Just time)) ->
            let
                timeSeed =
                    Random.initialSeed (Time.posixToMillis time)
            in
            ( { model | seed = timeSeed }, Cmd.none )

        GotErasureMsg (GetSeed Nothing) ->
            --This would be an error, but I am not too concerned with it... I have a fallback seed
            ( model
            , Cmd.none
            )
        
        GotErasureMsg (MakeTextClickable text) ->
            let
                clickableText =
                    textToClickableWords model.inputText
            in
            if (String.isEmpty model.inputText) then 
                (model, Cmd.none)
            else 
                ( { model
                    | clickableText = clickableText
                    , erasureSubpage = EraseWords
                  }
                , Cmd.none
                )

        GotErasureMsg (UpdateErasureSubPage page )-> 
            ( {model | erasureSubpage = page}, Cmd.none)

        GotWordBankMsg (UpdateWordBankInput str) ->
            ( { model | input = str }, Cmd.none )

        GotWordBankMsg (CreateWordBank str) ->
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

        GotWordBankMsg (UpdatePoemInput str) ->
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

        GotWordBankMsg (Reset) ->
            ( basicInitModel {width = model.width} Type.PoetryWordBank, Cmd.none )


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )


routeChangeFlags : Model -> Flags
routeChangeFlags model =
    { width = model.width
    }


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    let
        newFlags : Flags
        newFlags =
            routeChangeFlags model
    in
    case maybeRoute of
        Nothing ->
            Error.init newFlags

        Just Route.Poetry ->
            Poetry.init newFlags

        Just Route.PoetryOfferings ->
            Poetry.Offerings.init newFlags

        Just Route.PoetryTools ->
            Poetry.Tools.init newFlags

        Just Route.PoetryWordBank ->
            Poetry.WordBank.init newFlags

        Just Route.PoetryErasure ->
            Poetry.Erasure.init newFlags

        Just Route.Code ->
            Code.init newFlags

        Just Route.CodeDemos ->
            Code.Demos.init newFlags

        Just Route.Home ->
            Home.init newFlags


routeToModel : Model -> Maybe Route -> Model
routeToModel model maybeRoute =
    let
        newFlags : Flags
        newFlags =
            routeChangeFlags model
    in
    case maybeRoute of
        Just Route.Home ->
            Home.init newFlags
                |> Tuple.first

        Just Route.Poetry ->
            Poetry.init newFlags
                |> Tuple.first

        Just Route.PoetryOfferings ->
            Poetry.Offerings.init newFlags
                |> Tuple.first

        Just Route.PoetryTools ->
            Poetry.Tools.init newFlags
                |> Tuple.first

        Just Route.PoetryWordBank ->
            Poetry.WordBank.init newFlags
                |> Tuple.first

        Just Route.PoetryErasure ->
            Poetry.Erasure.init newFlags
                |> Tuple.first

        Just Route.Code ->
            Code.init newFlags
                |> Tuple.first

        Just Route.CodeDemos ->
            Code.Demos.init newFlags
                |> Tuple.first

        Nothing ->
            Error.init newFlags
                |> Tuple.first

--}