import type { ProfileImageEdit } from "./profileImage";

export type OwnerEdit = {
  document_type_id: number;
  first_name: string;
  last_name: string;
  document_number: string;
  birth_date: string;
  sex: string;
  phone_number: string;
  address: string;
  profile_image: ProfileImageEdit;
};
