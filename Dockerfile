# ===== المرحلة 1: البناء =====
FROM node:22-alpine AS build
WORKDIR /app

# نسخ ملفات المكتبات أولًا (للاستفادة من التخزين المؤقت)
COPY package*.json ./
RUN npm ci

# نسخ بقية الكود ثم البناء
COPY . .
RUN npm run build

# ===== المرحلة 2: الإنتاج (Nginx خفيف) =====
FROM nginx:alpine

# نسخ ملفات البناء من المرحلة الأولى إلى مجلد Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# نسخ إعداد Nginx المخصص (نُنشئه في القسم التالي)
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
