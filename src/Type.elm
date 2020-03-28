module Type exposing (..)


type Model
    = Home 
    | Poetry 
    | PoetryOfferings 
    | PoetryTools 
    | PoetryWordBank 
    | PoetryErasure 
    | Code 
    | CodeDemos 
    | Error 



type alias ClickableWord =
    { text : String
    , erased : Bool
    , position : Int
    }

type ErasureSubPage 
    = EnterTextScreen
    | EraseWords
    | PreviewPoemText

type alias WordBankWord =
    { id : Int
    , word : String
    , used : Bool
    }

type alias PoemWord =
    { word : String
    , inWordBank : Bool
    }

