module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (..)
import Types exposing (..)
import Views.Setup.SearchControls exposing (searchControls)


view : Model -> Html Msg
view model =
    let
        layout =
            if List.isEmpty model.errors then
                [ searchControls model ]
            else
                [ errors model.errors, searchControls model ]
    in
    main_ [] layout


errors : List String -> Html Msg
errors messages =
    section
        [ class "errors" ]
        (List.map
            (\message -> div [ class "error-msg" ] [ text message ])
            messages
        )
