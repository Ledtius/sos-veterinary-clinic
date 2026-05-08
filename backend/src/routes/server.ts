import ownerRouter from "./owner.route";
import petRouter from "./pet.route";
import express from "express";
const app = express();

const server = () => {
  const port: Number = 3000;

  app.get("/", (req, res) => {
    res.send("Main router message!");
  });

  app.listen(port, () => {
    console.log("Console message! - Server opens!");
    console.log(`http://localhost:3000`);
  });

  app.use("/owners", ownerRouter);
  app.use("/pets", petRouter);
};

export default server;
