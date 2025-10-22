#!/bin/bash
set -euo pipefail

echo "Cloning frontend..."
if [ -d "dhunn" ]; then
  echo "Removing existing 'dhunn' folder..."
  rm -rf dhunn
fi
git clone -b master https://github.com/ravi98397/dhunn.git

cd dhunn
npm install --force
npm run build
cd ..
echo "parent dir"
ls -la

echo "Cloning backend..."
if [ -d "musicapi" ]; then
  echo "Removing existing 'musicapi' folder..."
  rm -rf musicapi
fi
git clone -b master https://github.com/ravi98397/musicapi.git

mkdir -p musicapi/src/main/resources/public
cp -r dhunn/build/* musicapi/src/main/resources/public
echo "Frontend built and copied to backend."
cd musicapi
#mvn clean install
mvn clean install -DskipTests

mkdir -p ../musicapp/target/
cp -r target/*.jar ../musicapp/target/
echo "JAR built at musicapi/target/"
