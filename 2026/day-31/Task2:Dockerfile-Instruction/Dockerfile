#Base Image
FROM ubuntu:latest

#Run command and install deps
RUN apt-get update && apt-get install -y bash && rm -rf /var/lib/apt/lists/*

#Creating default dir in container
WORKDIR /app

#Copy from source Code to Destination
COPY app.sh .

#using shell giving execute permission to app.sh
RUN chmod +x app.sh

#Container inside port Expose
EXPOSE 8080

#Executee code from container
CMD ["./app.sh"]