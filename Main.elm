import Html exposing (Html, button, div, text, span)
import Html.App
import Keyboard

main =
  Html.App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

init : (Model, Cmd Msg)
init = (initModel, Cmd.none)

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model = Keyboard.presses KeyMsg

-- MODEL

type alias Model = Coord
type alias Coord =
  { x: Int
  , y: Int
  , lastKey: Int
  }

initModel : Model
initModel =
  { x = 0
  , y = 0
  , lastKey = 0
  }

-- UPDATE

type Msg
  = MoveLeft
  | MoveRight
  | KeyMsg Keyboard.KeyCode

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MoveLeft ->
      ({ model | x = model.x + 1 }, Cmd.none)

    MoveRight ->
      ({ model | x = model.x - 1 }, Cmd.none)

    KeyMsg code ->
      case code of
        97 -> update MoveRight model
        100 -> update MoveLeft model
        _ -> (model, Cmd.none)

-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ span [] [ text <| toString model.x ]
    ]
