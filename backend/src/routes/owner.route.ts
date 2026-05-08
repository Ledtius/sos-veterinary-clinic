import express from "express";
const ownerRouter = express.Router();

import ownerController from "../controllers/owner.controller";

const { getAllOwners, getOwnerById } = ownerController;

const ownerRoute = () => {
  ownerRouter.get("/", getAllOwners);
  ownerRouter.get("/:id", getOwnerById);
  return ownerRoute;
};

ownerRoute();

export default ownerRouter;
