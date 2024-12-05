import express from "express";
import dotenv from "dotenv";
import bodyParser from "body-parser";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";
import notFoundHandler from "@/middlewares/notFoundHandler";
import errorHandler from "@/middlewares/errorHandler";
import http from "http";
import { initSocket } from "./services/socketIOClient";

dotenv.config();

const app = express();
const server = http.createServer(app);
const io = initSocket(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
  },
});
app.use(express.json());
app.use(helmet());
app.use(helmet.crossOriginResourcePolicy({ policy: "cross-origin" }));
app.use(morgan("common"));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cors());

// app.use("/api", router);

app.use("/api", notFoundHandler);

app.use("/api", errorHandler);

const PORT = process.env.PORT || 3000;

io.on("connection", (socket) => {
  socket.emit("me", socket.id);
  socket.on("disconnect", () => {
    socket.broadcast.emit("callEnded");
  });

  socket.on("callUser", ({ userToCall, signalData, from, name }) => {
    io.to(userToCall).emit("callUser", { signal: signalData, from, name });
  });

  socket.on("answerCall", (data) => {
    io.to(data.to).emit("callAccepted", data.signal);
  });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${process.env.PORT}`);
});
