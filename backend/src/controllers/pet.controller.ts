import express, { type Request, type Response } from "express";
import { prismaClient } from "../lib/prisma";
import type { pets } from "@prisma/client";
import profile_images from "@prisma/client";

import { ProfileImage, Pet } from "../types/pet";

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

  const patchPet = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;

      if (typeof id === "string") {
        const petId = parseInt(id);

        if (isNaN(petId)) {
          return res.status(404).json({ message: "Invalid value" });
        }
        type profile_image = {
          url: string;
        };

        type pet = {
          name?: string;
          weight?: number;
          sex?: string;
          description?: string;
          profile_image?: profile_image;
        };

        const petEdit: pet = req.body;
        const { profile_image } = petEdit;

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
