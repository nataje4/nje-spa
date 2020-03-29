module Main exposing (..)

import Browser
import Browser.Dom exposing (Viewport, getViewport)
import Browser.Events exposing (onResize)
import Browser.Navigation as Nav exposing (Key, load, pushUrl)
import Html exposing (map)
import Model exposing (..)
import Msg exposing (..)
import Route exposing (Route(..))
import Task
import Type exposing (Page(..))
import Url exposing (..)
import Update exposing (..)
import View exposing (view)


---- MODEL ----



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
    basicInitModel flags Loading


type alias Flags =
    { width : Int
    }

{--
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
