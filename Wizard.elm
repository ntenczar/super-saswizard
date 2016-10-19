module Wizard exposing (drawWizard)
import Collage exposing (..)
import Element exposing (..)
import Color exposing (..)
import Types exposing (..)

import Html exposing (Html)

drawWizard : Model -> Html msg
drawWizard model =
  let
    (w', h') = (model.size.width, model.size.height)
    (w, h) = (toFloat w', toFloat h')
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
