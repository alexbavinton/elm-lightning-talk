module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Time
import Debug


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


toMinsAndSecs: Int -> (Int, Int)
toMinsAndSecs number = 
  let 
    secs =
      number
          |> remainderBy 60

    mins = number // 60 
  in 
    (mins, secs)

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
                            minutes * 60 |> Debug.log "mins"


                        Nothing ->
                            0    
                
                (mins, secs) = toMinsAndSecs totalSeconds

                started =
                    if totalSeconds == 0 then
                        False

                    else
                        True
            in
            ( { model | started = started, secs = secs, mins = mins, remaining = totalSeconds }, Cmd.none )

        Tick _ ->
          let 
            newRemaining = model.remaining - 1 
            (newMins, newSecs) = toMinsAndSecs newRemaining
          in
            ( { model | mins = newMins,  secs = newSecs, remaining = newRemaining}, Cmd.none )  



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
        [ input [ placeholder "enter mins", value model.input, onInput Change, type_ "number" ] []
        , div [] [ text (String.fromInt model.secs) ]
        , button [ onClick Start ] [ text "Start" ]
        ]
