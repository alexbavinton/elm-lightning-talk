module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Time


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



--model


type alias TimeRemain =
    ( Int, Int )


type alias Model =
    { input : String
    , started : Bool
    , remaining : Int
    , mins : Int
    , secs : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { input = "", started = False, remaining = 0, mins = 0, secs = 0 }
    , Cmd.none
    )



--update


type Msg
    = Change String
    | Tick Time.Posix
    | Start


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change newInput ->
            ( { model | input = newInput }, Cmd.none )

        Start ->
            ( { model | started = True }, Cmd.none )

        Tick _ ->
            ( model , Cmd.none)
-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.started then
        Time.every 1000 Tick

    else
        Sub.none



--view


view : Model -> Html Msg
view model =
    div [ class "minInput" ]
        [ input [ placeholder "enter mins", value model.input, onInput Change ] []
        , div [] [ text model.input ]
        , button [ onClick Start ] [ text "Start" ]
        ]
