module View exposing (..)

import Element exposing (row, centerX, centerY, width, height, fill, image)
import Type exposing (Page(..))
import Msg exposing (..)
import Model exposing (Model)
import Browser
import Code exposing (view)
import Code.Demos exposing (view)
import Error exposing (view)
import Home exposing (view)
import Poetry exposing (view)
import Poetry.Erasure exposing (view)
import Poetry.Offerings exposing (view)
import Poetry.Tools exposing (view)
import Poetry.WordBank exposing (view)

view : Model -> Browser.Document Msg
view model =
    case model.page of
        Home ->
            Home.view model

        Poetry ->
            Poetry.view model

        PoetryOfferings ->
            Poetry.Offerings.view model

        PoetryTools ->
            Poetry.Tools.view model

        PoetryWordBank ->
            Poetry.WordBank.view model

        PoetryErasure ->
            Poetry.Erasure.view model
            
        Code ->
            Code.view model

        CodeDemos ->
            Code.Demos.view model

        Error ->
            Error.view model

        Loading -> 
            { title = "..."
            , body = 
                [ Element.layout [ width fill, height fill]
                    ( image 
                        [ centerX, centerY]
                        { src = "assets/Spinner-1s-200px.gif"
                        , description = "page is loading..."
                        }
                    )
                ]

            }
