/**
 * The api for LMGTFY
 */
'use strict'

const express = require('express')
const { exec } = require('child_process')
const app = express()

const API_PORT = process.env.API_PORT || 3069

if (process.env.NODE_ENV !== 'production') {
    app.use((req, res, next) => {
        // TODO Should this only allow access to specific ports? What about a docker container?
        res.header('Access-Control-Allow-Origin', '*')
        res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept')
        next()
    })
}
app.get('/repos/:dir', (req, res) => {
    exec(`find ${req.params.dir} -name .git -type d -prune`,
        (error, repos, stderr) => {
            if (error || stderr) {
                res.status(400).send(error || stderr)
            } else {
                res.json({
                    dir: req.params.dir,
                    repos: repos.split('\n')
                        // eliminate the last empty string because find
                        // terminates with a new line
                        .filter(str => str.length > 0)
                        // Strip of the .git
                        .map(str => str.substr(0, str.length - 5))
                })
            }
        }
    )
})

app.get('/grep/:repo/:search', (req, res) => {
    exec(`git grep ${req.params.search}`, { cwd: req.params.repo },
        (error, results, stderr) => {
            console.log({ error, results, stderr })
            if (error || stderr) {
                console.error('error ', error);
                console.error('stderr', stderr);
                res.status(400).send(error || stderr)
            } else {
                res.json({
                    repo: req.params.repo,
                    search: req.params.search,
                    results: results.split('\n'),
                })
            }
        }
    )
})


app.listen(API_PORT, () => console.log(`server listening at ${API_PORT}`))
