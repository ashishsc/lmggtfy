module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (..)
import Types exposing (..)
import Views.Setup.SearchControls exposing (searchControls)


pageHeader : Html msg
pageHeader =
    div
        [ class "mdl-layout mdl-js-layout mdl-layout--fixed-header" ]
        [ header [ class "mdl-layout__header" ]
            [ div [ class "mdl-layout__header-row" ]
                [ span
                    [ class "mdl-layout-title" ]
                    [ text "Let Me Grep That For You - Create" ]
                ]
            ]
        ]


view : Model -> Html Msg
view model =
    let
        layout =
            if model.isLoading then
                [ loading ]
            else if List.isEmpty model.errors then
                [ searchControls model ]
            else
                [ errors model.errors, searchControls model ]
    in
    main_ [] (pageHeader :: layout)


errors : List String -> Html Msg
errors messages =
    section
        [ class "errors" ]
        (List.map
            (\message -> div [ class "error-msg" ] [ text message ])
            messages
        )


loading : Html msg
loading =
    div [] [ i [ class "fa fa-spinner" ] [] ]
