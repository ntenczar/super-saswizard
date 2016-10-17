import Html exposing (Html, button, div, text, span)
import Html.App as Html
import Html.Events exposing (onClick)
import Keyboard exposing (KeyCode, isDown)

main =
  Html.beginnerProgram
    { model = initModel
    , view = view
    , update = update
    }

-- MODEL

type alias Model = Coord
type alias Coord =
  { x: Int
  , y: Int
  }

initModel : Model
initModel =
  { x = 0
  , y = 0
  }

-- UPDATE

type Msg
  = MoveLeft
  | MoveRight

update : Msg -> Model -> Model
update msg model =
  case msg of
    MoveLeft ->
      { model | x = model.x + 1 }

    MoveRight ->
      { model | x = model.x - 1 }

-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ span [] [ text <| toString model.x ]
    ]
