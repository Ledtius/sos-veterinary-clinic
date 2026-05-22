import type { owners, pets, staff } from "@prisma/client";
import type { Response } from "express";

type Actions = "UNDEFINED/NULL" | "INVALID FORMAT" | "VALID";

export interface GetActions {
  action: Actions;
  entityId?: number;
}

export const getById = (id: string): GetActions => {
  if (!id) return { action: "UNDEFINED/NULL" };

  const intId = parseInt(id);

  if (isNaN(intId)) return { action: "INVALID FORMAT" };

  return { action: "VALID", entityId: intId };
};

export const resById = async (
  res: Response,
  action: Actions,
  entity?: owners | pets | staff | undefined | null,
) => {
  if (action === "UNDEFINED/NULL")
    return res.status(400).json({ message: `${action} ID` });

  if (action === "INVALID FORMAT") {
    return res.status(404).json({ message: `${action} ID` });
  }

  if (action === "VALID") {
    if (!entity)
      return res.status(404).json({ message: `THIS ELEMENT DOESN'T EXIST` });
    else return res.status(201).json({ message: `GET SUCCESSFULLY`, entity });
  }
};
