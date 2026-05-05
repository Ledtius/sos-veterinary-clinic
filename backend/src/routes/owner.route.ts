import express from "express";
const ownerRouter = express.Router();

import ownerController from "../controllers/owner.controller";

const { getAllOwners } = ownerController;

const owner = () => {
  ownerRouter.get("/", getAllOwners);
};

export default ownerRouter;
