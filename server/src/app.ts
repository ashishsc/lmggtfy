/**
 * The api for LMGTFY
 */
'use strict'

const express = require('express')
const app = express()
const { exec } = require('child_process')

const API_PORT = process.env.API_PORT || 3069

if (process.env.NODE_ENV !== 'production') {
    app.use((req, res, next) => {
        console.log("got here")
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
                res.json({ dir: req.params.dir, repos })
            }
        }
    )
})

app.get('/repos/:dir/:search', (req, res) => {
    exec(`git grep ${req.params.search}`, { cwd: req.params.dir },
        (error, results, stderr) => {
            if (error || stderr) {
                res.status(400).send(error || stderr)
            } else {
                res.json({
                    dir: req.params.dir,
                    search: req.params.search,
                    results,
                })
            }
        }
    )
})


app.listen(API_PORT, () => console.log(`server listening at ${API_PORT}`))
