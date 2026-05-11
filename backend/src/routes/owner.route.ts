import { Router } from "express";
const ownerRouter = Router();

import ownerController from "../controllers/owner.controller";

const { getAllOwners, getOwnerById, postOwner } = ownerController;

ownerRouter.get("/", getAllOwners);
ownerRouter.get("/:id", getOwnerById);
ownerRouter.post("/", postOwner);

export default ownerRouter;
