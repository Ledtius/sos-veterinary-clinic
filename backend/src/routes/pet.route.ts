import express, { Router } from "express";
const petRouter: Router = express.Router();

import petController from "../controllers/pet.controller";

const { getAllPets, getPetById } = petController;

petRouter.get("/", getAllPets);
petRouter.get("/:id", getPetById);

export default petRouter;
