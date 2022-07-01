module Main exposing (..)

import Browser
import Browser.Events
import CssBlocks
import Dict
import Html exposing (Attribute, Html, div)
import Html.Attributes as Attr
import Images.ImageModels exposing (ImageModel, heroModel)
import Json.Decode as Decode
import Levels.LevelOne exposing (Level, LevelSetup, levelOne)
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

        color =
            case cellFromDict of
                Nothing ->
                    "black"

                Just _ ->
                    "white"
    in
    div (CssBlocks.squareCss 2 color)
        [ if heroSpot == currentCell then
            imageView heroModel

          else
            div [] []
        ]


imageView : ImageModel -> Html msg
imageView imageModel =
    div
        [ Attr.style "height" "100%"
        , Attr.style "width" "100%"
        , Attr.style "display" "flex"
        , Attr.style "align-items" "center"
        , Attr.style "justify-content" "center"
        ]
        [ Html.img
            [ Attr.src imageModel.path
            , Attr.alt "knight"
            , Attr.style "width" "40%"
            , Attr.style "height" "40%"
            , Attr.style "margin-right" imageModel.marginRight
            ]
            []
        ]


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
