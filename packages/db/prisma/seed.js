const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Seeding database...');

  // Create Years
  const year2024 = await prisma.year.upsert({
    where: { year: 2024 },
    update: {},
    create: { year: 2024 },
  });

  const year2023 = await prisma.year.upsert({
    where: { year: 2023 },
    update: {},
    create: { year: 2023 },
  });

  const year2021 = await prisma.year.upsert({
    where: { year: 2021 },
    update: {},
    create: { year: 2021 },
  });

  // Create Makes
  const ford = await prisma.make.upsert({
    where: { yearId_name: { yearId: year2024.id, name: 'Ford' } },
    update: {},
    create: {
      name: 'Ford',
      yearId: year2024.id,
    },
  });

  const ford2021 = await prisma.make.upsert({
    where: { yearId_name: { yearId: year2021.id, name: 'Ford' } },
    update: {},
    create: {
      name: 'Ford',
      yearId: year2021.id,
    },
  });

  const chevrolet = await prisma.make.upsert({
    where: { yearId_name: { yearId: year2024.id, name: 'Chevrolet' } },
    update: {},
    create: {
      name: 'Chevrolet',
      yearId: year2024.id,
    },
  });

  // Create Models
  const f150 = await prisma.models.upsert({
    where: { makeId_name: { makeId: ford.id, name: 'F-150' } },
    update: {},
    create: {
      name: 'F-150',
      makeId: ford.id,
    },
  });

  const f1502021 = await prisma.models.upsert({
    where: { makeId_name: { makeId: ford2021.id, name: 'F-150' } },
    update: {},
    create: {
      name: 'F-150',
      makeId: ford2021.id,
    },
  });

  const silverado = await prisma.models.upsert({
    where: { makeId_name: { makeId: chevrolet.id, name: 'Silverado' } },
    update: {},
    create: {
      name: 'Silverado',
      makeId: chevrolet.id,
    },
  });

  // Create Submodels
  const crewCab = await prisma.submodel.upsert({
    where: { modelId_name: { modelId: f150.id, name: 'SuperCrew' } },
    update: {},
    create: {
      name: 'SuperCrew',
      modelId: f150.id,
    },
  });

  const crewCab2021 = await prisma.submodel.upsert({
    where: { modelId_name: { modelId: f1502021.id, name: 'SuperCrew' } },
    update: {},
    create: {
      name: 'SuperCrew',
      modelId: f1502021.id,
    },
  });

  const crewCabSilverado = await prisma.submodel.upsert({
    where: { modelId_name: { modelId: silverado.id, name: 'Crew Cab' } },
    update: {},
    create: {
      name: 'Crew Cab',
      modelId: silverado.id,
    },
  });

  // Create BodyStyles
  const pickup = await prisma.bodyStyle.upsert({
    where: { submodelId_name: { submodelId: crewCab.id, name: 'Pickup' } },
    update: {},
    create: {
      name: 'Pickup',
      submodelId: crewCab.id,
    },
  });

  const pickup2021 = await prisma.bodyStyle.upsert({
    where: { submodelId_name: { submodelId: crewCab2021.id, name: 'Pickup' } },
    update: {},
    create: {
      name: 'Pickup',
      submodelId: crewCab2021.id,
    },
  });

  const pickupSilverado = await prisma.bodyStyle.upsert({
    where: { submodelId_name: { submodelId: crewCabSilverado.id, name: 'Pickup' } },
    update: {},
    create: {
      name: 'Pickup',
      submodelId: crewCabSilverado.id,
    },
  });

  // Create Suppliers
  const covercraft = await prisma.supplier.upsert({
    where: { name: 'Covercraft' },
    update: {},
    create: {
      name: 'Covercraft',
      apiKey: process.env.COVERCRAFT_API_KEY || 'demo-key',
      apiEndpoint: process.env.COVERCRAFT_API_ENDPOINT,
      ediEndpoint: process.env.COVERCRAFT_EDI_ENDPOINT,
      vendorId: process.env.COVERCRAFT_VENDOR_ID,
      leadTimeDays: 7,
      shippingDays: 3,
    },
  });

  // Create Products
  const customSeatCovers = await prisma.product.upsert({
    where: { sku: 'CSC-001' },
    update: {},
    create: {
      sku: 'CSC-001',
      name: 'Custom Fit Seat Covers - Premium Neosupreme',
      description: 'Factory-fit custom seat covers with premium Neosupreme material. Water-resistant, durable, and backed by our 3-year warranty.',
      category: 'seat-covers',
      wholesalePrice: 120,
      retailPrice: 199.99,
      profitMargin: 0.40,
      materials: ['Neosupreme'],
      colors: ['Black', 'Gray', 'Tan'],
      images: ['https://via.placeholder.com/500x500?text=Seat+Covers+1'],
      inStock: true,
      stockLevel: 25,
      shipsInDays: 1,
      speedArbitrage: true,
      speedPremium: 0.10,
    },
  });

  const universalSeatCovers = await prisma.product.upsert({
    where: { sku: 'USC-001' },
    update: {},
    create: {
      sku: 'USC-001',
      name: 'Universal Fit Seat Covers - Economy',
      description: 'Universal-fit seat covers that work with most vehicles.',
      category: 'seat-covers',
      wholesalePrice: 25,
      retailPrice: 49.99,
      profitMargin: 0.50,
      materials: ['Polyester'],
      colors: ['Black', 'Gray'],
      images: ['https://via.placeholder.com/500x500?text=Universal+Covers'],
      inStock: true,
      stockLevel: 100,
      shipsInDays: 1,
      speedArbitrage: false,
    },
  });

  // Create ProductSupplier links
  await prisma.productSupplier.upsert({
    where: {
      productId_supplierId: {
        productId: customSeatCovers.id,
        supplierId: covercraft.id,
      },
    },
    update: {},
    create: {
      productId: customSeatCovers.id,
      supplierId: covercraft.id,
      supplierSku: 'CC-CSC-F150-2024',
      supplierName: 'Custom Fit F-150 SuperCrew Seat Covers',
      costPrice: 120,
      msrp: 199.99,
      inStock: true,
      stockLevel: 25,
    },
  });

  // Create Fitments
  await prisma.fitment.upsert({
    where: {
      productId_modelId_bodyStyleId: {
        productId: customSeatCovers.id,
        modelId: f150.id,
        bodyStyleId: pickup.id,
      },
    },
    update: {},
    create: {
      productId: customSeatCovers.id,
      modelId: f150.id,
      bodyStyleId: pickup.id,
      submodelId: crewCab.id,
      supplierSku: 'CC-CSC-F150-2024',
      notes: 'Fits 2024 F-150 SuperCrew with front bucket seats',
      guaranteed: true,
    },
  });

  await prisma.fitment.upsert({
    where: {
      productId_modelId_bodyStyleId: {
        productId: customSeatCovers.id,
        modelId: f1502021.id,
        bodyStyleId: pickup2021.id,
      },
    },
    update: {},
    create: {
      productId: customSeatCovers.id,
      modelId: f1502021.id,
      bodyStyleId: pickup2021.id,
      submodelId: crewCab2021.id,
      supplierSku: 'CC-CSC-F150-2021',
      notes: 'Fits 2021 F-150 SuperCrew with front bucket seats',
      guaranteed: true,
    },
  });

  await prisma.fitment.upsert({
    where: {
      productId_modelId_bodyStyleId: {
        productId: customSeatCovers.id,
        modelId: silverado.id,
        bodyStyleId: pickupSilverado.id,
      },
    },
    update: {},
    create: {
      productId: customSeatCovers.id,
      modelId: silverado.id,
      bodyStyleId: pickupSilverado.id,
      submodelId: crewCabSilverado.id,
      supplierSku: 'CC-CSC-SILVERADO-2024',
      notes: 'Fits 2024 Silverado Crew Cab',
      guaranteed: true,
    },
  });

  console.log('✅ Seed data created successfully!');
  console.log('📊 Created:');
  console.log('  - 3 Years');
  console.log('  - 3 Makes');
  console.log('  - 3 Models');
  console.log('  - 3 Submodels');
  console.log('  - 3 BodyStyles');
  console.log('  - 1 Supplier (Covercraft)');
  console.log('  - 2 Products');
  console.log('  - 3 Fitments');
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error('❌ Seed error:', e);
    await prisma.$disconnect();
    process.exit(1);
  });
