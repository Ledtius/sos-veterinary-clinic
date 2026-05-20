import type { ProfileImageEdit } from "./profileImage";

export interface PetEdit {
  name?: string;
  weight?: number;
  sex?: string;
  description?: string;
  profile_image?: ProfileImageEdit;
}
