module LatLng exposing (LatLng, encode, Path)

import Json.Encode exposing (Value)


type alias LatLng =
    { lat : Float
    , lng : Float
    }


encode : LatLng -> Value
encode { lat, lng } =
    Json.Encode.object
        [ ( "lat", Json.Encode.float lat )
        , ( "lng", Json.Encode.float lng )
        ]

type alias Path = List LatLng
