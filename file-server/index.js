const express = require('express')
const cookieParser = require('cookie-parser')
const app = express()
const path = require("path")
const PORT = process.env.PORT || 8000
require('dotenv').config()

//routes import
const fileManagementRoute = require("./routes/file-management")
const loginRoute = require("./routes/authentication")

//middleware
app.use(express.json())
app.use(express.urlencoded({extended: true}));
app.use(cookieParser())
app.use('/', express.static(path.join(__dirname, 'web')))

//routes
app.use("/files", fileManagementRoute)
app.use("/auth", loginRoute)
app.get("/", (req, res) => {
    res.send(`Server running on port ${PORT}`)
})

//server setup
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
