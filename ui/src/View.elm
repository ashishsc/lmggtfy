module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Messages exposing (..)
import String
import Types exposing (..)


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


repoSearchResults : Model -> Html Msg
repoSearchResults model =
    section [ class "search-results" ] []


searchControls : Model -> Html Msg
searchControls model =
    let
        repoSearch =
            [ input
                [ type_ "text"
                , class "search-box"
                , onInput RepoSearchUpdated
                ]
                []
            , button
                [ class "button"
                , onClick SearchRepoClicked
                ]
                [ text "Find Repos" ]
            ]

        grep =
            [ input
                [ type_ "text"
                , class "search-box"
                , onInput GrepUpdated
                ]
                []
            , button
                [ class "button"
                , onClick GrepClicked
                ]
                [ text "git grep" ]
            ]
    in
    if List.isEmpty model.repos then
        section [ class "search-controls" ] repoSearch
    else
        section [ class "search-controls" ]
            (List.concat [ repoSearch, grep ])
