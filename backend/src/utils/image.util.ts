import type { Response } from "express";

type PostActionImage = "NO URL VALUE" | "URL VALUE" | "EMPTY URL VALUE";

interface PostActionImageObject {
  action: PostActionImage;
  urlValue?: string;
}

export const imageValue = (
  urlValue: string | null | undefined,
): PostActionImageObject => {
  if (!urlValue) return { action: "NO URL VALUE" };
  else {
    if (!urlValue.trim()) return { action: "EMPTY URL VALUE" };
    else return { action: "URL VALUE", urlValue };
  }
};

export const postImage = (res: Response, imageValue: PostActionImageObject) => {
  const { action, urlValue } = imageValue;
};
