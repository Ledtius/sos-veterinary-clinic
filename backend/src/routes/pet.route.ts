import express from "express";
const petRouter = express.Router();

import petController from "../controllers/pet.controller";

const { getAllPets, getPetById } = petController;
const petRoute = () => {
  petRouter.get("/", getAllPets);
  petRouter.get("/id", getPetById);
};

petRoute();

export default petRouter;
