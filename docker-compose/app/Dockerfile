FROM node:latest
RUN mkdir -p /opt/app 
RUN chown -R node:node /opt/app
WORKDIR /opt/app
COPY --chown=node:node . .
RUN npm install
USER node
EXPOSE 3000 
ENTRYPOINT ["npm","run","start"]
