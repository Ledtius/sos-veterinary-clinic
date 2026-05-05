import ownerRouter from "./owner.route";
import express from "express";
const app = express();

const main = () => {
  const port: Number = 3000;

  app.get("/", (req, res) => {
    res.send("Hello word!");
  });

  app.listen(port, () => {
    console.log(`¡Server opened! ❤`);

    console.log(`http://localhost:3000`);
  });

  app.use("/owners", ownerRouter);
};

export default main;
