import express from "express";
const ownerRouter = express.Router();

import ownerController from "../controllers/owner.controller";

const { getAllOwners } = ownerController;

const ownerRoute = () => {
  ownerRouter.get("/", getAllOwners);
};

ownerRoute();

export default ownerRouter;
