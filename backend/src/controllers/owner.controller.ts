import type { Request, Response } from "express";
import { prismaClient } from "../lib/prisma";
import type { owners, personal_data, profile_images } from "@prisma/client";

const ownerController = () => {
  const getAllOwners = async (req: Request, res: Response) => {
    try {
      const owners: owners[] = await prismaClient.owners.findMany();

      return res.json(owners);
    } catch (e) {
      return res.status(500).json({ message: "Error fetching owners" });
    }
  };

  const getOwnerById = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;

      if (!id) {
        return res.status(400).json({ message: "ID is missing" });
      }

      if (typeof id === "string") {
        const ownerId = parseInt(id);

        if (isNaN(ownerId)) {
          return res.status(400).json({ message: "Invalid ID format" });
        }

        const owner = await prismaClient.owners.findUnique({
          where: { id: ownerId },
        });

        console.log(owner);

        if (!owner) {
          return res.status(404).json({ message: "Owner not found" });
        }
        return res.json(owner);
      }
    } catch (e) {
      return res
        .status(500)
        .json({ message: "Error fetching getOwnerById data" });
    }
  };

  const postOwner = async (req: Request, res: Response) => {
    try {
      const {
        document_type_id,
        first_name,
        last_name,
        document_number,
        birth_date,
        sex,
        phone_number,
        address,
        url,
      } = req.body;

      const newPersonalData: personal_data =
        await prismaClient.personal_data.create({
          data: {
            document_type_id,
            first_name,
            last_name,
            document_number,
            birth_date: new Date(birth_date),
            sex,
            phone_number,
            address,
          },
        });

      let newOwner: owners;

      if (url) {
        const newProfileImage: profile_images =
          await prismaClient.profile_images.create({
            data: {
              url: url,
              type: "Owner",
              is_default: false,
            },
          });

        newOwner = await prismaClient.owners.create({
          data: {
            personal_data_id: newPersonalData.id,
            profile_image_id: newProfileImage.id,
            is_active: true,
          },
        });
      } else {
        const profileImage = await prismaClient.profile_images.findUnique({
          where: {
            type: "Owner",
          },
        });

        newOwner = await prismaClient.owners.create({
          data: {
            personal_data_id: newPersonalData.id,
            profile_image_id: profileImage?.id ?? 2,
            is_active: true,
          },
        });
      }
      return res
        .status(201)
        .json({ message: "Owner created successfully", data: newOwner });
    } catch (e) {
      return res.status(500).json({ message: `Error creating owner ${e}` });
    }
  };

  return { getAllOwners, getOwnerById, postOwner };
};

export default ownerController();
