module Route exposing (Route(..), fromUrl, href)

import Browser.Navigation as Nav
import Html exposing (Attribute)
import Html.Attributes as Attr
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)



-- ROUTING


type Route
    = Home
    | Poetry
    | PoetryOfferings
    | PoetryTools
    | PoetryWordBank
    | PoetryErasure
    | Code
    | CodeDemos
    | FireDance
    | Submit


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Home Parser.top
        , Parser.map Poetry (s "poetry")
        , Parser.map PoetryTools (s "poetry" </> s "tools")
        , Parser.map PoetryWordBank (s "poetry" </> s "tools" </> s "wordbank")
        , Parser.map PoetryErasure (s "poetry" </> s "tools" </> s "erasure")
        , Parser.map PoetryOfferings (s "poetry" </> s "offerings")
        , Parser.map Code (s "code")
        , Parser.map CodeDemos (s "code" </> s "demos")
        , Parser.map FireDance (s "firedance")
        , Parser.map Submit (s "submit")
        ]



-- PUBLIC HELPERS


href : Route -> Attribute msg
href targetRoute =
    Attr.href (routeToString targetRoute)



{--
replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key (routeToString route)
--}


fromUrl : Url -> Maybe Route
fromUrl url =
    -- The RealWorld spec treats the fragment like a path.
    -- This makes it *literally* the path, so we can proceed
    -- with parsing as if it had been a normal path all along.
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> Parser.parse parser



-- INTERNAL


routeToString : Route -> String
routeToString page =
    "#/" ++ String.join "/" (routeToPieces page)


routeToPieces : Route -> List String
routeToPieces page =
    case page of
        Home ->
            []

        Poetry ->
            [ "poetry" ]

        PoetryOfferings ->
            [ "poetry", "offerings" ]

        PoetryTools ->
            [ "poetry", "tools" ]

        PoetryWordBank ->
            [ "poetry", "tools", "wordbank" ]

        PoetryErasure ->
            [ "poetry", "tools", "erasure" ]

        Code ->
            [ "code" ]

        CodeDemos ->
            [ "code", "demos" ]

        FireDance -> 
            [ "firedance" ]

        Submit -> 
            [ "submit" ]
--}
