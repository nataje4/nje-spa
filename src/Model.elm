module Model exposing (..)

import Type exposing (..)

type alias Model = 
    
	-- MAIN PART, ALWAYS IN USE -- 
    { width : Int
    , page : Page 
    -- ERASURE --
    , clickableText : List ClickableWord
    , subpage : SubPage
    , inputText : String
    , percentRandom : Int
    , seed : Random.Seed
    -- WORD BANK -- 
    , wordBank : List WordBankWord
    , poem : List PoemWord
    , input : String
    , enteringWordBank : Bool
    }