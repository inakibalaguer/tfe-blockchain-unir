const express = require('express');
const path = require('path');

const app = express();
const port = process.env.PORT || 8080;

const fumigationRoute = require("./routes/Fumigation.js");
const fumigationCompanyRoute = require("./routes/FumigationCompany.js");
const fumigationOwnerRoute = require("./routes/FumigationOwner.js");
  
// Handling routes request
app.use("/main", fumigationRoute);
app.use("/company", fumigationCompanyRoute);
app.use("/owner", fumigationOwnerRoute);
app.use('/img', express.static(__dirname + '/web/img'));
app.listen((port),()=>{
    console.log("Server is Running");
});