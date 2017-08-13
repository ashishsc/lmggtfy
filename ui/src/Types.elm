module Types exposing (..)


type alias Model =
    { repoSearch : String
    , repos : List String
    , selectedRepo : Maybe String
    , grepSearch : String
    , grepResults : List String
    , errors : List String
    }


type alias RepoSearchResult =
    { dir : String
    , repos : List String
    }


type alias GrepResult =
    { repo : String
    , search : String
    , results : List String
    }
