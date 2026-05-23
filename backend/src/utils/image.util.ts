import type { Response, Request } from "express";
import type { OwnerPost, OwnerRBPost } from "../types/owner";

import { prismaClient } from "../lib/prisma";
import type {
  owners,
  personal_data,
  pets,
  profile_images,
  staff,
} from "@prisma/client";

type PostActionImage = "NO URL VALUE" | "URL VALUE" | "EMPTY URL VALUE";

type EntityName = "Owner" | "Pet" | "Staff";

type EntityPD = owners | staff;

interface ActionImageObject {
  action: PostActionImage;
  urlValue?: string;
}

export const postPersonalData = async (
  req: Request,
  imageValue: (urlValue: string | null | undefined) => ActionImageObject,
) => {
  const ownerBodyData: OwnerRBPost = req.body;

  const { personal_data, profile_image } = ownerBodyData;

  const { url } = profile_image ?? {};

  const {
    document_type,
    first_name,
    last_name,
    document_number,
    birth_date,
    sex,
    phone_number,
    address,
  } = personal_data;

  const { document_type_id } = document_type;

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

  const imgValueObj: ActionImageObject = imageValue(url);

  return { imgValueObj, newPersonalData };
};

export const imageValue = (
  urlValue: string | null | undefined,
): ActionImageObject => {
  if (!urlValue) return { action: "NO URL VALUE" };
  else {
    if (!urlValue.trim()) return { action: "EMPTY URL VALUE" };
    else return { action: "URL VALUE", urlValue };
  }
};

export const postImage = async (
  imageValue: ActionImageObject,
  entityName: EntityName,
  newPersonalData: personal_data,
) => {
  const { action, urlValue } = imageValue;

  let switchDefault: boolean = true;

  if (action !== "URL VALUE") {
    const defaultImage = await prismaClient.profile_images.findUnique({
      where: { type: entityName, is_default: switchDefault },
    });

    postNewEntity(entityName, defaultImage as profile_images, newPersonalData);
  } else {
    const newImage = await prismaClient.profile_images.create({
      data: {
        url: urlValue as string,
        type: entityName,
        is_default: !switchDefault,
      },
    });

    postNewEntity(entityName, newImage, newPersonalData);
  }
};

const postNewEntity = async (
  entityName: EntityName,
  switchImage: profile_images,
  newPersonalData: personal_data,
) => {
  let newEntity;

  switch (entityName) {
    case "Owner":
      return (newEntity = prismaClient.owners.create({
        data: {
          personal_data_id: newPersonalData?.id,
          profile_image_id: switchImage?.id,
        },
      }));

    case "Staff":
      return (newEntity = null);
    default:
      break;
  }
};
