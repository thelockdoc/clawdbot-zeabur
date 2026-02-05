FROM node:20-slim  
WORKDIR /app  
RUN npm install -g openclaw  
COPY start.sh /app/start.sh  
RUN chmod +x /app/start.sh  
EXPOSE 8080  
CMD ["/app/start.sh"]  
