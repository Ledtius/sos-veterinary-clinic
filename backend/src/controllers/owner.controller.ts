import type { Request, Response } from "express";
import { prismaClient } from "../lib/prisma";
import type { owners } from "@prisma/client";

const ownerController = () => {
  const getAllOwners = async (req: Request, res: Response) => {
    const data: owners[] = await prismaClient.owners.findMany();

    try {
      console.log(data);
      return res.send(data);
    } catch (e) {
      console.log(e);
      return res.status(500).json({ message: "Error fetching owners data" });
    }
  };

  return { getAllOwners };
};

export default ownerController();
