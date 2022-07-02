module Main exposing (..)

import Browser
import Browser.Events
import CssBlocks
import Dict
import Html exposing (Attribute, Html, div)
import Html.Attributes
import Images.ImageModels exposing (ImageModel, MonsterType(..), getMonsterModel, heroModel)
import Json.Decode as Decode
import Levels.LevelOne exposing (Cell, CellEvent(..), Direction, Level, LevelSetup, levelOne)
import List


main =
    Browser.element
        { init = initialModel
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onKeyPress keyDecoder


keyDecoder : Decode.Decoder Msg
keyDecoder =
    Decode.map KeyPressed (Decode.field "key" Decode.string)


type Msg
    = NoMessage
    | KeyPressed String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoMessage ->
            ( model, Cmd.none )

        KeyPressed key ->
            handleKeyPressed key model


type alias Model =
    { level : Level
    , heroSpot : Int
    , worldText : List String
    }


initialModel : () -> ( Model, Cmd Msg )
initialModel _ =
    ( { level = levelOne
      , heroSpot = levelOne.heroStartSpot
      , worldText = []
      }
    , Cmd.none
    )


view : Model -> Html msg
view model =
    div (CssBlocks.gridCss model.level.setup.cols "50%") (viewLevel model.level model.heroSpot)


viewLevel : Level -> Int -> List (Html msg)
viewLevel level heroSpot =
    let
        allCells =
            List.range 1 (level.setup.cols * level.setup.rows)
    in
    List.map (viewCell level heroSpot) allCells


viewCell : Level -> Int -> Int -> Html msg
viewCell level heroSpot currentCell =
    let
        cellFromDict =
            Dict.get currentCell level.grid
    in
    case cellFromDict of
        Nothing ->
            div (CssBlocks.squareCss Nothing "black") []

        Just cell ->
            handleCellView (heroSpot == currentCell) cell



--    ( borderThickness, color, event ) =
--        case cellFromDict of
--            Nothing ->
--                ( Nothing, "black", NoEvent )
--
--            Just cell ->
--                ( Just 1, "white", cell.event )
--
--    hasHero =
--        heroSpot == currentCell
--in
--div (CssBlocks.squareCss borderThickness color) [ handleCellView hasHero event ]


handleCellView : Bool -> Cell -> Html msg
handleCellView holdsHero cell =
    case cell.event of
        Monster monsterType ->
            div (CssBlocks.squareCss (Just 1) "white")
                [ if holdsHero then
                    doubleImageView heroModel (getMonsterModel monsterType)

                  else
                    imageView (getMonsterModel monsterType)
                ]

        NoEvent ->
            div (CssBlocks.squareCss (Just 1) "white")
                [ if holdsHero then
                    imageView heroModel

                  else
                    div [] []
                ]

        Entrance direction ->
            div (CssBlocks.squareCss (Just 1) "white" ++ CssBlocks.doorCss "green" direction)
                [ if holdsHero then
                    imageView heroModel

                  else
                    div [] []
                ]

        Exit direction ->
            div (CssBlocks.squareCss (Just 1) "white" ++ CssBlocks.doorCss "orange" direction)
                [ if holdsHero then
                    imageView heroModel

                  else
                    div [] []
                ]


doubleImageView : ImageModel -> ImageModel -> Html msg
doubleImageView hero image =
    div
        CssBlocks.centerParentCss
        [ Html.img (CssBlocks.imgCss hero) []
        , Html.img (CssBlocks.imgCss image) []
        ]


imageView : ImageModel -> Html msg
imageView imageModel =
    div CssBlocks.centerParentCss [ Html.img (CssBlocks.imgCss imageModel) [] ]


handleKeyPressed : String -> Model -> ( Model, Cmd Msg )
handleKeyPressed key model =
    case key of
        "d" ->
            handleHeroMovement Right model

        "w" ->
            handleHeroMovement Up model

        "s" ->
            handleHeroMovement Down model

        "a" ->
            handleHeroMovement Left model

        _ ->
            ( model, Cmd.none )


type Movement
    = Up
    | Down
    | Right
    | Left


handleHeroMovement : Movement -> Model -> ( Model, Cmd Msg )
handleHeroMovement movement model =
    let
        newAreaNumber =
            Maybe.withDefault 0 (nextAreaNumber movement model.heroSpot model.level.setup)

        newExistingArea =
            Dict.get newAreaNumber model.level.grid
    in
    case newExistingArea of
        Nothing ->
            ( model, Cmd.none )

        Just _ ->
            ( { model | heroSpot = newAreaNumber }, Cmd.none )


nextAreaNumber : Movement -> Int -> LevelSetup -> Maybe Int
nextAreaNumber movement currentSpot levelSetup =
    case movement of
        Up ->
            Just (currentSpot - levelSetup.cols)

        Down ->
            Just (currentSpot + levelSetup.cols)

        Right ->
            if remainderBy levelSetup.cols currentSpot == 0 then
                Nothing

            else
                Just (currentSpot + 1)

        Left ->
            if currentSpot /= 1 && remainderBy levelSetup.cols (currentSpot - 1) == 0 then
                Nothing

            else
                Just (currentSpot - 1)
