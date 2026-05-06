import express, { type Request, type Response } from "express";
import { prismaClient } from "../lib/prisma";
import type { pets } from "@prisma/client";

const petController = () => {
  const getAllPets = async (req: Request, res: Response) => {
    try {
      const data: pets[] = await prismaClient.pets.findMany();

      return res.send(data);
    } catch (e) {
      return res.status(500).json({ message: "Error fetching pets data" });
    }
  };

  return { getAllPets };
};

export default petController();
