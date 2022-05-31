const express = require("express");
const app = express();
const cors = require("cors");
const httpServer = require("http").createServer(app);
const socketIO = require("socket.io")(httpServer);
let chats = [];
app.use(cors());
socketIO.on("connection", function (client) {
    console.log("Connected...", client.id);
    socketIO.emit(chats);
    //listens for new messages coming in
    client.on("message", function name(data) {
        console.log(data);
        chats.push(data);
        socketIO.emit("message", data);
    });

    //listens when a user is disconnected from the server
    client.on("disconnect", function () {
        console.log("Disconnected...", client.id);
    });

    //listens when there's an error detected and logs the error on the console
    client.on("error", function (err) {
        console.log("Error detected", client.id);
        console.log(err);
    });
});
app.get("/chats", (req, res) => {
    res.json(chats);
});
var port = process.env.PORT || 3000;
httpServer.listen(port, function (err) {
    if (err) console.log(err);
    console.log("Listening on port", port);
});
