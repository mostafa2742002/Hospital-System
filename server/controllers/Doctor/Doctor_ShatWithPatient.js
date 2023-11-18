// const sendResponse = require("../../utils/sendResonse");
// const { io } = require("../../app");

// const DoctorShatWithPatient = async (req, res) => {
//   try {
//     // now we want to communicate with the patient with socket.io and we want to render the index.html page in the client side

//     res.sendFile(__dirname + "/index.html");

//     // now we want to listen to the message that the patient will send to the doctor
//     io.on("connection", (socket) => {
//       console.log("a user connected");
//       socket.on("chat message", (msg) => {
//         io.emit("chat message", msg);
//       });
//     });
    
//   } catch (err) {
//     console.log(err);
//     return sendResponse(res, 500, "Internal Server Error");
//   }
// };

// module.exports = { DoctorShatWithPatient };
