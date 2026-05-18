export interface ProfileImage {
  url: string;
}

export interface Pet {
  name?: string;
  weight?: number;
  sex?: string;
  description?: string;
  profile_image?: ProfileImage;
}
