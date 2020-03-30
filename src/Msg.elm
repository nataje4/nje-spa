module Msg exposing (..)

import Browser exposing (UrlRequest)
import Url exposing (..)
import Type exposing (ClickableWord, ErasureSubPage)
import Time exposing (Posix, Month)

type Msg
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | ResizeWindow Int Int
    | GotErasureMsg ErasureMsg
    | GotWordBankMsg WordBankMsg
    | GotFireDanceMsg FireDanceMsg

type ErasureMsg 
    = ToggleWord ClickableWord
    | MakeTextClickable String
    | UpdateInputText String
    | Randomize
    | UpdatePercentRandom String
    | GetSeed (Maybe Time.Posix)
    | UpdateErasureSubPage ErasureSubPage

type WordBankMsg 
    = UpdateWordBankInput String
    | CreateWordBank String
    | UpdatePoemInput String
    | Reset

type FireDanceMsg 
    = UpdateDay Int 
    | UpdateMonth Time.Month