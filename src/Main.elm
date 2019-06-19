port module Main exposing (main)

import Browser
import Debug
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Time


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }


port done : Bool -> Cmd msg



--model


type alias Model =
    { input : String
    , active : Bool
    , remaining : Int
    , mins : Int
    , secs : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { input = "", active = False, remaining = 0, mins = 0, secs = 0 }
    , Cmd.none
    )



--update


type Msg
    = Change String
    | Tick Time.Posix
    | Start


toMinsAndSecs : Int -> ( Int, Int )
toMinsAndSecs number =
    let
        secs =
            number
                |> remainderBy 60

        mins =
            number // 60
    in
    ( mins, secs )


isActive : Int -> Bool
isActive number =
    if number == 0 then
        False

    else
        True


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change newInput ->
            ( { model | input = newInput }, Cmd.none )

        Start ->
            let
                totalSeconds =
                    case String.toInt model.input of
                        Just minutes ->
                            minutes * 60

                        Nothing ->
                            0

                ( mins, secs ) =
                    toMinsAndSecs totalSeconds

                active =
                    isActive totalSeconds
            in
            ( { model | active = active, secs = secs, mins = mins, remaining = totalSeconds }, Cmd.none )

        Tick _ ->
            let
                newRemaining =
                    model.remaining - 1

                active =
                    isActive newRemaining

                ( newMins, newSecs ) =
                    toMinsAndSecs newRemaining

                command =
                    if not active then
                        done True

                    else
                        Cmd.none
            in
            ( { model | mins = newMins, secs = newSecs, remaining = newRemaining, active = active }, command )



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.active then
        Time.every 1000 Tick

    else
        Sub.none



--view


view : Model -> Html Msg
view model =
    div [ class "timer" ]
        [ div [ class "clock" ] [ text (String.fromInt model.mins ++ ":" ++ String.fromInt model.secs) ]
        , div []
            [ input [ class "input", placeholder "enter mins", value model.input, onInput Change, type_ "number" ] []
            , button [ onClick Start ] [ text "Start" ]
            ]
        ]
