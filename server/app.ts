/**
 * The api for LMGTFY
 */
'use strict'

const express = require('express');
const app = express()
import { exec } from 'child_process';

const API_PORT = process.env.API_PORT || 3069

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
