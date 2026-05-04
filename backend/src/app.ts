// import express from "express";
import { prismaClient } from "./lib/prisma";

// const app = express();

// app.get("/", async (req, res) => {
//   res.send("¡API working!");
// });

// app.get("/pets", async (req, res) => {
//   try {
//     const pets = await prismaClient.pets.findMany();
//     res.json(pets);
//   } catch (e) {
//     console.error(`DB error: ${e}`);
//     res.status(500).send("DB error");
//   }
// });

// app.listen(3000, () => {
//   console.log("Server running on port http://localhost:3000");
// });

// async function main() {
//   // Fetch all pets and include their owners
//   const allPets = await prismaClient.pet.findMany({
//     include: { owner: true },
//   });
//   console.log(allPets);
// }

async function main() {
  // Replace 'owner' with an actual table name from your schema
  const allOwners = await prismaClient.owners.findMany();
  console.log("Success! Found owners:", allOwners);
}

main();
