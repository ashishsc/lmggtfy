module Api exposing (..)

import Http
import Json.Decode as Decode
import Messages exposing (Msg(..))
import Task exposing (..)


apiUrl : String
apiUrl =
    "localhost:3069"



{-
   Find all git repos within a given directory
-}


findRepos : String -> Cmd Msg
findRepos dir =
    let
        reposUrl =
            apiUrl ++ "/repos/" ++ dir
    in
    Http.send ReposFetchCompleted <| Http.getString reposUrl
