module Frontend exposing (Model, Msg, app)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Css
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attributes
import Json.Encode
import Lamdera
import LatLng exposing (LatLng, Path)
import Types exposing (FrontendModel, FrontendMsg(..), ToBackend(..), ToFrontend(..))
import Url


type alias Model =
    FrontendModel


init : Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ key =
    ( { key = key
      , paths = []
      }
    , Lamdera.sendToBackend GetPath
    )


type alias Msg =
    FrontendMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged _ ->
            ( model, Cmd.none )


updateFromBackend : ToFrontend -> Model -> ( Model, Cmd Msg )
updateFromBackend msg model =
    case msg of
        GotPaths paths ->
            ( { model | paths = paths }, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Simple Map"
    , body =
        [ map
            { center =
                { lat = 24.886
                , lng = -70.268
                }
            , zoom = 5
            }
            (List.map pathToPolygon model.paths)
            |> Html.toUnstyled
        ]
    }


pathToPolygon : Path -> Html msg
pathToPolygon path =
    polygon
        { strokeColor = "#FF0000"
        , strokeOpacity = 0.8
        , strokeWeight = 2
        , fillColor = "#FF0000"
        , fillOpacity = 0.35
        , paths = path
        }


map : { center : LatLng, zoom : Int } -> List (Html msg) -> Html msg
map { center, zoom } =
    Html.node "google-map"
        [ Attributes.attribute "lat" (String.fromFloat center.lat)
        , Attributes.attribute "lng" (String.fromFloat center.lng)
        , Attributes.attribute "zoom" (String.fromInt zoom)
        , Attributes.css
            [ Css.display Css.block
            , Css.height (Css.pct 100)
            ]
        ]


type alias Options =
    { strokeColor : String
    , strokeOpacity : Float
    , strokeWeight : Float
    , fillColor : String
    , fillOpacity : Float
    , paths : List LatLng
    }


polygon : Options -> Html msg
polygon { strokeColor, strokeOpacity, strokeWeight, fillColor, fillOpacity, paths } =
    Html.node "google-polygon"
        [ Attributes.attribute "stroke-color" strokeColor
        , Attributes.attribute "stroke-opacity" (String.fromFloat strokeOpacity)
        , Attributes.attribute "stroke-weight" (String.fromFloat strokeWeight)
        , Attributes.attribute "fill-color" fillColor
        , Attributes.attribute "fill-opacity" (String.fromFloat fillOpacity)
        , Attributes.attribute "paths" (Json.Encode.encode 0 (Json.Encode.list LatLng.encode paths))
        ]
        []


app :
    { init : Lamdera.Url -> Nav.Key -> ( Model, Cmd Msg )
    , view : Model -> Browser.Document Msg
    , update : Msg -> Model -> ( Model, Cmd Msg )
    , updateFromBackend : ToFrontend -> Model -> ( Model, Cmd Msg )
    , subscriptions : Model -> Sub Msg
    , onUrlRequest : UrlRequest -> Msg
    , onUrlChange : Url.Url -> Msg
    }
app =
    Lamdera.frontend
        { init = init
        , onUrlRequest = UrlClicked
        , onUrlChange = UrlChanged
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = \_ -> Sub.none
        , view = view
        }
