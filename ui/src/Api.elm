module Api exposing (..)

import Http
import Json.Decode as Decode
import Messages exposing (Msg(..))
import Task exposing (..)
import Types exposing (..)


apiUrl : String
apiUrl =
    "http://localhost:3069"


{-| Find all git repos within a given directory
-}
findRepos : String -> Cmd Msg
findRepos dir =
    let
        reposUrl =
            apiUrl ++ "/repos/" ++ Http.encodeUri dir
    in
    Http.get reposUrl repoSearchDecoder
        |> Http.send ReposFetchCompleted


grep : String -> String -> Cmd Msg
grep repo search =
    let
        grepUrl =
            apiUrl ++ "/repos/" ++ repo ++ "/" ++ search
    in
    Http.get grepUrl grepResultDecoder
        |> Http.send GrepFetchCompleted


repoSearchDecoder : Decode.Decoder RepoSearchResult
repoSearchDecoder =
    Decode.map2
        RepoSearchResult
        (Decode.field "dir" Decode.string)
        (Decode.field "repos" (Decode.list Decode.string))


grepResultDecoder : Decode.Decoder GrepResult
grepResultDecoder =
    Decode.map3
        GrepResult
        (Decode.field "repo" Decode.string)
        (Decode.field "search" Decode.string)
        (Decode.field "results" (Decode.list Decode.string))
