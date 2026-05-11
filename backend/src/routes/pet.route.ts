import express from "express";
const petRouter = express.Router();

import petController from "../controllers/pet.controller";

const { getAllPets, getPetById } = petController;

petRouter.get("/", getAllPets);
petRouter.get("/id", getPetById);

export default petRouter;
