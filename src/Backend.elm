module Backend exposing (app)

import Lamdera exposing (ClientId, SessionId)
import Types exposing (BackendModel, BackendMsg(..), ToBackend(..), ToFrontend(..))


type alias Model =
    BackendModel


app :
    { init : ( Model, Cmd Msg )
    , update : Msg -> Model -> ( Model, Cmd Msg )
    , updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd Msg )
    , subscriptions : Model -> Sub Msg
    }
app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = \_ -> Sub.none
        }


init : ( Model, Cmd Msg )
init =
    ( { message = "Hello!" }
    , Cmd.none
    )


type alias Msg =
    BackendMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend _ clientId msg model =
    case msg of
        GetPath ->
            let
                path =
                    [ { lat = 25.774, lng = -80.19 }
                    , { lat = 18.466, lng = -66.118 }
                    , { lat = 32.321, lng = -64.757 }
                    , { lat = 25.774, lng = -80.19 }
                    ]
            in
            ( model, Lamdera.sendToFrontend clientId (GotPaths [ path ]) )
