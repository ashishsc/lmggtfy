/**
 * The api for LMGTFY
 */
'use strict'

const express = require('express')
const app = express()

const API_PORT = process.env.API_PORT || 3069
app.listen(API_PORT, () => console.log(`server listening at ${API_PORT}`))
