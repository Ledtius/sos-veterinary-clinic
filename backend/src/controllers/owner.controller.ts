import { prismaClient } from "../lib/prisma";

const ownerController = () => {
  let owners: any;

  const getAllOwners = async (req: any, res: any) => {
    try {
      owners = await prismaClient.owners.findMany();
      console.log(owners);

      return JSON.parse(owners);
    } catch (e) {
      res.status(500).json({ message: "Error fetching owners" });
      console.log(owners);
    }
  };

  return { getAllOwners };
};

export default ownerController();
