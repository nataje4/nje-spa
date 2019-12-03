module Main exposing (..)

import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src)
import Browser
import Home exposing (..)
import Poetry exposing (..)
import Code exposing (..)
import Route exposing (Route(..))
import Url exposing (..)
import Browser.Navigation as Nav exposing (Key, load, pushUrl)


---- MODEL ----


type Model 
    = Home Home.Model
    | Poetry Poetry.Model 
    | Code Code.Model 
    | Err


--Flags are required by the Browser.application function
init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let 
        route = (Route.fromUrl url)
    in 
        changeRouteTo route (routeToModel route)

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
                            , Nav.load (Url.toString url)
                            )

                Browser.External href ->
                    ( model
                    , Nav.load href
                    )

        ChangedUrl url ->
            let 
                route = (Route.fromUrl url)
            in 
                changeRouteTo route (routeToModel route)


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    case maybeRoute of
        Nothing ->
            Debug.todo "handle invalid route in changeRouteTo"
        Just Route.Poetry -> 
            (Poetry Poetry.initModel, Cmd.none)
        Just Route.Code -> 
            (Code Code.initModel, Cmd.none)
        Just Route.Home -> 
            (Home Home.initModel, Cmd.none)

routeToModel: Maybe Route -> Model
routeToModel maybeRoute =
    case maybeRoute of
        Just Route.Home -> 
            Home Home.initModel
        Just Route.Poetry -> 
            Poetry Poetry.initModel
        Just Route.Code  -> 
            Code  Code.initModel
        Nothing -> 
            Err

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
        Err -> 
            { title = "NJE: ERROR"
            , body =
                [ div []
                    [ h1 [] [ text "ERROR PAGE NOT FOUND" ]
                    ]
                ]
            }


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
