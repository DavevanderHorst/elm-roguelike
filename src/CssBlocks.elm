module CssBlocks exposing (..)

import Html exposing (Attribute)
import Html.Attributes as Attr


gridCss : Int -> String -> List (Attribute msg)
gridCss numberOfColumns rowWidth =
    [ Attr.style "display" "grid"
    , Attr.style "grid-template-columns" ("repeat(" ++ String.fromInt numberOfColumns ++ ", 1fr)")
    , Attr.style "width" rowWidth
    , Attr.style "margin" "25px"
    , Attr.style "padding" "5px"
    ]
        ++ borderCss 5


squareCss : Int -> String -> List (Attribute msg)
squareCss thickness color =
    [ Attr.style "aspect-ratio" "1/1"
    , Attr.style "align-items" "center"
    , Attr.style "align-items" "center"
    , Attr.style "margin" "1px"
    , Attr.style "background-color" color
    ]
        ++ borderCss thickness


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
