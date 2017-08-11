module Main exposing (..)

import Api
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Messages exposing (..)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = \model -> Sub.none
        }


type alias Model =
    { repoSearch : String
    , grepSearch : String
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        RepoSearchUpdated search ->
            ( { model | repoSearch = search }, Cmd.none )

        SearchRepoClicked ->
            ( model, Api.findRepos model.repoSearch )

        ReposFetchCompleted (Ok repos) ->
            Debug.log ("repos " ++ repos) ( model, Cmd.none )

        ReposFetchCompleted (Err error) ->
            Debug.log (toString error) ( model, Cmd.none )

        GrepUpdated search ->
            ( { model | grepSearch = search }, Cmd.none )

        GrepClicked ->
            ( model, Api.grep model.repoSearch model.grepSearch )

        GrepFetchCompleted (Ok results) ->
            Debug.log ("grep results: " ++ results) (model ! [])

        GrepFetchCompleted (Err error) ->
            Debug.log (toString error) ( model, Cmd.none )


init : ( Model, Cmd Msg )
init =
    ( { repoSearch = "", grepSearch = "" }, Cmd.none )


view : Model -> Html Msg
view model =
    main_ []
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
            [ text "grep" ]
        ]
