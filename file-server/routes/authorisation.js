const jwt = require('jsonwebtoken');

module.exports = function (req, res, next) {
    const token = req.header("auth-token")
    console.log(token)
    if (!token) return res.status(400).send({message: "Please attach JWT"})
    jwt.verify(token, process.env.JWT_KEY, function (err, data) {
        console.log(err)
        if (err) {
            res.status(412).send({message: "Verification failed"})
        } else {
            if (data.verification === process.env.JWT_VERIFICATION) {
                next()
            } else {
                res.status(412).send({message: "Verification failed"})
            }
        }
    }, null);

}