import express from "express";
const petRouter = express.Router();

import petController from "../controllers/pet.controller";

const { getAllPets } = petController;
const petRoute = () => {
  petRouter.get("/", getAllPets);
};

petRoute();

export default petRouter;
