#Copy Dockerfile file to app folder
echo "Setup project dependencies..."
echo "Copying Dockerfile to app folder..."
cp ../../Dockerfile ../../app

#Copy docker-compose.yml file to app folder
echo "Copying docker-compose.yml to app folder..."
cp docker-compose.yml ../../app

#Change working directory path to app
echo "Change working directory to app folder."
cd ../../app

#Installing dependencies
echo "Installing project dependencies..."
npm install

echo -e "\033[33mNOTICE: This application consumed localhost endpoint for healthcheck under docker-compose.yml file, which will be going to fail if Identity service is not working locally on your machine. To make it working either run Identity service locally or you can use Identity service dev url.\033[0m"

#Run docker-compose command to run application 
echo "Running docker-compose to build and run the application in background...";
DOCKER_COMPOSE_CMD="docker-compose -f docker-compose.yml up --build --detach"
eval "$DOCKER_COMPOSE_CMD"

IS_RUNNING=`docker-compose ps -q loan_engine_service`
if [[ "$IS_RUNNING" != "" ]]; then
  echo "Application is running on http://localhost:3003/ping"
fi