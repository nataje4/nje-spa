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
import Poetry.Erasure exposing (Model, Msg, initModel, update, view)
import Poetry.Offerings exposing (Model, initModel, view)
import Poetry.Tools exposing (Model, initModel, view)
import Poetry.WordBank exposing (Model, Msg, initModel, update, view)
import Route exposing (Route(..))
import Task
import Url exposing (..)



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



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    let
        convertMsgType toMsg documentMsg =
            { title = documentMsg.title, body = List.map (Html.map toMsg) documentMsg.body }
    in
    case model.page of
        Home ->
            Home.view mod3l

        Poetry ->
            Poetry.view mod3l
                |> convertMsgType GotPoetryMsg

        PoetryOfferings ->
            Poetry.Offerings.view mod3l

        PoetryTools ->
            Poetry.Tools.view mod3l

        PoetryWordBank ->
            Poetry.WordBank.view mod3l
                |> convertMsgType GotWordBankMsg

        PoetryErasure ->
            Poetry.Erasure.view mod3l
                |> convertMsgType GotErasureMsg

        Code ->
            Code.view mod3l

        CodeDemos ->
            Code.Demos.view mod3l

        Error ->
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
