import ownerRouter from "./routes/owner.route";
import petRouter from "./routes/pet.route";
import express from "express";
const app = express();

const port: Number = 3000;

app.get("/", (req, res) => {
  res.send("Server root");
});

app.listen(port, () => {
  console.log("¡The server is open!\n");
  console.log("port: http://localhost:3000");
});

app.use("/owners", ownerRouter);
app.use("/pets", petRouter);
