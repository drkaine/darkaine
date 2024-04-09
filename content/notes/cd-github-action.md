+++
title = "Mettre en place une pipeline CD"
date = 2024-03-28
draft = false

[taxonomies]
categories = ["Configuration"]
tags = ["configuration", "déploiement continu", "github action", "craft", "Darkaine"]

[extra]

name = "Darkaine"                     # Your name
bio = "Je découvre, j'apprends, je prend des notes et je partage mes mémos."                          # Your bio
avatar = "img/avatar/avatar.jpeg"            # Your avatar
links = [                             # Your links
    {name = "GitHub", icon = "github", url = "https://github.com/drkaine"},
    {name = "Twitter", icon = "twitter", url = "https://twitter.com/Darkaine1"},
    {name = "Bluesky", icon = "bluesky", url = "https://bsky.app/profile/darkaine.bsky.social"},
]

+++

## Le déploiement continu (CD)

### Introduction

Une pipeline de déploiement continu (CD), est un processus automatisé permettant de livrer des modifications de code vers un environnement de production de manière régulière et fiable. Cette pipeline permet de construire et de déployer automatiquement les modifications apportées au code tout au long du cycle de développement, ce qui accélère le processus de livraison logicielle et améliore la qualité du logiciel en évitant les manipulations et en gardant toujours le même processus.

### Pourquoi mettre en place une pipeline CD ?

Avantages :
* Automatisation des déploiements : Une pipeline CD automatise l'ensemble du processus de déploiement, réduisant ainsi la nécessité d'interventions manuelles et les risques d'erreurs humaines.

* Livraisons rapides et fréquentes : En permettant des déploiements automatisés à chaque modification de code, elle facilite les livraisons rapides et fréquentes, permettant ainsi de répondre rapidement aux besoins des utilisateurs et d'itérer plus rapidement.

* Feedback rapide : Avec des déploiements fréquents et automatisés, les développeurs reçoivent un feedback rapide sur leurs modifications de code, ce qui leur permet de réagir rapidement aux problèmes et de continur à améliorer le logiciel.

* Réduction des risques : En automatisant les déploiements, cela réduit les risques associés aux déploiements manuels, tels que les erreurs de configuration, les oublis et les incompatibilités.

Inconvénients :
* Complexité initiale : La mise en place peut être complexe, nécessitant des efforts significatifs pour configurer les outils et les flux de travail.

* Maintenance : Une fois mise en place, elle nécessite une maintenance continu pour s'assurer qu'elle reste adaptée aux besoins changeants de l'application et de l'infrastructure.

* Investissement en ressources : La création et la maintenance d'une pipeline CD nécessitent des ressources en termes de temps, de personnel, de compétences et de coûts.


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

Il faut maintenant créer le fichier de la pipeline (le workflow), qui se situe dans un dossier .github/workflows, pour le nom j'ai choisie CD.yml
Comme avec ce [projet](https://github.com/drkaine/repas-en-avance/blob/main/.github/workflows/CD.yml) :
```
name: déploiement

# Déclencher le flux de travail lors d'un push et
# demande de fusion sur la branche de production
on:
  push:
    branches:
      [main]
  pull_request:
    branches:
      [main]
      
# Authentifiez-vous sur le serveur via SSH 
# et exécutez notre script de déploiement
jobs:
  deploiement_continue :
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: deploy change
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.HOST }}
          username: ${{ secrets.USERNAME }}
          port: ${{ secrets.PORT }}
          key: ${{ secrets.SSHKEY }}
          password: ${{ secrets.PASSWORD }}
```

Pour une [expliction plus détaillé](/notes/github-action) du fichier au dessus. 

Maintenant on a créé notre pipeline, on peut commit et push les modifications et il apparaîtrat un icon success ou error selon si la pipeline à réussie ou non :

<div align="center">
    <img src="/img/notes/cd-github-action/icon-pipeline-success.png" alt="une icon indique que la pipeline a réussie" style="align-items: center;" width="100%"/>
</div>


Et dans l'onglet "Actions" on a maintenant la liste des pipelines et leur états et le temps mis pour les passer :

<div align="center">
    <img src="/img/notes/cd-github-action/listing-pipelines.png" alt="listing des pipelines passées" style="align-items: center;" width="100%"/>
</div>

### Donner les droits à github action

Maintenant que la pipeline est prête, si les modifications sont push on peut voire une erreur, c'est normal car github n'a pas les droits pour exécuter les actions demandées sur le VPS.

#### Créer une clef ssh
On doit créer une clef ssh qui servira à Github pour le déploiment et la mettre dans le fichier authorized_keys de notre serveur :
```
ssh-keygen -t rsa -b 4096 -C "email@example.com"*
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```

Puis il faut la mettre dans github, sur le répertoire dans l'onglet settings puis dans security->deploy Keys (https://github.com/NOM/NOM-PROJET/settings/keys).
Ne pas donner les droits d'écriture sur le répertoire, on a juste besoin qu'il fasse un pull, pas qu'il puisse push.

#### Les secrets
Dans notre yaml pour la pipeline on a mis :
```
with:
  host: ${{ secrets.HOST }}
  username: ${{ secrets.USERNAME }}
  port: ${{ secrets.PORT }}
  key: ${{ secrets.SSHKEY }}
  password: ${{ secrets.PASSWORD }}
```
On doit les renseigner dans l'onglet settings puis dans security->Secrets and variable => actions (https://github.com/NOM/NOM-PROJET/settings/secrets/actions).

* HOST => c'est l'adresse IP du serveur.
* PORT => le port SSH, par défaut c'est le 22
* SSHKEY => la clef secréte ssh du serveur, normalement elle ne doit pas être donné, mais dans ce cas c'est obligatoire
* PASSWORD => le mot de passe de la clef, si il n'est pas nule, il est possible que github est du mal à l'utiliser
* USERNAME => le nom de l'utilisateur qui va se connecter

### Conclusion

Maintenant il n'y a plus qu'à faire un commit et vérifier que la pipeline fonctionne et voir si les modifications sont bien mise en place.

On peut rajouter un badge sur son répertoire Github qui montre l'état des dernière pipeline:
<div align="center">
    <img src="/img/notes/cd-github-action/badge.png" alt="Badge de status des pipeline" style="align-items: center;" width="100%"/>
</div>

Pour cela il faut aller dans l'onglet Actions workflow => le nom de la pipeline, là déploiement et sur les ... à côté du champs de recherche séléctionner "create status badge" puis le mettre dans le READ.ME.
<div align="center">
    <img src="/img/notes/cd-github-action/create-badge.png" alt="Emplacement du bouton de création de badge" style="align-items: center;" width="100%"/>
</div>