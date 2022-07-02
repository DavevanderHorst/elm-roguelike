module CssBlocks exposing (..)

import Html exposing (Attribute)
import Html.Attributes as Attr
import Images.ImageModels exposing (ImageModel)
import Levels.LevelOne exposing (Direction(..))


emptyCss : List (Attribute msg)
emptyCss =
    []


gridCss : Int -> String -> List (Attribute msg)
gridCss numberOfColumns rowWidth =
    [ Attr.style "display" "grid"
    , Attr.style "grid-template-columns" ("repeat(" ++ String.fromInt numberOfColumns ++ ", 1fr)")
    , Attr.style "width" rowWidth
    , Attr.style "margin" "25px"
    , Attr.style "padding" "5px"
    , Attr.style "background-color" "black"
    ]
        ++ borderCss 20


squareCss : Maybe Int -> String -> List (Attribute msg)
squareCss borderThickness color =
    [ Attr.style "aspect-ratio" "1/1"
    , Attr.style "align-items" "center"
    , Attr.style "align-items" "center"
    , Attr.style "background-color" color
    ]
        ++ (case borderThickness of
                Just a ->
                    borderCss a

                Nothing ->
                    emptyCss
           )


doorCss : String -> Direction -> List (Attribute msg)
doorCss color direction =
    let
        borderSide =
            case direction of
                North ->
                    "top"

                East ->
                    "right"

                South ->
                    "left"

                West ->
                    "bottom"
    in
    [ Attr.style ("border-" ++ borderSide ++ "-color") color
    , Attr.style ("border-" ++ borderSide ++ "-width") "12px"
    , Attr.style ("border-" ++ borderSide ++ "-style") "dashed"
    , Attr.style ("margin-" ++ borderSide) "-12px"
    , Attr.style ("margin-" ++ borderSide) "-12px"
    ]


squareIconCss : List (Attribute msg)
squareIconCss =
    [ Attr.style "width" "100%"
    , Attr.style "height" "100%"
    , Attr.style "object-fit" "contain"
    , Attr.style "object-position" "center"
    ]


borderCss : Int -> List (Attribute msg)
borderCss thickness =
    [ Attr.style "border-style" "solid"
    , Attr.style "border-width" (String.fromInt thickness ++ "px")
    , Attr.style "border-color" "black"
    ]


centerParentCss : List (Attribute msg)
centerParentCss =
    [ Attr.style "height" "100%"
    , Attr.style "width" "100%"
    , Attr.style "display" "flex"
    , Attr.style "align-items" "center"
    , Attr.style "justify-content" "center"
    ]


imgCss : ImageModel -> List (Attribute msg)
imgCss model =
    [ Attr.src model.path
    , Attr.alt "knight"
    , Attr.style "width" "40%"
    , Attr.style "height" "40%"
    , Attr.style "margin-right" model.marginRight
    ]
