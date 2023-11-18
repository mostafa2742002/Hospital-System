const mongoose = require("mongoose");
mongoose.set('strictQuery', true);
(async() => {
  try {
     await mongoose.connect("mongodb://127.0.0.1:27017/hospital");
     console.log("Connected with mongoDB")
  } catch (err) {
    console.error(err.message);
  }
})()