module Msg exposing (..)

import Browser exposing (UrlRequest)


type Msg
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | ResizeWindow Int Int
    | GotErasureMsg ErasureMsg
    | GotWordBankMsg WordBankMsg

type ErasureMsg 
    = ToggleWord ClickableWord
    | MakeTextClickable String
    | UpdateInputText String
    | Randomize
    | UpdatePercentRandom String
    | GetSeed (Maybe Time.Posix)
    | UpdateSubPage SubPage

type WordBankMsg 
    = UpdateWordBankInput String
    | CreateWordBank String
    | UpdatePoemInput String
    | Reset
