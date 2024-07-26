module Evergreen.V1.Types exposing (..)

import Browser
import Browser.Navigation
import Evergreen.V1.LatLng
import Lamdera
import Url


type alias FrontendModel =
    { key : Browser.Navigation.Key
    , paths : List Evergreen.V1.LatLng.Path
    }


type alias BackendModel =
    { message : String
    }


type FrontendMsg
    = UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url


type ToBackend
    = GetPath


type BackendMsg
    = DidWait Lamdera.ClientId


type ToFrontend
    = GotPaths (List Evergreen.V1.LatLng.Path)
