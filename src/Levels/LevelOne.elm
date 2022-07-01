module Levels.LevelOne exposing (..)

import Dict exposing (Dict)


levelOne =
    Level 1 (LevelSetup 7 5) 1 grid


type alias Level =
    { level : Int
    , setup : LevelSetup
    , heroStartSpot : Int
    , grid : Dict Int Cell
    }


type alias LevelSetup =
    { cols : Int
    , rows : Int
    }


type alias Cell =
    {}


grid : Dict Int Cell
grid =
    Dict.fromList
        [ ( 1, Cell )
        , ( 2, Cell )
        , ( 9, Cell )
        , ( 10, Cell )
        , ( 11, Cell )
        , ( 18, Cell )
        , ( 25, Cell )
        , ( 26, Cell )
        , ( 27, Cell )
        , ( 28, Cell )
        , ( 35, Cell )
        ]
