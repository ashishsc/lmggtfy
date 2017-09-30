module Main exposing (..)

import Api
import Html
import Messages exposing (..)
import Types exposing (..)
import View exposing (view)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = \model -> Sub.none
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        RepoSearchUpdated search ->
            ( { model | repoSearch = search }, Cmd.none )

        SearchRepoClicked ->
            ( { model | errors = [], isLoading = True }
            , Api.findRepos model.repoSearch
            )

        ReposFetchCompleted (Ok { repos }) ->
            { model
                | reposFound = not (List.isEmpty repos)
                , repos = repos
                , isLoading = False
            }
                ! []

        ReposFetchCompleted (Err error) ->
            { model
                | errors = toString error :: model.errors
                , isLoading = False
            }
                ! []

        RepoSelected selected ->
            { model | selectedRepo = Just selected } ! []

        GrepUpdated search ->
            ( { model | grepSearch = search }, Cmd.none )

        GrepClicked ->
            case model.selectedRepo of
                Just repo ->
                    ( { model | errors = [], isLoading = True }
                    , Api.grep repo model.grepSearch
                    )

                Nothing ->
                    ( model, Cmd.none )

        GrepFetchCompleted (Ok grepResults) ->
            { model | grepResults = grepResults.results, isLoading = False } ! []

        GrepFetchCompleted (Err error) ->
            { model | errors = toString error :: model.errors, isLoading = False } ! []


init : ( Model, Cmd Msg )
init =
    ( { isLoading = False
      , repoSearch = ""
      , grepSearch = ""
      , errors = []
      , repos = []
      , selectedRepo = Nothing
      , reposFound = True
      , grepResults = []
      }
    , Cmd.none
    )
