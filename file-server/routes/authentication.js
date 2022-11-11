const express = require("express")
const router = express.Router()
const jwt = require('jsonwebtoken');

router.post('/login', (req, res) => {
    const password = req.body.password
    if (!password) return res.status(400).send({
        message: "Please include password"
    });
    if (password === process.env.PASSWORD) {
        //auth successful
        const token = jwt.sign({verification: process.env.JWT_VERIFICATION}, process.env.JWT_KEY, null, null);

        return res.status(200).send({
            message: "Authentication Success",
            token: token
        })
    } else {
        return res.status(412).send({
            message: "Incorrect Password"
        })
    }
})

module.exports = router