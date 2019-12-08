module Main exposing (..)


import Browser
import Browser.Events exposing (onResize)
import Browser.Dom exposing (getViewport, Viewport)
import Browser.Navigation as Nav exposing (Key, load, pushUrl)
import Home exposing (Model, initModel, view)
import Poetry exposing (Model, initModel, view)
import Code exposing (Model, initModel, view)
import Error exposing (Model, initModel, view)
import Route exposing (Route(..))
import Url exposing (..)
import Element exposing (Device, DeviceClass(..), Orientation(..), classifyDevice)
import Task

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
        route = (Route.fromUrl url)
    in 
        routeToModel route flags -- Model 
            |> changeRouteTo route 


type alias Flags = 
    WindowSize

type alias WindowSize =
    { width: Int 
    , height: Int
    }

---- UPDATE ----


type Msg
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | ResizeWindow Int Int 


update :  Msg -> Model -> ( Model, Cmd Msg )
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
                route = (Route.fromUrl url)
                windowSize = getWindowSize model 
            in 
                changeRouteTo route (routeToModel route windowSize) 
        
        ResizeWindow width height -> 
            let 
                windowSize : Flags
                windowSize = 
                    WindowSize width height

            in 
                ( updateWindowSize windowSize model  , Cmd.none )            



changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    let
        windowSize : Flags
        windowSize = 
            getWindowSize model
    in 
        case maybeRoute of
            Nothing ->
                (Error (Error.initModel windowSize), Cmd.none)
            Just Route.Poetry -> 
                (Poetry (Poetry.initModel windowSize), Cmd.none)
            Just Route.Code -> 
                (Code (Code.initModel windowSize), Cmd.none)
            Just Route.Home -> 
                (Home (Home.initModel windowSize), Cmd.none)

routeToModel: Maybe Route -> Flags -> Model
routeToModel maybeRoute flags =
    case maybeRoute of
        Just Route.Home -> 
            Home (Home.initModel flags)
        Just Route.Poetry -> 
            Poetry (Poetry.initModel flags)
        Just Route.Code  -> 
            Code (Code.initModel flags)
        Nothing -> 
            Error (Error.initModel flags)

updateWindowSize : Flags -> Model -> Model 
updateWindowSize windowSize model = 
    case model of 
        Home homeModel -> 
            Home { homeModel | windowSize = windowSize}

        Poetry poetryModel -> 
            Poetry { poetryModel | windowSize = windowSize}

        Code codeModel -> 
            Code { codeModel | windowSize = windowSize}

        Error errorModel -> 
            Error { errorModel | windowSize = windowSize}

getWindowSize : Model -> WindowSize
getWindowSize model = 
    case model of 
        Home homeModel -> 
            homeModel.windowSize

        Poetry poetryModel -> 
            poetryModel.windowSize

        Code codeModel -> 
            codeModel.windowSize

        Error errorModel -> 
            errorModel.windowSize

---- VIEW ----


view : Model  -> Browser.Document msg
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
