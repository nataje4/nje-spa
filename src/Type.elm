module Type exposing (..)


type Page
    = Loading
    | Home 
    | Poetry 
    | PoetryOfferings 
    | PoetryTools 
    | PoetryWordBank 
    | PoetryErasure 
    | Code 
    | CodeDemos 
    | Error 
    | FireDance

-- erasure

type alias ClickableWord =
    { text : String
    , erased : Bool
    , position : Int
    }

type ErasureSubPage 
    = EnterTextScreen
    | EraseWords
    | PreviewPoemText

-- word bank

type alias WordBankWord =
    { id : Int
    , word : String
    , used : Bool
    }

type alias PoemWord =
    { word : String
    , inWordBank : Bool
    }

