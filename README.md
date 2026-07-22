# CarCover E-Commerce Platform

**Elite Automotive E-Commerce Architecture** engineered to clone and outperform CarCoverWorld.com.

## Core Features

- **YMM (Year-Make-Model) Fitment Engine** with instant-filter dropdowns
- **Programmatic SEO** with dynamic landing pages for 1000s of vehicle combinations
- **Wholesale Arbitrage & Auto-Routing** to Covercraft/Coverking suppliers
- **Speed Arbitrage** in-stock flagging with same-day shipping premiums
- **Local Installation Bundling** with calendar booking integration
- **Automated Marketplace Feed Generation** (Facebook, eBay)

## Tech Stack

- **Frontend**: Next.js 14 (App Router, SSG/SSR, TypeScript)
- **Backend**: Node.js + Express REST API
- **Database**: PostgreSQL + Prisma ORM
- **Payment**: Stripe
- **Email**: Resend
- **Hosting**: AWS (RDS, S3, Lambda for webhooks) or Vercel + Serverless
- **Containerization**: Docker

## Project Structure

```
.
├── apps/
│   ├── web/              # Next.js frontend
│   └── api/              # Express backend
├── packages/
│   ├── db/               # Prisma schema & migrations
│   ├── shared/           # Shared types & utilities
│   └── config/           # Environment & config management
├── docker-compose.yml    # Local dev environment
└── README.md
```

## Quick Start

### Prerequisites
- Node.js 18+
- Docker & Docker Compose
- PostgreSQL 15+

### Installation

```bash
# Install dependencies
npm install

# Setup environment variables
cp .env.example .env.local

# Start local PostgreSQL
docker-compose up -d

# Run migrations
cd packages/db && npx prisma migrate dev

# Start dev servers
npm run dev
```

### URLs
- Frontend: http://localhost:3000
- API: http://localhost:3001
- Prisma Studio: http://localhost:5555

## Roadmap

### Phase 1: MVP (Weeks 1-4)
- Database schema & migrations
- YMM search API & React components
- Basic product catalog with seed data
- Dynamic SEO page templates
- Covercraft integration (order routing)

### Phase 2: Automation (Weeks 5-8)
- Supplier inventory sync webhooks
- Speed arbitrage flagging & dynamic pricing
- Programmatic SEO page generation (1000s of pages)
- Order routing automation (EDI/CSV)

### Phase 3: Marketplace Integration (Weeks 9-12)
- Facebook/eBay feed generators
- Local installation add-on engine
- Calendar booking integration
- Live chat & support

## Key APIs

- `GET /api/vehicles` - Filter vehicles by Year/Make/Model
- `GET /api/products/fitment/:vehicleId` - Get products for vehicle
- `POST /api/orders` - Create wholesale order
- `GET /api/inventory/sync` - Supplier inventory webhook

## Architecture Highlights

### Frontend (Next.js)
- **SSG** for static SEO pages (1000s of YMM combinations)
- **ISR** for inventory updates without rebuild
- **API Routes** for lightweight backend ops
- **Image optimization** for product catalogs

### Backend (Express)
- **Webhook handlers** for supplier inventory sync
- **EDI/CSV workers** for order routing
- **Rate limiting** for API stability
- **Job queues** (Bull/Redis) for async tasks

### Database (PostgreSQL)
- **ACES/PIES-compliant** fitment mapping
- **JSONB** for flexible product specs
- **Full-text search** for discovery
- **Native UUID** for idempotent operations

## Contributing

1. Feature branch: `git checkout -b feature/description`
2. Commit: `git commit -m 'feat: description'`
3. Push: `git push origin feature/description`
4. Open PR

## License

MIT
