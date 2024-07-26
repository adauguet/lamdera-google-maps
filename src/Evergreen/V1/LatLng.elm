module Evergreen.V1.LatLng exposing (..)


type alias LatLng =
    { lat : Float
    , lng : Float
    }


type alias Path =
    List LatLng
