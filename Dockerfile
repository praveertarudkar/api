# API Nest by Praveer Tarudkar
# Dockerfile — single-stage, minimal Node.js image

FROM node:20-alpine

LABEL maintainer="Praveer Tarudkar"
LABEL description="API Nest — Self-hosted API Generator Platform"

WORKDIR /app

# Install dependencies first (layer caching)
COPY package.json ./
RUN npm install --omit=dev

# Copy source
COPY src/ ./src/
COPY public/ ./public/

# SQLite data directory (mount as volume in production)
RUN mkdir -p /app/data

EXPOSE 3000

ENV NODE_ENV=production
ENV PORT=3000
ENV DB_PATH=/app/data/apinest.db

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

CMD ["node", "src/server.js"]
