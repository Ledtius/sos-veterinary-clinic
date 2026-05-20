//First form
import type { ProfileImage } from "../types/pet";

let profileImg: ProfileImage = { url: "32" };

let currentValue = "32";
import { prismaClient } from "../lib/prisma";
import type { owners, pets } from "@prisma/client";

const profileImgValidator = async (
  proImgObj: ProfileImage,
  currentUrlImg?: string,
  entity: string,
  urlId: number,
) => {
  let status;
  if (proImgObj) {
    if (Object.keys(proImgObj).length) {
      const { url } = proImgObj;

      if (url.trim()) {
        if (url !== currentUrlImg) {
          status = "Valid";

          if (entity === "pet") {
            // const entityUpdateImg = prismaClient.pets.update({where: {
            //   id : urlId
            // }});
          }
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

// console.log(profileImgValidator(profileImg, currentValue));

// switch (profileImgValidator(profileImg, currentValue)) {
//   case "Valid":
//     console.log("Valid value");
//     break;
//   case "Empty string":
//     console.log("Empty string");
//     break;
//   case "Empty obj":
//     console.log("Empty obj");
//     break;
//   case "Undefined":
//     console.log("Undefined");
//     break;
//   default:
//     console.log("Undefined");
//     break;
