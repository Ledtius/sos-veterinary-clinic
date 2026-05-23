/* RB = Response Body */
export interface DocumentTypeRBPost {
  document_type_id: 1 | 2;
}

export interface ProfileImageRBPost {
  url: string;
}

export interface PersonalDataRBPost {
  document_type: DocumentTypeRBPost;
  first_name: string;
  last_name: string;
  document_number: string;
  birth_date: string;
  sex: string;
  phone_number: string;
  address: string;
}

export interface OwnerRBPost {
  personal_data: PersonalDataRBPost;
  profile_image?: ProfileImageRBPost;
}

export interface OwnerPost {
  personal_data_id: number;
  profile_image_id? : number;
}
