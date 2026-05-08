import type { Request, Response } from "express";
import { prismaClient } from "../lib/prisma";
import type { owners } from "@prisma/client";

const ownerController = () => {
  const getAllOwners = async (req: Request, res: Response) => {
    try {
      const data: owners[] = await prismaClient.owners.findMany();

      return res.json(data);
    } catch (e) {
      return res
        .status(500)
        .json({ message: "Error fetching getAllOwners data" });
    }
  };

  const getOwnerById = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;
      const ownerId = parseInt(id);

      if (isNaN(ownerId)) {
        return res.status(400).json({ message: "Invalid ID format" });
      }

      const data = await prismaClient.owners.findUnique({
        where: { id: ownerId },
      });
      console.log(data);
      if (!data) {
        return res.status(404).json({ message: "Owner not found" });
      }

      return res.json(data);
    } catch (e) {
      return res
        .status(500)
        .json({ message: "Error fetching getOwnerById data" });
    }
  };

  return { getAllOwners, getOwnerById };
};

export default ownerController();
