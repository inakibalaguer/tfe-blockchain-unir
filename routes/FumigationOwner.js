// Importing express module
const express=require("express");
const path = require('path');
const router=express.Router()
  
// Handling request using router
router.get("/",(req,res,next)=>{
  console.log("Fumigation Owner web3");
  res.sendFile(path.join(__dirname, '../web/FumigationOwner.html'));
})
  
// Importing the router
module.exports=router