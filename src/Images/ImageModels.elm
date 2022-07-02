module Images.ImageModels exposing (..)


type alias ImageModel =
    { path : String
    , marginRight : String
    }


heroModel : ImageModel
heroModel =
    ImageModel "src/Images/knight.png" "5%"


goblinModel : ImageModel
goblinModel =
    ImageModel "src/Images/goblin.png" "0%"


type MonsterType
    = Goblin


getMonsterModel : MonsterType -> ImageModel
getMonsterModel monsterType =
    case monsterType of
        Goblin ->
            goblinModel
