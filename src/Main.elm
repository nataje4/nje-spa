module Main exposing (..)

import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src)
import Browser
import Home exposing (..)
import Poetry exposing (..)
import Code exposing (..)
import Route exposing (Route)
import Url exposing (..)
import Browser.Navigation as Nav exposing (Key, load, pushUrl)


---- MODEL ----


type SubModel 
    = Home Home.Model
    | Poetry Poetry.Model 
    | Code Code.Model 


type alias Model =
    { key : Nav.Key
    , sub : SubModel
    }


init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    ( initModel navKey, Cmd.none )

initModel : Nav.Key -> Model 
initModel navKey = 
    { key = navKey
    , sub = Home Home.Model 
    }

type alias Flags = 
    {}

---- UPDATE ----


type Msg
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest


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
                            , Nav.pushUrl model.key (Url.toString url)
                            )

                Browser.External href ->
                    ( model
                    , Nav.load href
                    )

        ChangedUrl url ->
            changeRouteTo (Route.fromUrl url) model


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    case maybeRoute of
        Nothing ->
            Debug.todo "handle invalid route in changeRouteTo"
        Just Route.Poetry -> 
            (model, Route.replaceUrl model.key Route.Poetry)
        Just Route.Code -> 
            (model, Route.replaceUrl model.key Route.Code)
        Just Route.Home -> 
            (model, Route.replaceUrl model.key Route.Home)


---- VIEW ----


view : Model  -> Browser.Document msg
view model =
    case model.sub of 
        Home homeModel -> 
            Home.view homeModel

        Poetry poetryModel -> 
            Poetry.view poetryModel

        Code codeModel -> 
            Code.view codeModel


---- SUBSCRIPTIONS ----

subscriptions : Model -> Sub Msg
subscriptions model = 
    Sub.none

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
