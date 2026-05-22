import express, { type Request, type Response } from "express";
import { prismaClient } from "../lib/prisma";
import type { PetEdit } from "../types/pet";
import { getById, resById, type GetActions } from "../utils/idParam.util";
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

    const petActions: GetActions = getById(id as string);

    const { action, entityId } = petActions;

    if (!entityId) return resById(res, action);

    const pet = await prismaClient.pets.findUnique({
      where: {
        id: entityId,
      },
    });

    return resById(res, action, pet);
  };

  const patchPet = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;

      if (typeof id === "string") {
        const petId = parseInt(id);

        if (isNaN(petId)) {
          return res.status(404).json({ message: "Invalid value" });
        }

        const petEdit: PetEdit = req.body;

        if (Object.keys(petEdit).length) {
          const petPatch = prismaClient.pets.update({
            where: {
              id: petId,
            },
            data: {
              ...petEdit,
            },
          });
        }
      }
    } catch (e) {
      return res.status(500).json({ message: "Error in the server", e });
    }
  };

  return { getAllPets, getPetById };
};

export default petController();
