import "dotenv/config";
import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient } from "@prisma/client";
import PG from "pg";

const pool = new PG.Pool({ connectionString: process.env.DATABASE_URL });

const adapter = new PrismaPg(pool);

export const prismaClient = new PrismaClient({ adapter });
