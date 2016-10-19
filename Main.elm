import Html exposing (Html, button, div, text, span)
import Html.App
import Keyboard
import Time
import AnimationFrame
import Window exposing (Size)
import Debug
import Collage exposing (..)
import Element exposing (..)
import Color exposing (..)
import Task

main : Program Never
main =
  Html.App.program
    { init = init
    , view = view
    , update = \msg model -> (update msg model, Cmd.none)
    , subscriptions = subscriptions
    }

init : (Model, Cmd Msg)
init = (initModel, Task.perform (\_ -> NoOp) SizeChange Window.size)

subscriptions : Model -> Sub Msg
subscriptions _ = Sub.batch
  [ Window.resizes SizeChange
  , Keyboard.downs KeyDown
  , Keyboard.ups KeyUp
  , AnimationFrame.diffs Tick
  ]

type Direction
  = Left
  | Right

type alias Keys =
  { x: Int
  , y: Int
  }

type alias Model =
  { x: Float
  , y: Float
  , vx: Float
  , vy: Float
  , dir: Direction
  , keys: Keys
  , size: Size
  }

initModel : Model
initModel =
  { x = 0
  , y = 0
  , vx = 0
  , vy = 0
  , dir = Right
  , keys = Keys 0 0
  , size = Size 0 0
  }

type Msg
  = SizeChange Size
  | KeyDown Int
  | KeyUp Int
  | Tick Float
  | NoOp

update : Msg -> Model -> Model
update msg model =
  case msg of
    KeyDown keyCode -> { model | keys = updateKeys keyCode model.keys }
    KeyUp keyCode -> { model | keys = updateKeys -keyCode model.keys }
    Tick dt -> step dt model
    SizeChange size -> { model | size = size}
    NoOp -> model

step : Float -> Model -> Model
step dt model =
  model
    |> gravity dt
    |> jump
    |> walk
    |> physics dt

jump : Model -> Model
jump model =
  if model.keys.y > 0 && model.vy == 0 then { model | vy = 6.0 } else model

gravity : Float -> Model -> Model
gravity dt model =
  { model | vy = if model.y > 0 then model.vy - dt/40 else 0 }

physics : Float -> Model -> Model
physics dt model =
  { model |
    x = model.x + dt * model.vx,
    y = max 0 (model.y + dt/10 * model.vy)
  }

walk : Model -> Model
walk model =
  { model |
    vx = (toFloat model.keys.x)/5,
    dir =
      case compare model.keys.x 0 of
        LT -> Left
        GT -> Right
        EQ -> model.dir
  }

updateKeys : Int -> Keys -> Keys
updateKeys keyCode keys =
  case Debug.log "Key: " keyCode of
    37 -> { keys | x = -1 }
    39 -> { keys | x = 1 }
    32 -> { keys | y = 1 }
    (-37) -> { keys | x = 0 }
    (-39) -> { keys | x = 0 }
    (-32) -> { keys | y = 0 }
    _ -> keys

view : Model -> Html msg
view model =
  let
    (w', h') = (model.size.width, model.size.height)
    (w, h) = (toFloat w', toFloat h')
    verb =
      case (model.y > 0, model.vx /= 0) of
        (True, _) -> "jump"
        (_, True) -> "walk"
        _ -> "stand"

    dir = case model.dir of
            Left -> "left"
            Right -> "right"

    src  = "img/" ++ dir ++ ".gif"

    marioImage = image 35 35 src

    groundY = 62 - h/2
  in
    collage w' h'
        [ rect w h
            |> filled (rgb 174 238 238)
        , rect w 50
            |> filled (rgb 74 167 43)
            |> move (0, 24 - h/2)
        , marioImage
            |> toForm
            |> move (model.x, model.y + groundY)
        ]
    |> toHtml
