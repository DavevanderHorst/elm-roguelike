module Images.ImageModels exposing (..)


type alias ImageModel =
    { path : String
    , marginRight : String
    }


heroModel : ImageModel
heroModel =
    ImageModel "src/Images/knight.png" "5%"
