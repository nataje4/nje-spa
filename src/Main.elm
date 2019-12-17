module Main exposing (..)

import Browser
import Browser.Dom exposing (Viewport, getViewport)
import Browser.Events exposing (onResize)
import Browser.Navigation as Nav exposing (Key, load, pushUrl)
import Code exposing (Model, initModel, view)
import Element exposing (Device, DeviceClass(..), Orientation(..), classifyDevice)
import Error exposing (Model, initModel, view)
import Home exposing (Model, initModel, view)
import Poetry exposing (Model, initModel, view)
import Route exposing (Route(..))
import Task
import Url exposing (..)



---- MODEL ----


type Model
    = Home Home.Model
    | Poetry Poetry.Model
    | Code Code.Model
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
        , menuOpen = False
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
            ( updateWidth width model, Cmd.none )


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

        Just Route.Code ->
            ( Code (Code.initModel newFlags), Cmd.none )

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

        Just Route.Code ->
            Code (Code.initModel newFlags)

        Nothing ->
            Error (Error.initModel newFlags)


updateWidth : Int -> Model -> Model
updateWidth width model =
    case model of
        Home homeModel ->
            Home { homeModel | width = width }

        Poetry poetryModel ->
            Poetry { poetryModel | width = width }

        Code codeModel ->
            Code { codeModel | width = width }

        Error errorModel ->
            Error { errorModel | width = width }


getWidth : Model -> Int
getWidth model =
    case model of
        Home homeModel ->
            homeModel.width

        Poetry poetryModel ->
            poetryModel.width

        Code codeModel ->
            codeModel.width

        Error errorModel ->
            errorModel.width



---- VIEW ----


view : Model -> Browser.Document msg
view model =
    case model of
        Home home ->
            Home.view home

        Poetry poetry ->
            Poetry.view poetry

        Code code ->
            Code.view code

        Error error ->
            Error.view error



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
