//First form

interface ProfileImage {
  url: string;
}

interface Pet {
  name?: string;
  weight?: number;
  sex?: string;
  description?: string;
  profile_image?: ProfileImage;
}

let profileImg: profileImage = { url: "" };

let curentValue = "32";

const profileImgValidator = (
  proImgObj: Object,
  currentUrlImg?: string,
): string => {
  let status;
  if (proImgObj) {
    if (Object.keys(proImgObj).length) {
      const { url } = proImgObj;

      if (url.trim()) {
        if (url !== currentUrlImg) {
          status = "Valid";
        } else {
          status = "Equal";
        }
      } else {
        status = "Empty string";
      }
    } else {
      status = "Empty obj";
    }
  } else {
    status = "Undefined";
  }
  return status;
};

console.log(profileImgValidator(profileImg, curentValue));
