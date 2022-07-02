module Levels.LevelOne exposing (..)

import Dict exposing (Dict)
import Images.ImageModels exposing (MonsterType(..))


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


type CellEvent
    = Monster MonsterType
    | NoEvent
    | Entrance Direction
    | Exit Direction


type Direction
    = North
    | East
    | South
    | West


type alias Cell =
    { event : CellEvent }


grid : Dict Int Cell
grid =
    Dict.fromList
        [ ( 1, Cell (Entrance North) )
        , ( 2, Cell NoEvent )
        , ( 9, Cell NoEvent )
        , ( 10, Cell NoEvent )
        , ( 11, Cell (Monster Goblin) )
        , ( 18, Cell NoEvent )
        , ( 25, Cell NoEvent )
        , ( 26, Cell NoEvent )
        , ( 27, Cell NoEvent )
        , ( 28, Cell NoEvent )
        , ( 35, Cell (Exit East) )
        ]
