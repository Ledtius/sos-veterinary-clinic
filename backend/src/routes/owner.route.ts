import { Router } from "express";
const ownerRouter: Router = Router();

import ownerController from "../controllers/owner.controller";

const { getAllOwners, getOwnerById, postOwner, patchOwner } = ownerController;

ownerRouter.get("/", getAllOwners);
ownerRouter.get("/:id", getOwnerById);
ownerRouter.post("/", postOwner);
ownerRouter.patch("/:id", patchOwner);

export default ownerRouter;
