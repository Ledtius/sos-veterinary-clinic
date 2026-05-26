import type { Request, Response } from "express";
import { prismaClient } from "../lib/prisma";
import type { owners, personal_data, profile_images } from "@prisma/client";

import { getById, resById } from "../utils/idParam.util";
import { imageValue, postImage, postPersonalData } from "../utils/image.util";
import type { OwnerRBPost } from "../types/owner";

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

      const ownerActions = getById(id as string);

      const { action, entityId } = ownerActions;

      if (!entityId) return resById(res, action);

      const owner = await prismaClient.owners.findUnique({
        where: { id: entityId },
      });

      return resById(res, action, owner);
    } catch (e) {
      console.log("123");
      return res.status(500).json({ message: `Server error: ${e}` });
    }
  };

  const postOwner = async (req: Request, res: Response) => {
    try {
      const postPDResult: any = await postPersonalData(req, res, imageValue);

      const { imgValueObj, newPersonalData } = postPDResult;

      const owner = await postImage(imgValueObj, newPersonalData, "Owner", res);

      res.status(201).json({ message: "Owner created successfully", owner });

      return owner;
    } catch (e) {}
  };

  const patchOwner = async (req: Request, res: Response) => {
    try {
      const { id } = req.params;

      type personalDataEdit = {
        document_type_id?: number;
        first_name?: string;
        last_name?: string;
        document_number?: string;
        birth_date?: string | Date;
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
        const ownerActions = parseInt(id);

        if (isNaN(ownerActions)) {
          return res.status(404).json({ message: "Invalid value" });
        } else {
          const currentOwnerData = await prismaClient.owners.findUnique({
            where: { id: ownerActions },
          });

          if (!currentOwnerData) {
            return res.status(404).json({ message: "Owner not found" });
          }
          const { profile_image_id, personal_data_id, is_active } =
            currentOwnerData;

          if (personal_data) {
            if (Object.keys(personal_data).length) {
              if (personal_data.birth_date) {
                personal_data.birth_date = new Date(personal_data.birth_date);
              }

              const personalDataUpdate =
                await prismaClient.personal_data.update({
                  where: { id: personal_data_id },
                  data: { ...personal_data },
                });
              return res.status(201).json({
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
                  id: ownerActions,
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
  };

  return { getAllOwners, getOwnerById, postOwner, patchOwner };
};

export default ownerController();
