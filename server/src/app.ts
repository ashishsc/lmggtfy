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
                    repos: repos.split('\n').map(
                        // Strip off the .git
                        str => str.substr(0, str.length - 5)
                            // TODO find out why
                            .filter(str => str.length > 0)
                    )
                })
            }
        }
    )
})

app.get('/grep/:repo/:search', (req, res) => {
    console.log('got here:', req.params)
    exec(`git grep ${req.params.search}`, { cwd: req.params.repo },
        (error, results, stderr) => {
            if (error || stderr) {
                res.status(400).send(error || stderr)
            } else {
                res.json({
                    repo: req.params.repo,
                    search: req.params.search,
                    results,
                })
            }
        }
    )
})


app.listen(API_PORT, () => console.log(`server listening at ${API_PORT}`))
