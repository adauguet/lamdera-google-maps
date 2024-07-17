module Types exposing (BackendModel, BackendMsg(..), FrontendModel, FrontendMsg(..), ToBackend(..), ToFrontend(..))

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Lamdera exposing (ClientId)
import LatLng exposing (Path)
import Url exposing (Url)


type alias FrontendModel =
    { key : Key
    , paths : List Path
    }


type alias BackendModel =
    { message : String
    }


type FrontendMsg
    = UrlClicked UrlRequest
    | UrlChanged Url


type ToBackend
    = GetPath


type BackendMsg
    = DidWait ClientId


type ToFrontend
    = GotPaths (List Path)
