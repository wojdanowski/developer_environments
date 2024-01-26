FROM node:20.10.0-alpine AS build
WORKDIR /usr/app

RUN apk add --update \
  python3 \
  make \
  gcc \
  g++ \
  libc-dev \
  git \
  openssh \
  chromium

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

COPY package.json package-lock.json .npmrc ./

RUN npm install --legacy-peer-deps

COPY . .

RUN npm run build

FROM node:20.10.0-alpine

WORKDIR /usr/app

ARG TF_VAR_BRANCH_NAME
ENV TF_VAR_BRANCH_NAME ${TF_VAR_BRANCH_NAME}

COPY --from=build /usr/app/dist/ ./dist
COPY --from=build /usr/app/node_modules ./node_modules

CMD ["sh", "-c", "node dist/src/main.js"]