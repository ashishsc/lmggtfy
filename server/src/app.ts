/**
 * The api for LMGTFY
 */
"use strict"

const express = require("express")
const { exec } = require("child_process")
const app = express()

const API_PORT = process.env.API_PORT || 3069

if (process.env.NODE_ENV !== "production") {
    app.use((req, res, next) => {
        // TODO Should this only allow access to specific ports? What about a docker container?
        res.header("Access-Control-Allow-Origin", "*")
        res.header(
            "Access-Control-Allow-Headers",
            "Origin, X-Requested-With, Content-Type, Accept"
        )
        next()
    })
}
app.get("/repos/:dir", (req, res) => {
    const dir = req.params.dir.endsWith("/")
        ? req.params.dir
        : req.params.dir + "/"
    exec(
        `find ${dir} -name .git -type d -prune`,
        (error: Error, repos: string, stderr: string) => {
            res.json({
                // permission denied or other errors may occur
                errors: [error, stderr],
                dir,
                repos: repos
                    .split("\n")
                    // eliminate the last empty string because find
                    // terminates with a new line
                    .filter(str => str.length > 0)
                    // supress Permission denied
                    .filter(str => !str.endsWith(": Permission denied"))
                    // Strip of the .git
                    .map(str => str.substr(0, str.length - 5))
            })
        }
    )
})

app.get("/grep/:repo/:search", (req, res) => {
    exec(
        `git grep -n ${req.params.search}`,
        { cwd: req.params.repo },
        (error, results, stderr) => {
            res.json({
                errors: [error, stderr],
                repo: req.params.repo,
                search: req.params.search,
                results: results.split("\n").filter(str => str.length > 0)
            })
        }
    )
})

app.listen(API_PORT, () => console.log(`server listening at ${API_PORT}`))
