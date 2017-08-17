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
            ( { model | errors = [] }
            , Api.findRepos model.repoSearch
            )

        ReposFetchCompleted (Ok { repos }) ->
            { model
                | reposFound = not (List.isEmpty repos)
                , repos = repos
            }
                ! []

        ReposFetchCompleted (Err error) ->
            { model | errors = toString error :: model.errors } ! []

        RepoSelected selected ->
            { model | selectedRepo = Just selected } ! []

        GrepUpdated search ->
            ( { model | grepSearch = search }, Cmd.none )

        GrepClicked ->
            ( { model | errors = [] }
            , Api.grep model.repoSearch model.grepSearch
            )

        GrepFetchCompleted (Ok grepResults) ->
            { model | grepResults = grepResults.results } ! []

        GrepFetchCompleted (Err error) ->
            { model | errors = toString error :: model.errors } ! []


init : ( Model, Cmd Msg )
init =
    ( { repoSearch = ""
      , grepSearch = ""
      , errors = []
      , repos = []
      , selectedRepo = Nothing
      , reposFound = True
      , grepResults = []
      }
    , Cmd.none
    )
