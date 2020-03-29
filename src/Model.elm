module Model exposing (..)

import Type exposing (..)
import Random exposing (Seed, initialSeed )

type alias Model = 
    -- MAIN PART, ALWAYS IN USE -- 
    { width : Int
    , page : Page 
    -- ERASURE --
    , clickableText : List ClickableWord
    , erasureSubpage : ErasureSubPage
    , inputText : String
    , percentRandom : Int
    , seed : Random.Seed
    -- WORD BANK -- 
    , wordBank : List WordBankWord
    , poem : List PoemWord
    , input : String
    , enteringWordBank : Bool
    }

type alias Flags = 
    { width : Int 
    }

basicInitModel : Flags -> Page -> Model
basicInitModel flags page = 
    { blankModel | width = flags.width, page = page }

blankModel : Model 
blankModel = 
    -- MAIN PART, ALWAYS IN USE -- 
    { width = 0
    , page = Loading 
    -- ERASURE --
    , clickableText = []
    -- todo: change erasureSubpage into a maybe type
    , erasureSubpage = EnterTextScreen
    , inputText = ""
    , percentRandom = 90
    , seed = Random.initialSeed 42
    -- WORD BANK -- 
    , wordBank = []
    , poem = []
    , input = ""
    , enteringWordBank = True 
    }