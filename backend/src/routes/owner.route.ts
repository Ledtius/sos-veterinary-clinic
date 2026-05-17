import { Router } from "express";
const ownerRouter: Router = Router();

import ownerController from "../controllers/owner.controller";

const { getAllOwners, getOwnerById, postOwner, patchOwner } = ownerController;

ownerRouter.get("/", getAllOwners);
ownerRouter.post("/", postOwner);
ownerRouter.get("/:id", getOwnerById);
ownerRouter.patch("/:id", patchOwner);
// ownerRouter.delete("/:id", deleteOwner);

export default ownerRouter;
