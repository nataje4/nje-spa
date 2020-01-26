module Main exposing (..)

import Browser
import Browser.Dom exposing (Viewport, getViewport)
import Browser.Events exposing (onResize)
import Browser.Navigation as Nav exposing (Key, load, pushUrl)
import Code exposing (Model, initModel, view)
import Code.Demos exposing (Model, initModel, view)
import Error exposing (Model, initModel, view)
import Home exposing (Model, initModel, view)
import Html exposing (map)
import Poetry exposing (Model, initModel, view)
import Poetry.Events exposing (Model, initModel, view)
import Poetry.Tools exposing (Model, initModel, view)
import Poetry.WordBank exposing (Model, initModel, view, Msg, update)
import Poetry.Erasure exposing (Model, initModel, view, Msg, update)
import Route exposing (Route(..))
import Task
import Url exposing (..)



---- MODEL ----


type Model
    = Home Home.Model
    | Poetry Poetry.Model
    | PoetryEvents Poetry.Events.Model
    | PoetryTools Poetry.Tools.Model
    | PoetryWordBank Poetry.WordBank.Model
    | PoetryErasure Poetry.Erasure.Model
    | Code Code.Model
    | CodeDemos Code.Demos.Model
    | Error Error.Model




--Flags are required by the Browser.application function


init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        route =
            Route.fromUrl url
    in
    routeToModel (initModel flags) route
        |> changeRouteTo route


initModel : Flags -> Model
initModel flags =
    --will flash to error page initially before init function finishes executing. TODO: fix this
    Error
        { width = flags.width
        , data = ""
        }


type alias Flags =
    { width : Int
    , data : String
    }



---- UPDATE ----
--TODO: make it so only the width matters on resize


type Msg
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | ResizeWindow Int Int
    | GotErasureMsg Poetry.Erasure.Msg
    | GotWordBankMsg Poetry.WordBank.Msg
    | GotPoetryMsg Poetry.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (msg, model)  of
        ( ClickedLink urlRequest, _ )->
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

        ( ChangedUrl url, _ )->
            let
                route =
                    Route.fromUrl url
            in
            changeRouteTo route (routeToModel model route)

        ( ResizeWindow width _, _ )->
            ( updateWidth width model, Cmd.none )

        (GotErasureMsg subMsg, PoetryErasure erasure) -> 
            Poetry.Erasure.update subMsg erasure
                |> updateWith PoetryErasure GotErasureMsg model


        (GotWordBankMsg subMsg, PoetryWordBank wordBank) -> 
            Poetry.WordBank.update subMsg wordBank
                |> updateWith PoetryWordBank GotWordBankMsg model

        (GotPoetryMsg subMsg, Poetry poetry) -> 
            Poetry.update subMsg poetry
                |> updateWith Poetry GotPoetryMsg model     
        (_, _) -> 
            (model, Cmd.none)   


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

        Just Route.PoetryEvents ->
            ( PoetryEvents (Poetry.Events.initModel newFlags), Cmd.none )

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
        
        Just Route.PoetryEvents ->
            PoetryEvents (Poetry.Events.initModel newFlags)

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

        PoetryEvents mod3l ->
            PoetryEvents { mod3l | width = width }
        
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

        PoetryEvents mod3l ->
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


---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    let 
        convertMsgType toMsg documentMsg =
            { title = documentMsg.title, body = List.map (Html.map toMsg) documentMsg.body}
    in 
    case model of
        Home mod3l ->
            Home.view mod3l
        Poetry mod3l ->
            Poetry.view mod3l
                |> convertMsgType GotPoetryMsg 
        PoetryEvents mod3l ->
            Poetry.Events.view mod3l
        PoetryTools mod3l ->
            Poetry.Tools.view mod3l
        PoetryWordBank mod3l ->
            Poetry.WordBank.view mod3l
                |> convertMsgType GotWordBankMsg 
        PoetryErasure mod3l ->
            Poetry.Erasure.view mod3l
                |> convertMsgType GotErasureMsg 
        Code mod3l ->
            Code.view mod3l
        CodeDemos mod3l ->
            Code.Demos.view mod3l
        Error mod3l ->
            Error.view mod3l



---- SUBSCRIPTIONS ----


subscriptions : model -> Sub Msg
subscriptions _ =
    onResize (\w h -> ResizeWindow w h)



---- PROGRAM ----


main : Program Flags Model Msg
main =
    Browser.application
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        }
