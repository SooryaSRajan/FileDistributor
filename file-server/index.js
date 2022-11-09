const express = require('express')
const cookieParser = require('cookie-parser')
const app = express()
const PORT = process.env.PORT || 8000

//routes import
const fileManagementRoute = require("./routes/file-management")

//middleware
app.use(express.json())
app.use(express.urlencoded({extended: true}));
app.use(cookieParser())

//routes
app.use("/files", fileManagementRoute)
app.get("/", (req, res) => {
    res.send(`Server running on port ${PORT}`)
})

//server setup
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
