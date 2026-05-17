import express, { type Request, type Response } from "express";
import { prismaClient } from "../lib/prisma";
import type { pets } from "@prisma/client";

const petController = () => {
  const getAllPets = async (req: Request, res: Response) => {
    try {
      const pets = await prismaClient.pets.findMany();
      res.status(201).json({ message: "Get pets successfully", pets });
    } catch (e) {
      res.status(500).json({ message: "Error get all pets", e });
    }
  };

  const getPetById = async (req: Request, res: Response) => {
    const { id } = req.params;

    if (typeof id === "string") {
      const idUrlInt = parseInt(id);

      if (isNaN(idUrlInt)) {
        return res.status(404).json({ message: "Invalid value" });
      }

      const pet = await prismaClient.pets.findUnique({
        where: { id: idUrlInt },
      });

      res.status(201).json({ message: "Get pet successfully", pet });
    }
  };

  return { getAllPets, getPetById };
};

export default petController();
