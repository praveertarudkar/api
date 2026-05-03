# 🪺 API Nest by Praveer Tarudkar

> **Self-hosted, zero-cost API Generator Platform**
> Create full CRUD REST APIs dynamically — define a schema, get live endpoints instantly.

---

## ✨ Features

| Feature | Details |
|---|---|
| **API Generator** | POST a schema → get 5 CRUD endpoints instantly |
| **Dynamic Routing** | Routes auto-registered and persist across restarts |
| **SQLite Default** | Zero config, single file, blazing fast |
| **API Key Auth** | Header: `X-API-Key` |
| **JWT Auth** | Optional per-API token auth |
| **Request Logging** | Every request logged to SQLite |
| **Rate Limiting** | In-memory, 100 req / 15 min (configurable) |
| **Swagger Docs** | Auto-generated at `/api-docs` |
| **Code Generator** | Node.js, Python, Go, Java snippets |
| **Dashboard** | Beautiful UI at `http://localhost:3000` |
| **$0/month** | Runs entirely free on localhost or free cloud tiers |

---

## 🚀 Quick Start (Local)

```bash
# 1. Clone or unzip the project
cd api-nest

# 2. Install dependencies (Node.js 16+ required)
npm install

# 3. Copy and configure environment
cp .env.example .env

# 4. Start the server
npm start

# Open the dashboard
open http://localhost:3000

# Open Swagger docs
open http://localhost:3000/api-docs
```

For live-reload during development:
```bash
npm run dev   # requires nodemon (installed as devDependency)
```

---

## 🐳 Docker (Optional)

```bash
# Build and run with Docker Compose (recommended)
docker-compose up -d

# Or manual Docker
docker build -t api-nest .
docker run -p 3000:3000 -v api-nest-data:/app/data api-nest
```

---

## 📁 Project Structure

```
api-nest/
├── src/
│   ├── server.js                 # Express app entry point
│   ├── db/
│   │   └── sqlite.js             # Database layer (all CRUD + schema mgmt)
│   ├── routes/
│   │   ├── api.js                # Management routes (/api/*)
│   │   ├── serve.js              # Dynamic CRUD engine (/serve/:resource)
│   │   ├── auth.js               # JWT token issuance
│   │   └── dynamic.js            # Startup route loader
│   ├── middleware/
│   │   ├── auth.js               # API key + JWT middleware
│   │   ├── logger.js             # Request logging middleware
│   │   └── rateLimiter.js        # In-memory rate limiter
│   └── utils/
│       ├── swagger.js            # Auto-generated OpenAPI docs
│       └── codeTemplates.js      # Multi-language code snippets
├── public/
│   ├── index.html                # Frontend dashboard
│   └── api-client.js             # Frontend ↔ backend integration
├── data/                         # SQLite DB files (auto-created)
├── Dockerfile
├── docker-compose.yml
├── render.yaml                   # Render.com deployment config
├── .env.example
└── package.json
```

---

## 🔌 API Reference

### Create a Dynamic API
```http
POST /api/generate
Content-Type: application/json

{
  "name": "Products Catalog",
  "basePath": "products",
  "description": "A product inventory API",
  "authRequired": false,
  "schema": {
    "fields": [
      { "name": "title",    "type": "string",  "required": true  },
      { "name": "price",    "type": "number",  "required": true  },
      { "name": "category", "type": "string",  "required": false },
      { "name": "inStock",  "type": "boolean", "required": false }
    ]
  }
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "basePath": "products",
    "endpoints": {
      "list":   "GET    /serve/products",
      "create": "POST   /serve/products",
      "get":    "GET    /serve/products/:id",
      "update": "PUT    /serve/products/:id",
      "delete": "DELETE /serve/products/:id"
    }
  }
}
```

### Use Your API
```bash
# List all products
curl http://localhost:3000/serve/products

# Create a product
curl -X POST http://localhost:3000/serve/products \
  -H "Content-Type: application/json" \
  -d '{"title": "Headphones", "price": 49.99, "category": "Electronics"}'

# Get by ID
curl http://localhost:3000/serve/products/{id}

# Update
curl -X PUT http://localhost:3000/serve/products/{id} \
  -H "Content-Type: application/json" \
  -d '{"price": 39.99}'

# Delete
curl -X DELETE http://localhost:3000/serve/products/{id}
```

### With API Key Auth
```bash
curl http://localhost:3000/serve/products \
  -H "X-API-Key: apinest_your_key_here"
```

### Management Endpoints

| Method | Path | Description |
|---|---|---|
| `POST` | `/api/generate` | Create a new dynamic API |
| `GET` | `/api/list` | List all APIs |
| `GET` | `/api/stats` | Dashboard stats |
| `GET` | `/api/logs` | Request logs |
| `DELETE` | `/api/logs` | Clear logs |
| `DELETE` | `/api/:id` | Delete an API |
| `GET` | `/api/keys` | List API keys |
| `POST` | `/api/keys` | Create an API key |
| `DELETE` | `/api/keys/:id` | Delete an API key |
| `GET` | `/api/code/:resource?lang=node` | Get code snippet |
| `POST` | `/api/auth/token` | Get JWT from API key |
| `GET` | `/api-docs` | Swagger UI |
| `GET` | `/health` | Health check |

---

## 🔐 Authentication

**API Key** (default — check server startup log for your key):
```bash
curl -H "X-API-Key: apinest_abc123..." http://localhost:3000/serve/products
```

**JWT** (exchange API key for token):
```bash
# Step 1: Get token
curl -X POST http://localhost:3000/api/auth/token \
  -H "Content-Type: application/json" \
  -d '{"apiKey": "apinest_your_key"}'

# Step 2: Use token
curl -H "Authorization: Bearer eyJ..." http://localhost:3000/serve/products
```

---

## ☁️ Free Deployment

### Render.com (Recommended)
1. Push code to GitHub
2. Go to render.com → New → Web Service
3. Connect repo → Use `render.yaml` → Deploy
4. Add a **Disk** (1GB free) mounted at `/app/data`

### Railway.app
1. Push to GitHub
2. railway.app → New Project → GitHub repo
3. Set env vars from `.env.example`
4. Add a Volume at `/app/data`

### Vercel (Frontend only)
Deploy the `public/` folder as a static site, pointing `API.BASE` to your Render backend URL.

---

## 🗄️ Database Options

The system defaults to **SQLite** (zero config).
Future adapters can replace the `src/db/sqlite.js` module:

```
src/db/
├── sqlite.js       ← Active (default)
├── mongodb.js      ← Swap in for MongoDB
└── postgres.js     ← Swap in for PostgreSQL
```

Simply implement the same exported functions and change the `require` in `server.js`.

---

## 🔮 Future Upgrades

### Plugin System
```js
// Proposed: src/plugins/myPlugin.js
module.exports = {
  name: 'audit-log',
  onBefore: (req) => { /* pre-request hook */ },
  onAfter:  (res) => { /* post-request hook */ },
};
```

### Multi-User Support
- Add a `users` table with roles (admin, developer, viewer)
- Scope API definitions per user
- OAuth2 / magic link login (free with Resend)

### Monetization
- Stripe metered billing per request over free tier
- Team workspaces with per-seat pricing
- Managed cloud hosting with custom domains

### Performance Upgrades
- Redis for rate limiting and caching
- Queue-based logging (write-ahead buffer)
- Read replicas with PostgreSQL

---

## ⚙️ Environment Variables

| Variable | Default | Description |
|---|---|---|
| `PORT` | `3000` | Server port |
| `DB_PATH` | `./data/apinest.db` | SQLite file path |
| `JWT_SECRET` | *(change this!)* | JWT signing secret |
| `RATE_LIMIT_MAX` | `100` | Max requests per window |
| `RATE_LIMIT_WINDOW` | `15` | Window in minutes |

---

## 📄 License

MIT © Praveer Tarudkar

---

*Built with Node.js + Express + SQLite. Runs entirely free. Zero dependencies on paid services.*
