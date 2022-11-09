/*
app.post('/auth/login', (req,res)=>{
//get username from request's body, eg. from login form
    let username = req.body.username
/*
check username and password correctness here,
if they matched then:
/*
//create jwt token
const token = jwt.sign({user:username},'secret_key')
//save token in cookie
res.cookie('authcookie',token,{maxAge:900000,httpOnly:true})
})
 */