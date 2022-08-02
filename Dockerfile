FROM node:16 as build-phase
WORKDIR /app
# Resolving an issue with esbuild in docker container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
# Install pnpm package manager
RUN npm install -g pnpm
# Files required by pnpm install
COPY package.json pnpm-lock.yaml ./
RUN pnpm install
COPY . .
RUN pnpm run build
# Production phase
FROM nginx
COPY --from=build-phase /app/dist /usr/share/nginx/html