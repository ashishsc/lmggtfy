module Views.Setup.SearchControls exposing (searchControls)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Messages exposing (..)
import String
import Types exposing (..)


repoSearchResults : Model -> Html Msg
repoSearchResults model =
    section [ class "search-results" ] []


searchControls : Model -> Html Msg
searchControls model =
    let
        repoSearch =
            div []
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

        repoSelector =
            ul [ class "repo-select" ]
                (List.map
                    (\repo ->
                        li []
                            [ button
                                [ onClick (RepoSelected repo) ]
                                [ text
                                    -- Strip out the repoSearch and leading /
                                    (String.slice
                                        (String.length model.repoSearch + 1)
                                        (String.length repo)
                                        repo
                                    )
                                ]
                            ]
                    )
                    model.repos
                )

        grep =
            div []
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
        if model.reposFound then
            section [ class "search-controls" ] [ repoSearch ]
        else
            section [ class "search-controls" ]
                [ repoSearch
                , div [] [ text "No repos found" ]
                ]
    else
        case model.selectedRepo of
            Just selected ->
                section [ class "search-controls" ]
                    [ repoSearch, repoSelector, grep ]

            Nothing ->
                section [ class "search-controls" ]
                    [ repoSearch, repoSelector ]
