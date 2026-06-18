FROM node:22-alpine

WORKDIR /app

RUN npm install -g pnpm

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY apps/config/package.json ./apps/config/
COPY apps/client/package.json ./apps/client/

RUN pnpm install --fetch-retries 5 --frozen-lockfile

COPY . .

ENV CHAIN_IDS="1 130 137 8453 747474"

RUN mkdir -p .cache

CMD ["sh", "-lc", "{ \
 for CHAIN in $CHAIN_IDS; do \
   echo \"RPC_URL_${CHAIN}=$(printenv RPC_URL_$CHAIN)\"; \
   echo \"EXECUTOR_ADDRESS_${CHAIN}=$(printenv EXECUTOR_ADDRESS_$CHAIN)\"; \
   echo \"LIQUIDATION_PRIVATE_KEY_${CHAIN}=$(printenv LIQUIDATION_PRIVATE_KEY)\"; \
 done; \
 echo \"RAILWAY_DEPLOYMENT_ID=$(printenv RAILWAY_DEPLOYMENT_ID)\"; \
} > .env && pnpm run liquidate"]
