module Views.Setup.SearchControls exposing (searchControls)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Messages exposing (..)
import String
import Types exposing (..)


rippleButtonClass : String
rippleButtonClass =
    "mdl-button mdl-js-button mdl-button--raised mdl-js-ripple-effect"


repoSearchResults : Model -> Html Msg
repoSearchResults model =
    section [ class "search-results" ] []


repoSearch : Html Msg
repoSearch =
    div []
        [ input
            [ type_ "text"
            , class "search-box"
            , onInput RepoSearchUpdated
            , placeholder "Enter a search path"
            ]
            []
        , button
            [ class rippleButtonClass, onClick SearchRepoClicked ]
            [ text "Find Repos" ]
        ]


repoSelector : List String -> String -> Html Msg
repoSelector repos repoSearch =
    ul [ class "repo-select" ]
        (List.map
            (\repo ->
                li []
                    [ button
                        [ onClick (RepoSelected repo)
                        , class rippleButtonClass
                        ]
                        [ text
                            -- Strip out the repoSearch
                            (String.slice (String.length repoSearch) (String.length repo) repo)
                        ]
                    ]
            )
            repos
        )


grep : Html Msg
grep =
    div []
        [ input
            [ type_ "text"
            , class "search-box"
            , onInput GrepUpdated
            ]
            []
        , button
            [ class rippleButtonClass
            , onClick GrepClicked
            ]
            [ text "git grep" ]
        ]


grepResults : List String -> Html Msg
grepResults results =
    ul [ class "grep-results" ]
        (List.map (\result -> li [] [ text result ]) results)


searchControls : Model -> Html Msg
searchControls model =
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
                    [ repoSearch
                    , repoSelector model.repos model.repoSearch
                    , grep
                    , grepResults model.grepResults
                    ]

            Nothing ->
                section [ class "search-controls" ]
                    [ repoSearch, repoSelector model.repos model.repoSearch ]
