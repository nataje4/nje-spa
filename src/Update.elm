module Update exposing (..)

import Browser exposing (..)
import Model exposing (..) 
import Msg exposing (..)
import Type exposing (..)

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
            ( , Cmd.none )

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

        GotErasureMsg (UpdateSubPage page )-> 
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
            ( initModel { width = model.width, data = "" }, Cmd.none )

        _ ->
            ( model, Cmd.none )


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )


routeChangeFlags : Model -> Flags
routeChangeFlags model =
    { width = getWidth model
    , data = ""
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
            ( Error (Error.initModel newFlags), Cmd.none )

        Just Route.Poetry ->
            ( Poetry (Poetry.initModel newFlags), Cmd.none )

        Just Route.PoetryOfferings ->
            ( PoetryOfferings (Poetry.Offerings.initModel newFlags), Cmd.none )

        Just Route.PoetryTools ->
            ( PoetryTools (Poetry.Tools.initModel newFlags), Cmd.none )

        Just Route.PoetryWordBank ->
            ( PoetryWordBank (Poetry.WordBank.initModel newFlags), Cmd.none )

        Just Route.PoetryErasure ->
            ( PoetryErasure (Poetry.Erasure.initModel newFlags), Cmd.none )

        Just Route.Code ->
            ( Code (Code.initModel newFlags), Cmd.none )

        Just Route.CodeDemos ->
            ( CodeDemos (Code.Demos.initModel newFlags), Cmd.none )

        Just Route.Home ->
            ( Home (Home.initModel newFlags), Cmd.none )


routeToModel : Model -> Maybe Route -> Model
routeToModel model maybeRoute =
    let
        newFlags : Flags
        newFlags =
            routeChangeFlags model
    in
    case maybeRoute of
        Just Route.Home ->
            Home (Home.initModel newFlags)

        Just Route.Poetry ->
            Poetry (Poetry.initModel newFlags)

        Just Route.PoetryOfferings ->
            PoetryOfferings (Poetry.Offerings.initModel newFlags)

        Just Route.PoetryTools ->
            PoetryTools (Poetry.Tools.initModel newFlags)

        Just Route.PoetryWordBank ->
            PoetryWordBank (Poetry.WordBank.initModel newFlags)

        Just Route.PoetryErasure ->
            PoetryErasure (Poetry.Erasure.initModel newFlags)

        Just Route.Code ->
            Code (Code.initModel newFlags)

        Just Route.CodeDemos ->
            CodeDemos (Code.Demos.initModel newFlags)

        Nothing ->
            Error (Error.initModel newFlags)


updateWidth : Int -> Model -> Model
updateWidth width model =
    case model of
        Home mod3l ->
            Home { mod3l | width = width }

        Poetry mod3l ->
            Poetry { mod3l | width = width }

        PoetryOfferings mod3l ->
            PoetryOfferings { mod3l | width = width }

        PoetryTools mod3l ->
            PoetryTools { mod3l | width = width }

        PoetryWordBank mod3l ->
            PoetryWordBank { mod3l | width = width }

        PoetryErasure mod3l ->
            PoetryErasure { mod3l | width = width }

        Code mod3l ->
            Code { mod3l | width = width }

        CodeDemos mod3l ->
            CodeDemos { mod3l | width = width }

        Error mod3l ->
            Error { mod3l | width = width }


getWidth : Model -> Int
getWidth model =
    case model of
        Home mod3l ->
            mod3l.width

        Poetry mod3l ->
            mod3l.width

        PoetryOfferings mod3l ->
            mod3l.width

        PoetryTools mod3l ->
            mod3l.width

        PoetryWordBank mod3l ->
            mod3l.width

        PoetryErasure mod3l ->
            mod3l.width

        Code mod3l ->
            mod3l.width

        CodeDemos mod3l ->
            mod3l.width

        Error mod3l ->
            mod3l.width

