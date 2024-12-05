import { Server, ServerOptions } from "socket.io";

let io: Server | null = null;

export const initSocket = (
  server: any,
  options: Partial<ServerOptions>
): Server => {
  io = new Server(server, options);
  console.log("Socket.io initialized");
  return io;
};

export const getSocketInstance = (): Server => {
  if (!io) {
    throw new Error("Socket.io instance has not been initialized!");
  }
  return io;
};
