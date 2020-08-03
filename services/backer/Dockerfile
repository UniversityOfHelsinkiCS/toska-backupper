
FROM node:14

ARG BASE_PATH
ENV BASE_PATH=$BASE_PATH

COPY package* ./
ADD backer-script.sh /backer-script.sh
RUN npm ci
COPY . .

EXPOSE 8000

CMD ["npm", "start"]
