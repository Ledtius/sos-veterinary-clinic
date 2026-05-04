import express from "express";
import { prismaClient } from "./lib/prisma";

const app = express();

app.get("/", async (req, res) => {
  res.send("¡API working!");
});

app.get("/pets", async (req, res) => {
  try {
    const pets = await prismaClient.pets.findMany();
    res.json(pets);
  } catch (e) {
    console.error(`DB error: ${e}`);
    res.status(500).send("DB error");
  }
});

app.listen(3000, () => {
  console.log("Server running on port http://localhost:3000");
});
