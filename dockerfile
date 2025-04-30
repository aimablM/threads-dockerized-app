# Stage 1: Build the app
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of your app
COPY . .

# Build the Next.js app
RUN npm run build

# Stage 2: Run the built app
FROM node:20-alpine

WORKDIR /app

# Install only production deps
COPY package*.json ./
RUN npm install --omit=dev

# Copy built app from builder
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/next.config.js ./next.config.js
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000

CMD ["npm", "start"]
