export interface DocumentTypePost {
  document_type_id: 1 | 2;
}

export interface ProfileImagePost {
  url: string;
}

export interface PersonalDataPost {
  document_type: DocumentTypePost;
  first_name: string;
  last_name: string;
  document_number: string;
  birth_date: string;
  sex: string;
  phone_number: string;
  address: string;
}

export interface OwnerPost {
  personal_data: PersonalDataPost;
  profile_image?: ProfileImagePost;
}
