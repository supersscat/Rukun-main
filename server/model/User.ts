import {PrismaClient} from '@prisma/client';
import {RegisterRequest} from "~/types/AuthType";
import {Role} from "~/types/TypesModel";

const prisma = new PrismaClient();

export class User {
    static createUser = (data: any) => {
        return prisma.user.create({
            data: {
                username: data.username,
                email: data.email,
                password: data.password,
            }
        });
    };

    static registerUser = (data: RegisterRequest) => {
        return prisma.user.create({
            data: {
                username: data.username,
                email: data.email,
                password: data.password,
            },
        });
    };

    static getUserByEmail = (email: string) => {
        if (!email) {
            throw new Error("Email must be provided");
        }

        return prisma.user.findUnique({
            where: {
                email: email,
            },
            select: {
                id: true,
                username: true,
                email: true,
                password: true,
                role: true,
            },
        });
    };

    static getUserById = (id: number) => {
        return prisma.user.findUnique({
            where: { id },
            select: {
                id: true,
                username: true,
                email: true,
                password: true,
                role: true
            }
        });
    };
}