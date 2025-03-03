+++
title = "Continuous Delivery (CD)"
date = 2025-03-01
draft = false

[taxonomies]
categories = ["DevOps"]
tags = ["CI/CD", "déploiement", "automatisation", "Darkaine"]

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

# Continuous Delivery (CD)

## Qu'est-ce que le Continuous Delivery ?

Le Continuous Delivery (CD), ou Livraison Continue en français, est une approche qui consiste à automatiser le processus de livraison de logiciels. L'objectif est de permettre aux équipes de développement de produire des logiciels dans des cycles courts, avec une grande fréquence, et de garantir que le code peut être déployé de manière fiable à tout moment.

Dans un pipeline de Continuous Delivery, chaque modification du code traverse une série d'étapes de test et de validation automatisées. À la fin du processus, l'application est prête à être déployée en production, mais le déploiement effectif reste une décision manuelle.

## Principes fondamentaux du Continuous Delivery

1. **Répétabilité et fiabilité** : Chaque étape du processus doit être automatisée pour garantir des résultats cohérents.
2. **Automatisation complète** : Tests, construction, validation et préparation au déploiement doivent être automatisés.
3. **Gestion de configuration** : L'environnement d'exécution doit être paramétrable et versionné (Infrastructure as Code).
4. **Visibilité et transparence** : Tous les membres de l'équipe doivent pouvoir voir l'état du système et les changements récents.
5. **Cycles courts** : Les mises à jour doivent être petites et fréquentes pour faciliter l'identification des problèmes.

## Différence entre Continuous Delivery et Continuous Deployment

Ces deux termes sont souvent confondus, mais ils représentent des approches distinctes :

### Continuous Delivery
- Le code passe par un pipeline automatisé de tests et de validation
- Le déploiement en production est **manuel** (décision humaine)
- Permet un contrôle final avant la mise en production
- L'équipe peut choisir **quand** déployer

```
Code → Tests → Build → Validation → Artefact prêt → Déploiement manuel
```

### Continuous Deployment
- Le code passe par le même pipeline automatisé
- Le déploiement en production est **automatique** si tous les tests passent
- Aucune intervention humaine n'est nécessaire
- Chaque changement validé est déployé en production

```
Code → Tests → Build → Validation → Déploiement automatique
```

La principale différence réside donc dans l'automatisation ou non de l'étape finale de déploiement en production.

## Les étapes typiques d'un pipeline de Continuous Delivery

1. **Intégration continue** : Compilation et tests unitaires à chaque commit
2. **Tests automatisés** : Exécution de tests fonctionnels, d'intégration, de performance
3. **Analyse de qualité** : Vérification du code par des outils d'analyse statique
4. **Déploiement en environnement de test** : Installation automatique sur un environnement similaire à la production
5. **Tests de validation** : Vérification du bon fonctionnement dans l'environnement de test
6. **Préparation au déploiement** : Création d'artefacts prêts pour la production
7. **Approbation manuelle** : Décision de déployer en production
8. **Déploiement en production** : Installation contrôlée de la nouvelle version

## Outils populaires pour le Continuous Delivery

### Orchestration de pipeline
- **Jenkins** : Outil open-source très flexible
- **GitLab CI/CD** : Intégré directement à GitLab
- **GitHub Actions** : Solution intégrée à GitHub
- **CircleCI** : Service cloud spécialisé
- **Travis CI** : Solution simple pour les projets open-source
- **Azure DevOps** : Suite complète de Microsoft

### Infrastructure as Code
- **Terraform** : Outil de provisionnement multi-cloud
- **Ansible** : Outil de configuration et d'automatisation
- **Puppet** et **Chef** : Outils de gestion de configuration

### Conteneurisation et orchestration
- **Docker** : Pour la conteneurisation des applications
- **Kubernetes** : Pour l'orchestration des conteneurs
- **Docker Compose** : Pour la définition d'applications multi-conteneurs

## Exemple de pipeline CI/CD avec GitHub Actions

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Set up PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.1'
          
      - name: Install dependencies
        run: composer install --prefer-dist --no-progress
        
      - name: Run tests
        run: vendor/bin/phpunit
        
      - name: Static analysis
        run: vendor/bin/phpstan analyse src
        
      - name: Build artifact
        run: |
          mkdir -p artifact
          cp -r src composer.json composer.lock artifact/
          cd artifact && composer install --no-dev --optimize-autoloader
          
      - name: Upload artifact
        uses: actions/upload-artifact@v2
        with:
          name: app-artifact
          path: artifact/

  deploy-staging:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/develop'
    steps:
      - name: Download artifact
        uses: actions/download-artifact@v2
        with:
          name: app-artifact
          
      - name: Deploy to staging
        run: |
          # Scripts de déploiement vers l'environnement de staging
          echo "Déploiement vers staging effectué"

  deploy-production:
    needs: [build, deploy-staging]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    environment:
      name: production
      url: https://www.example.com
    steps:
      - name: Download artifact
        uses: actions/download-artifact@v2
        with:
          name: app-artifact
          
      - name: Deploy to production
        # Cette étape pourrait nécessiter une approbation manuelle
        run: |
          # Scripts de déploiement vers production
          echo "Déploiement vers production effectué"
```

## Exemple de fichier de configuration GitLab CI/CD

```yaml
stages:
  - build
  - test
  - deploy_staging
  - deploy_production

build:
  stage: build
  script:
    - composer install
    - echo "Application construite"
  artifacts:
    paths:
      - vendor/
      - public/

test:
  stage: test
  script:
    - vendor/bin/phpunit
    - vendor/bin/phpstan analyse src
  dependencies:
    - build

deploy_staging:
  stage: deploy_staging
  script:
    - echo "Déploiement vers l'environnement de staging"
  environment:
    name: staging
    url: https://staging.example.com
  only:
    - develop
  dependencies:
    - build
    - test

deploy_production:
  stage: deploy_production
  script:
    - echo "Déploiement vers l'environnement de production"
  environment:
    name: production
    url: https://www.example.com
  when: manual  # Nécessite une approbation manuelle
  only:
    - main
  dependencies:
    - build
    - test
```

## Avantages du Continuous Delivery

1. **Réduction des risques** : Les déploiements plus petits et plus fréquents réduisent les risques d'erreurs.
2. **Détection précoce des problèmes** : Les bugs sont identifiés rapidement dans le cycle de développement.
3. **Feedback rapide** : Les développeurs reçoivent un retour immédiat sur leurs modifications.
4. **Time-to-market accéléré** : Les nouvelles fonctionnalités peuvent être livrées plus rapidement.
5. **Processus prévisible** : La standardisation rend le processus de livraison plus fiable.
6. **Meilleure qualité** : L'automatisation des tests améliore la qualité globale du code.

## Inconvénients et défis du Continuous Delivery

1. **Investissement initial important** : La mise en place d'un pipeline CD complet demande du temps et des ressources.
2. **Complexité technique** : La maintenance de l'infrastructure d'automatisation peut être complexe.
3. **Changement culturel** : Nécessite une adaptation des pratiques de travail des équipes.
4. **Couverture de tests** : Exige une bonne couverture de tests pour être efficace.
5. **Gestion des données** : La gestion des migrations de données peut être délicate.

## Bonnes pratiques pour le Continuous Delivery

1. **Commencer petit** : Automatiser d'abord les processus les plus critiques, puis étendre progressivement.
2. **Investir dans les tests** : Développer une stratégie de test complète (unitaires, intégration, UI, performance).
3. **Adopter le versionnement du code** : Utiliser Git et des stratégies de branchement adaptées.
4. **Infrastructure as Code** : Versionner les configurations d'infrastructure.
5. **Feature Flags** : Utiliser des drapeaux de fonctionnalités pour activer/désactiver des fonctionnalités en production.
6. **Surveillance et monitoring** : Mettre en place des outils de surveillance pour détecter rapidement les problèmes.
7. **Documentation continue** : Maintenir une documentation à jour du processus et de l'architecture.

## Conclusion

Le Continuous Delivery représente une évolution significative dans la façon dont les logiciels sont développés et livrés. En automatisant les processus de test et de validation, les équipes peuvent livrer des logiciels de meilleure qualité, plus rapidement et avec moins de risques.

Contrairement au Continuous Deployment, le CD maintient une étape d'approbation manuelle avant le déploiement en production, offrant ainsi un équilibre entre automatisation et contrôle. Cette approche est particulièrement adaptée aux organisations qui ont besoin d'une validation finale avant de mettre à jour leurs applications critiques.

La mise en place d'une stratégie de Continuous Delivery est un investissement qui porte ses fruits sur le long terme, en améliorant l'efficacité des équipes et la qualité des logiciels produits.

## Ressources

- [Continuous Delivery: Reliable Software Releases through Build, Test, and Deployment Automation](https://www.oreilly.com/library/view/continuous-delivery-reliable/9780321670250/) par Jez Humble et David Farley
- [The DevOps Handbook](https://itrevolution.com/product/the-devops-handbook-second-edition/) par Gene Kim, Jez Humble, Patrick Debois et John Willis
- [Accélération: The Science of Lean Software and DevOps](https://itrevolution.com/product/accelerate/) par Nicole Forsgren, Jez Humble et Gene Kim
- [Martin Fowler sur Continuous Delivery](https://martinfowler.com/bliki/ContinuousDelivery.html)
- [CD Foundation](https://cd.foundation/) 