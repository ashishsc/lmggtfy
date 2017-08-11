module Messages exposing (..)

import Http


type Msg
    = NoOp
    | SearchRepoClicked
    | ReposFetchCompleted (Result Http.Error String)
    | RepoSearchUpdated String
    | GrepClicked
    | GrepUpdated String
    | GrepFetchCompleted (Result Http.Error String)
