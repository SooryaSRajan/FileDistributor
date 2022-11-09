const express = require('express')
const router = express.Router()
const multer = require('multer');
const path = require('path');
const fs = require('fs');

const filePath = path.join(__dirname, '../files');
console.log(filePath);

const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        console.log('destination ' + file);
        cb(null, filePath);
    },
    filename: function (req, file, cb) {
        let fileNames = file.originalname.split('.');
        let fileName = fileNames[0] + '-' + Date.now() + '.' + fileNames[1];
        console.log('filename ' + fileName);
        cb(null, fileName);
    }
});

const upload = multer({
    storage: storage,
    onFileUploadStart: function (file) {
        console.log(file.originalname + ' is starting ...')
    },
});

// Get all files
router.get('/getFiles', (req, res) => {
    fs.readdir(filePath, function (err, files) {
        if (err) {
            console.log("ERROR: ", err);
            res.header("Access-Control-Allow-Origin", "*");
            res.header("Access-Control-Allow-Methods", "GET,PUT,PATCH,POST,DELETE");
            res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");          
            return res.status(400).send({
                message: "Error occurred",
                error: err
            });
        } 
        let fileInfos = [];
        files.forEach(function (file) {
            fileInfos.push(file);
        });
        res.header("Access-Control-Allow-Origin", "*");
        res.header("Access-Control-Allow-Methods", "GET,PUT,PATCH,POST,DELETE");
        res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");      
        res.status(200).send({
            message: "Files retrieved successfully",
            files: fileInfos
        });
    });
})

// Upload a file
router.post('/uploadFile', (req, res) => {
    //upload single called file
    //check if file exists
    console.log("UPLOAD")
    upload.single('file')(req, res, function (err) {
        if (err) {
            console.log("ERROR: ", err);
            res.header("Access-Control-Allow-Origin", "*");
            res.header("Access-Control-Allow-Methods", "GET,PUT,PATCH,POST,DELETE");
            res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");          
            return res.status(400).send({
                message: "Error occurred",
                error: err
            });
        }
        res.header("Access-Control-Allow-Origin", "*");
        res.header("Access-Control-Allow-Methods", "GET,PUT,PATCH,POST,DELETE");
        res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");      
        res.status(200).send({
            message: "File uploaded successfully",
        });
    });
})

// Delete a file
router.delete('/deleteFile/:fileName', (req, res) => {
    let fileName = req.params.fileName;
    fs.unlink(path.join(filePath, fileName), function (err) {
        if (err) {
            console.log("ERROR: ", err);
            res.header("Access-Control-Allow-Origin", "*");
            res.header("Access-Control-Allow-Methods", "GET,PUT,PATCH,POST,DELETE");
            res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");          
            return res.status(500).send({
                message: "Error occurred",
                error: err
            });
        }
        res.header("Access-Control-Allow-Origin", "*");
        res.header("Access-Control-Allow-Methods", "GET,PUT,PATCH,POST,DELETE");
        res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
        console.log("DELETED FILE")
        res.send({
            message: "File deleted successfully"
        });
});
})

//read a file
router.get('/downloadFile/:fileName', (req, res) => {
    let fileName = req.params.fileName;
    console.log("DOWNLOAD: ", fileName);
    try{
        res.header("Access-Control-Allow-Origin", "*");
        res.header("Access-Control-Allow-Methods", "GET,PUT,PATCH,POST,DELETE");
        res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
        return res.download(path.join(filePath, fileName), fileName);
    }
    catch(err){
        console.log("ERROR: ", err);
        res.header("Access-Control-Allow-Origin", "*");
        res.header("Access-Control-Allow-Methods", "GET,PUT,PATCH,POST,DELETE");
        res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
        return res.status(500).send({
            message: "Error occurred",
            error: err
        });
    }
})

module.exports = router;