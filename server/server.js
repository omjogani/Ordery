const { response } = require("express");
const express = require("express");
const app = express();

const admin = require("firebase-admin");
const credentials = require("./key.json");

admin.initializeApp({
    credential:admin.credential.cert(credentials)
});

app.use(express.json());
app.use(express.urlencoded({extended : true}));
const db = admin.firestore();

app.get('/orders',async (req,res)=>
{
    try{
        
        const userRef = db.collection("orders");
        const response = await userRef.get();
        let responseArr=[];
        response.forEach(doc=>{
            if(doc.data().isPending)
                responseArr.push(doc.data());
        });
        res.send(responseArr);
    }
    catch(error){
        res.send(error);
    }
});



app.post('/orderUpdate',async (req,res)=>
{
    try{
        const id=req.body.id;
        
        const userRef = db.collection("orders").doc(id).update({
            isPending:false
        });
        const response = await userRef.get();
        res.send(response);
      
    }
    catch(error){
        res.send(error)
    }
})

const PORT = process.env.PORT || 8080
app.listen(PORT,()=>
{
    console.log(`server is running on port ${PORT}`);
})
