+++
title = "Mettre en place une pipeline CI"
date = 2024-04-09
draft = false

[taxonomies]
categories = ["Configuration"]
tags = ["configuration", "déploiement continu", "github action", "craft", "Darkaine"]

[extra]

name = "Darkaine"
bio = "Je découvre, j'apprends, je prend des notes et je les partage."
avatar = "img/avatar/avatar.jpeg"
links = [
    {name = "GitHub", icon = "github", url = "https://github.com/drkaine"},
    {name = "Twitter", icon = "twitter", url = "https://twitter.com/Darkaine1"},
    {name = "Bluesky", icon = "bluesky", url = "https://bsky.app/profile/darkaine.bsky.social"},
]

+++
## L'intégration continue (CI)

### Introduction

Une pipeline CI (Continuous Integration) est un ensemble de processus automatisés qui facilitent le développement logiciel en assurant une intégration continue et en automatisant les tests, la vérification de la qualité du code, la compilation et le déploiement du logiciel.

Voici ses principaux composants :

* Version Control System (VCS) : Les pipelines CI sont généralement associées à un système de contrôle de version tel que Git. Elles surveillent les changements dans le référentiel de code source et déclenchent les processus d'intégration lorsqu'un changement est détecté.

* Tests automatisés : Elles exécutent des tests automatisés pour s'assurer que les changements introduits dans le code ne causent pas de régressions et que les fonctionnalités existantes fonctionnent toujours comme prévu.

* Analyse statique du code : Les outils d'analyse statique du code peuvent être utilisés pour détecter les erreurs de syntaxe, les violations des normes de codage et d'autres problèmes potentiels dans le code source.

* Notifications : Elles peuvent envoyer des notifications aux développeurs pour les informer des résultats des différentes étapes du processus d'intégration continue.

L'objectif principal est d'accélérer le processus de développement logiciel, d'identifier les erreurs le plus tôt possible et d'améliorer la qualité du code en encourageant une pratique de développement itérative et collaborative avec un feedback rapide et en vérifiant qu'il n'y ait pas de régression, ou d'autres problèmes.

### Pourquoi mettre en place une pipeline CI ?

Avantages :

* Détection rapide des erreurs : Les pipelines CI permettent de détecter les erreurs de code dès qu'elles sont introduites, ce qui permet de les corriger rapidement et réduit les risques de régressions.

* Amélioration de la qualité du code : Les tests automatisés et l'analyse statique du code contribuent à améliorer la qualité globale du code en identifiant les erreurs, les bugs et les violations des normes de codage.

* Collaboration renforcée : Les pipelines CI encouragent une pratique de développement collaborative en fournissant un environnement d'intégration continue où les développeurs peuvent facilement partager et intégrer leur code.

* Feedback immédiat : Les notifications automatiques fournissent un feedback immédiat aux développeurs sur l'état de leurs modifications, ce qui facilite la résolution rapide des problèmes.

Inconvénients :

* Complexité initiale : La mise en place et la configuration initiales d'une pipeline CI peuvent être complexes et nécessiter un investissement en temps et en ressources.

* Maintenance : Les pipelines CI nécessitent une maintenance continue pour s'assurer qu'ils restent efficaces et fonctionnent correctement avec l'évolution du projet.

* Surcharge de notifications : Les notifications fréquentes générées par les pipelines CI peuvent entraîner une surcharge d'informations pour les développeurs, ce qui peut les rendre moins réactifs aux véritables problèmes.

* Faux positifs : Les tests automatisés peuvent parfois générer des faux positifs, c'est-à-dire signaler des erreurs qui n'en sont pas réellement, ce qui peut entraîner une perte de confiance dans les pipelines CI.

* Dépendance à l'automatisation : Les pipelines CI reposent sur l'automatisation, ce qui signifie qu'ils peuvent ne pas convenir à tous les types de projets ou à toutes les équipes de développement, en particulier celles qui ont des besoins spécifiques ou des processus de développement moins standardisés.

## Mise en place de la pipeline CI

### Avec Github action

Il faut maintenant créer le fichier de la pipeline (le workflow), qui se situe dans un dossier .github/workflows, pour le nom j'ai choisie CI.yml
Comme avec ce [projet](https://github.com/drkaine/repas-en-avance/blob/main/.github/workflows/CI.yml) :

```
name: Pipeline-CI

on:
  push:
    branches: 
      - '*'

jobs:
  ci-front:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Setup Node.js
        uses: actions/setup-node@v2
        with:
          node-version: 16

      - name: Install dependencies
        run: npm install

      - name: Run Jest tests
        run: npm test

      # - name: Run ESLint
      #   run: npm run lint

  ci-back:
    runs-on: ubuntu-latest
    continue-on-error: false

    steps:
      - uses: shivammathur/setup-php@v2
        with:
          php-version: '8.2'

      - uses: actions/checkout@v2

      - uses: mirromutth/mysql-action@v1.1
        with:
          mysql database: laravel-test-db
          mysql user: laravel_test_user
          mysql password: example

      - name: Copy .env
        run: cp .env.example .env

      - name: Install composer Dependencies
        run: composer install -q --no-ansi --no-interaction --no-scripts --no-progress --prefer-dist

      - name: Laravel security-checker
        run: composer global require enlightn/security-checker

      - name: Setup Project
        run: |
          php artisan config:clear
          php artisan cache:clear
          php artisan key:generate

      - name: Run Unit tests
        env:
          APP_ENV: testing
          DB_CONNECTION: mysql
          DB_USERNAME: laravel_test_user
          DB_PASSWORD: super_secret
          DB_DATABASE: laravel_test_db
        run: php artisan test --testdox
      
      - name: PHP-CS-FIXER
        run: vendor/bin/php-cs-fixer fix --dry-run

      - name: PHPStan
        run: vendor/bin/phpstan
```

Pour une [expliction plus détaillé](/notes/github-action) du fichier au dessus.
Pour résumer, la pipeline recrée un environnement similaire, install toutes les dépendances, puis lance les tests automatisés, le linter et l'analyseur statique

### Conclusion
Maintenant il n'y a plus qu'à faire un commit et vérifier que la pipeline fonctionne et voir si les modifications sont bien mise en place.

On peut faire des pipelines plus compléte, les diviser en plusieurs workflows etc. Ce ne sont que des notes pour avoir les bases sur la mise en place d'une CI.

On peut rajouter un badge sur son répertoire Github qui montre l'état des dernière pipeline:
<div align="center">
    <img src="/img/notes/cd-github-action/badge.png" alt="Badge de status des pipeline" style="align-items: center;" width="100%"/>
</div>

Pour cela il faut aller dans l'onglet Actions workflow => le nom de la pipeline, là déploiement et sur les ... à côté du champs de recherche séléctionner "create status badge" puis le mettre dans le READ.ME.
<div align="center">
    <img src="/img/notes/cd-github-action/create-badge.png" alt="Emplacement du bouton de création de badge" style="align-items: center;" width="100%"/>
</div>