module Messages exposing (..)

import Http


type Msg
    = NoOp
    | SearchRepoClicked
    | ReposFetchCompleted (Result Http.Error String)
    | RepoSearchUpdated String
