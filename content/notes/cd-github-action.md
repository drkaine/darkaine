+++
title = "Mettre en place une pipeline CD"
date = 2025-02-27
draft = false

[taxonomies]
categories = ["Configuration"]
tags = ["configuration", "déploiement continu", "github action", "craft", "Darkaine"]

[extra]

name = "Darkaine"
bio = "Je découvre, j'apprends, je prends des notes et je les partage."
avatar = "img/avatar/avatar.jpeg"
links = [
    {name = "GitHub", icon = "github", url = "https://github.com/drkaine"},
    {name = "Twitter", icon = "twitter", url = "https://twitter.com/Darkaine1"},
    {name = "Bluesky", icon = "bluesky", url = "https://bsky.app/profile/darkaine.bsky.social"},
]

+++

## Le déploiement continu (CD)

### Introduction

Une pipeline de déploiement continu (CD - Continuous Deployment) est un processus automatisé permettant de livrer des modifications de code vers un environnement de production de manière régulière et fiable. Cette pipeline permet de construire et de déployer automatiquement les modifications apportées au code tout au long du cycle de développement, ce qui accélère le processus de livraison logicielle et améliore la qualité du logiciel en évitant les manipulations manuelles et en standardisant le processus.

### Pourquoi mettre en place une pipeline CD ?

Avantages :
* **Automatisation des déploiements** : Une pipeline CD automatise l'ensemble du processus de déploiement, réduisant ainsi la nécessité d'interventions manuelles et les risques d'erreurs humaines.

* **Livraisons rapides et fréquentes** : En permettant des déploiements automatisés à chaque modification de code validée, elle facilite les livraisons rapides et fréquentes, permettant ainsi de répondre rapidement aux besoins des utilisateurs et d'itérer plus efficacement.

* **Feedback rapide** : Avec des déploiements fréquents et automatisés, les développeurs reçoivent un retour immédiat sur leurs modifications de code, ce qui leur permet de réagir rapidement aux problèmes et d'améliorer continuellement le logiciel.

* **Réduction des risques** : En automatisant les déploiements, on réduit les risques associés aux déploiements manuels, tels que les erreurs de configuration, les oublis et les incompatibilités.

* **Traçabilité** : Chaque déploiement est documenté et tracé, permettant de savoir exactement quelle version du code est en production.

Inconvénients :
* **Complexité initiale** : La mise en place peut être complexe, nécessitant des efforts significatifs pour configurer les outils et les flux de travail.

* **Maintenance** : Une fois mise en place, la pipeline nécessite une maintenance continue pour s'assurer qu'elle reste adaptée aux besoins changeants de l'application et de l'infrastructure.

* **Investissement en ressources** : La création et la maintenance d'une pipeline CD nécessitent des ressources en termes de temps, de personnel, de compétences et de coûts.

En résumé, malgré quelques défis potentiels, les avantages d'une pipeline de déploiement continu, tels que l'automatisation, la rapidité et l'amélioration de la qualité, l'emportent généralement sur les inconvénients, ce qui en fait un élément essentiel d'une pratique de développement logiciel moderne et efficace.

### Ne pas confondre avec la livraison continue

La principale différence entre la livraison continue et le déploiement continu réside dans le niveau d'automatisation du processus de déploiement en production. La livraison continue rend les versions prêtes à être déployées à tout moment, mais laisse la décision finale de déploiement aux équipes de développement, tandis que le déploiement continu automatise complètement le déploiement des nouvelles versions en production dès qu'elles sont prêtes.

## Mise en place de la pipeline CD pour un VPS

### Avec Github action

#### Créer un script

Pour une mise en production simple, on créer un script bash, qui va refaire notre processus de mise en production, dans un dossier .scripts à la racine du projet, avec comme nom, par exemple "deploy.sh".
L'exemple est pour un déploiement d'un [projet](https://github.com/drkaine/repas-en-avance/blob/main/.scripts/deploy.sh) en laravel :
```
#!/bin/bash
set -e

echo "Le script commence"
cd ~/production/repas-en-avance/ &&

# Pull la dernière version de l'application.
echo "pull origin main"
git pull

echo "Le déploiement commence ..."

# Installation des dépendances avec composer
echo "composer install"
composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader

# Entrer en mode maintenance ou retourner true
# Si le site est déjà en mode maintenance
echo "(php artisan down) || true"
(php artisan down) || true

# Nettoyez l'ancien cache
echo "php artisan clear-compiled"
php artisan clear-compiled

# Récréer le cache
# echo "php artisan optimize"
# php artisan optimize

# Compile npm assets
echo "npm install"
npm install

# Lancez database migrations
echo "php artisan migrate --force"
php artisan migrate --force


# Sortir du mode maintenancer
echo "php artisan up"
php artisan up

echo "Déploiement terminé!"
```

Il faut lui donner la permission d'écriture dans le dossier :
```
sudo chmod +x ./REPOSITORY/.scripts/deploy.sh
```

### Le workflow

Il faut maintenant créer le fichier de la pipeline (le workflow) dans un dossier `.github/workflows`. Voici un exemple de configuration dans `CD.yml` :

```yaml
name: Déploiement Continu

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
      
jobs:
  deploiement_continu:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout du code
        uses: actions/checkout@v3
        
      - name: Déploiement via SSH
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.HOST }}
          username: ${{ secrets.USERNAME }}
          port: ${{ secrets.PORT }}
          key: ${{ secrets.SSHKEY }}
          password: ${{ secrets.PASSWORD }}
          script: |
            cd ~/production/repas-en-avance/
            bash .scripts/deploy.sh
```

Pour une [explication plus détaillée](/notes/github-action) du fichier au dessus. 

Maintenant on a créé notre pipeline, on peut commit et push les modifications et il apparaîtra un icône succès ou erreur selon si la pipeline a réussi ou non :

<div align="center">
    <img src="/img/notes/cd-github-action/icon-pipeline-success.png" alt="une icône indique que la pipeline a réussie" style="align-items: center;" width="100%"/>
</div>


Et dans l'onglet "Actions" on a maintenant la liste des pipelines et leur états et le temps mis pour les passer :

<div align="center">
    <img src="/img/notes/cd-github-action/listing-pipelines.png" alt="listing des pipelines passées" style="align-items: center;" width="100%"/>
</div>

### Donner les droits à github action

Maintenant que la pipeline est prête, si les modifications sont push on peut voir une erreur, c'est normal car github n'a pas les droits pour exécuter les actions demandées sur le VPS.

#### Créer une clé ssh
On doit créer une clé ssh qui servira à Github pour le déploiement et la mettre dans le fichier authorized_keys de notre serveur :
```
ssh-keygen -t rsa -b 4096 -C "email@example.com"*
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```

Puis il faut la mettre dans github, sur le répertoire dans l'onglet settings puis dans security->deploy Keys (https://github.com/NOM/NOM-PROJET/settings/keys).
Ne pas donner les droits d'écriture sur le répertoire, on a juste besoin qu'il fasse un pull, pas qu'il puisse push.

#### Les secrets

Les variables sensibles doivent être configurées dans les "Secrets" du repository GitHub :

* `HOST` : L'adresse IP ou le nom de domaine du serveur
* `PORT` : Le port SSH (par défaut 22)
* `SSHKEY` : La clé privée SSH (format PEM)
* `PASSWORD` : Le mot de passe de la clé SSH (si nécessaire)
* `USERNAME` : Le nom d'utilisateur SSH sur le serveur

Pour ajouter ces secrets :
1. Allez dans "Settings" du repository
2. Naviguez vers "Secrets and variables" > "Actions"
3. Cliquez sur "New repository secret"
4. Ajoutez chaque secret avec sa valeur

### Bonnes pratiques

* Toujours tester la pipeline dans un environnement de staging avant la production
* Mettre en place des rollbacks automatiques en cas d'échec
* Monitorer les déploiements et mettre en place des alertes
* Documenter le processus de déploiement et les procédures de récupération
* Utiliser des variables d'environnement pour la configuration

### Conclusion

Maintenant il n'y a plus qu'à faire un commit et vérifier que la pipeline fonctionne et voir si les modifications sont bien mises en place.

On peut rajouter un badge sur son répertoire Github qui montre l'état des dernières pipelines :
<div align="center">
    <img src="/img/notes/cd-github-action/badge.png" alt="Badge de status des pipelines" style="align-items: center;" width="100%"/>
</div>

Pour cela il faut aller dans l'onglet Actions workflow => le nom de la pipeline, là déploiement et sur les ... à côté du champ de recherche sélectionner "create status badge" puis le mettre dans le README.
<div align="center">
    <img src="/img/notes/cd-github-action/create-badge.png" alt="Emplacement du bouton de création de badge" style="align-items: center;" width="100%"/>
</div>

## Ressources Supplémentaires

- [GitHub Actions Documentation](https://docs.github.com/en/actions) : Documentation officielle sur GitHub Actions.
- [Continuous Deployment with GitHub Actions](https://www.freecodecamp.org/news/continuous-deployment-with-github-actions/) : Un guide sur la mise en place du déploiement continu avec GitHub Actions.
- [How to Set Up a CI/CD Pipeline with GitHub Actions](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-ci-cd-pipeline-with-github-actions) : Un tutoriel détaillé sur la configuration d'une pipeline CI/CD avec GitHub Actions.
- [GitHub Actions for CI/CD](https://www.smashingmagazine.com/2020/06/github-actions-ci-cd/) : Un article sur l'utilisation de GitHub Actions pour CI/CD.
- [Automating Your CI/CD Pipeline with GitHub Actions](https://www.toptal.com/devops/github-actions-ci-cd) : Un article sur l'automatisation des pipelines CI/CD avec GitHub Actions.
- [GitHub Actions Best Practices](https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions#best-practices) : Meilleures pratiques pour utiliser GitHub Actions.