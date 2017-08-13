module Messages exposing (..)

import Http
import Types exposing (..)


type Msg
    = NoOp
    | SearchRepoClicked
    | ReposFetchCompleted (Result Http.Error RepoSearchResult)
    | RepoSearchUpdated String
    | GrepClicked
    | GrepUpdated String
    | GrepFetchCompleted (Result Http.Error GrepResult)
