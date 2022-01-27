import { PrismaClient } from '@prisma/client'
import argon2 from "argon2";
const prisma = new PrismaClient()

async function main() {
    const user = await prisma.user.upsert({
        where: { email: "user@test.com"},
        update: {},
        create: {
            email: "user@test.com",
            password: await argon2.hash("user", { type: argon2.argon2id }),
            firstName: "Bob",
            lastName: "Mustermann"
        },
    });

    const restaurant = await prisma.restaurant.create({
        data: {
            name: "Test Restaurant",
            description: 'Test restaurant',
            zipCode: '12345',
            city: 'Aalen',
            address: 'Hs aalen str.'
        },
    });

    const admin = await prisma.user.upsert({
        where: { email: "admin@test.com"},
        update: {},
        create: {
            email: "admin@test.com",
            password: await argon2.hash("admin", { type: argon2.argon2id }),
            firstName: "Alice",
            lastName: "Mustermann",
            rolesInRestaurants: {
                create: {
                    restaurantId: restaurant.id,
                    role: "ADMIN"
                }
            }
        },
    });

    const table = await prisma.table.create({
        data: {
            name: "11R",
            restaurantId: restaurant.id,
        }
    });

    const menuItems = await  prisma.menuItem.createMany({
        data: [
            {
                type: "FOOD",
                name: "Falafeltasche",
                price: 5,
                description: "Leckere Falafeltasche mit Salat und Knoblauchsauce",
                available: true,
                restaurantId: restaurant.id
            },
            {
                type: "FOOD",
                name: "Pizza Hawaii",
                price: 5,
                description: "Ananas gehört (!) auf Pizza.",
                available: true,
                restaurantId: restaurant.id
            },
            {
                type: "DRINK",
                name: "Cola",
                price: 3,
                description: "Es blubbert auf der Zunge",
                available: true,
                restaurantId: restaurant.id
            }
        ]
    });
}

main()
  .catch((e) => {
    console.error(e)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
  })