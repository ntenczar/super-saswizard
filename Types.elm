module Types exposing (..)

import Window exposing (Size)

type Msg
  = SizeChange Size
  | KeyDown Int
  | KeyUp Int
  | Tick Float
  | NoOp

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
