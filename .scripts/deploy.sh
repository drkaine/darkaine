#!/bin/bash
set -e

echo "Le script commence"
cd ~/production/darkaine/ &&

# Pull la dernière version de l'application.
echo "pull origin main"
git pull -r origin main

echo "Le déploiement commence ..."

echo "Lancement du build"
zola build

echo "Déploiement terminé!"