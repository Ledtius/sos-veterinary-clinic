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
      } else {
      }
    } catch (e) {
      return res.status(500).json({ message: `Server error: ${e}` });
    }
  };

  const postOwner = async (req: Request, res: Response) => {
    try {
      type profileImagePost = {
        url?: string;
      };

      type ownerPost = {
        document_type_id: number;
        first_name: string;
        last_name: string;
        document_number: string;
        birth_date: string;
        sex: string;
        phone_number: string;
        address: string;
        profile_image: profileImagePost;
      };

      const ownerData: ownerPost = req.body;

      const {
        document_type_id,
        first_name,
        last_name,
        document_number,
        birth_date,
        sex,
        phone_number,
        address,
        profile_image,
      } = ownerData;

      const { url } = profile_image;
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

  const patchOwner = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;

      type personalDataEdit = {
        document_type_id?: number;
        first_name?: string;
        last_name?: string;
        document_number?: string;
        birth_date?: string;
        sex?: string;
        phone_number?: string;
        address?: string;
      };

      type profileImageEdit = {
        url?: string;
      };

      type ownerEdit = {
        personal_data?: personalDataEdit;
        profile_image?: profileImageEdit;
        is_active?: boolean;
      };

      const ownerData: ownerEdit = req.body;

      const {
        personal_data,
        profile_image,
        is_active: is_active_current,
      } = ownerData;

      if (typeof id === "string") {
        const ownerId = parseInt(id);

        if (isNaN(ownerId)) {
          return res.status(404).json({ message: "Invalid value" });
        } else {
          const currentOwnerData = await prismaClient.owners.findUnique({
            where: { id: ownerId },
          });

          if (!currentOwnerData) {
            return res.status(404).json({ message: "Owner not found" });
          }
          const { profile_image_id, personal_data_id, is_active } =
            currentOwnerData;

          if (personal_data) {
            if (Object.keys(personal_data).length) {
              const personalDataUpdate =
                await prismaClient.personal_data.update({
                  where: { id: personal_data_id },
                  data: { ...personal_data },
                });
              res.status(201).json({
                message: "Personal data updated successfully",
                personalDataUpdate,
              });
            }
          }

          if (profile_image) {
            if (Object.keys(profile_image).length) {
              if (profile_image_id) {
                const profileImageUpdate =
                  await prismaClient.profile_images.update({
                    where: { id: profile_image_id },
                    data: { ...profile_image },
                  });

                return res.status(201).json({
                  message: "Profile updated successfully",
                  profileImageUpdate,
                });
              }
            }
          }

          if (is_active_current === true || is_active_current === false) {
            if (is_active !== is_active_current) {
              const isActiveUpdate = await prismaClient.owners.update({
                where: {
                  id: ownerId,
                },
                data: {
                  is_active: is_active_current,
                },
              });

              return res.status(201).json({
                message: "Profile state updated successfully",
                isActiveUpdate,
              });
            }
          }
        }
      }
    } catch (e) {
      res.status(500).json({ message: `Server error: ${e}` });
    }

    // const dataToUpdate = req.body;

    // const { personal_data_id, profile_image_id } = dataToUpdate;

    const owner: owners = await prismaClient.owners.update({
      where: { id: Number(id) },
      data: dataToUpdate,
    });
  };

  return { getAllOwners, getOwnerById, postOwner, patchOwner };
};

export default ownerController();
