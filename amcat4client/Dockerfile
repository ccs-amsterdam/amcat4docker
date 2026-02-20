# syntax=docker.io/docker/dockerfile:1

FROM node:20-alpine AS base

# ==========================================
# 1. CLONE STAGE
# ==========================================
FROM base AS cloner
RUN apk add --no-cache git
WORKDIR /app

# Use ARG to allow building specific branches/tags
ARG amcat4client_commit=master

# We clone into a temporary folder and move files to avoid
# potential issues with cloning into an existing WORKDIR
RUN git clone https://github.com/ccs-amsterdam/amcat4client.git . && \
    git checkout ${amcat4client_commit}

# ==========================================
# 2. DEPENDENCIES STAGE
# ==========================================
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Copy ONLY lockfiles first to leverage Docker cache
# If these files don't change, Docker skips the 'npm ci' / 'yarn install' step
COPY --from=cloner /app/package.json /app/yarn.lock* /app/package-lock.json* /app/pnpm-lock.yaml* /app/.npmrc* ./

RUN \
    if [ -f yarn.lock ]; then yarn --frozen-lockfile; \
    elif [ -f package-lock.json ]; then npm ci; \
    elif [ -f pnpm-lock.yaml ]; then corepack enable pnpm && pnpm i --frozen-lockfile; \
    else echo "Lockfile not found." && exit 1; \
    fi

# ==========================================
# 3. BUILDER STAGE
# ==========================================
FROM base AS builder
WORKDIR /app
# Bring in the installed node_modules
COPY --from=deps /app/node_modules ./node_modules
# Bring in the rest of the source code from the cloner
COPY --from=cloner /app .

# Disable Next.js telemetry for faster/private builds
ENV NEXT_TELEMETRY_DISABLED=1

RUN \
    if [ -f yarn.lock ]; then yarn build; \
    elif [ -f package-lock.json ]; then npm run build; \
    elif [ -f pnpm-lock.yaml ]; then corepack enable pnpm && pnpm run build; \
    else echo "Lockfile not found." && exit 1; \
    fi

# ==========================================
# 4. RUNNER STAGE
# ==========================================
FROM base AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs

# Set correct permissions for Next.js standalone output
COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs
EXPOSE 3000
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

CMD ["node", "server.js"]
