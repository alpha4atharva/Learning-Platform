# ---------- Build frontend ----------
FROM node:20-alpine AS frontend-build

WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm install

COPY frontend .
RUN npm run build


# ---------- Build backend ----------
FROM node:20-alpine

WORKDIR /app

# install backend deps
COPY backend/package*.json ./backend/
RUN cd backend && npm install --production

# copy backend source
COPY backend ./backend

# copy Next.js build to backend public
COPY --from=frontend-build /app/frontend/.next ./frontend/.next
COPY --from=frontend-build /app/frontend/public ./frontend/public
COPY --from=frontend-build /app/frontend/package.json ./frontend/package.json

ENV NODE_ENV=production
ENV PORT=5000

EXPOSE 5000

CMD ["node","backend/server.js"]
