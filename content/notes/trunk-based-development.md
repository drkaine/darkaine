+++
title = "Trunk-Based Development"
date = 2025-03-06
draft = false

[taxonomies]
categories = ["Développement"]
tags = ["git", "workflow", "branches", "Darkaine", "CI/CD"]

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

# Trunk-Based Development

## Qu'est-ce que le Trunk-Based Development ?

Le Trunk-Based Development (TBD) est un modèle de gestion de branches Git où les développeurs collaborent sur un seul tronc (trunk) ou branche principale, généralement appelée `main` ou `master`. Dans cette approche, les développeurs créent des branches de courte durée à partir du tronc principal pour développer des fonctionnalités ou corriger des bugs, puis les fusionnent rapidement (généralement en moins d'une journée) dans le tronc.

Cette méthode se distingue par sa simplicité et sa focalisation sur l'intégration continue. Elle favorise des cycles de développement courts et des déploiements fréquents, ce qui en fait une approche particulièrement bien adaptée aux pratiques DevOps et aux environnements CI/CD.

## Principes fondamentaux du Trunk-Based Development

1. **Une seule branche principale** : Tous les développeurs travaillent à partir d'une branche principale unique.
2. **Intégration fréquente** : Les changements sont intégrés au tronc principal plusieurs fois par jour.
3. **Branches de courte durée** : Les branches de fonctionnalités sont petites et vivent rarement plus d'une journée.
4. **Tests automatisés** : Une suite de tests complète garantit la stabilité du tronc.
5. **Déploiement continu** : Le code du tronc est toujours déployable.

## Flux de travail typique en Trunk-Based Development

### Développement d'une petite fonctionnalité

```
1. Mise à jour du tronc local
   git checkout main
   git pull

2. Création d'une branche de courte durée
   git checkout -b feature-xyz

3. Développement avec commits fréquents
   [travail, commits, etc.]

4. Tests locaux
   [exécution des tests]

5. Mise à jour avec le tronc (si nécessaire)
   git checkout main
   git pull
   git checkout feature-xyz
   git rebase main

6. Fusion dans le tronc
   git checkout main
   git merge feature-xyz

7. Suppression de la branche
   git branch -d feature-xyz
```

### Développement d'une fonctionnalité plus importante

Pour les fonctionnalités qui nécessitent plusieurs jours de développement, deux approches sont possibles :

#### 1. Feature Flags (recommandée)

```
1. Développement directement sur le tronc avec un feature flag
   git checkout main
   
2. Ajout du code avec feature flag désactivé
   [développement du code]
   
3. Commits et push fréquents
   git commit -m "Ajout de la fonctionnalité XYZ (désactivée)"
   git push
   
4. Activation du feature flag lorsque la fonctionnalité est prête
   [modification du flag]
   git commit -m "Activation de la fonctionnalité XYZ"
   git push
```

#### 2. Feature Branches (alternative)

```
1. Création d'une branche de fonctionnalité
   git checkout -b feature-xyz
   
2. Synchronisation fréquente avec le tronc
   git checkout main
   git pull
   git checkout feature-xyz
   git rebase main
   
3. Fusion dans le tronc dès que possible
   git checkout main
   git merge feature-xyz
```

## Feature Flags : composant essentiel du Trunk-Based Development

Les feature flags (ou feature toggles) sont des interrupteurs dans le code qui permettent d'activer ou désactiver des fonctionnalités sans déployer de nouveau code. Ils sont essentiels au Trunk-Based Development pour plusieurs raisons :

1. **Fonctionnalités incomplètes** : Ils permettent d'intégrer du code incomplet dans le tronc sans affecter les utilisateurs.
2. **Tests A/B** : Possibilité d'activer une fonctionnalité pour un sous-ensemble d'utilisateurs.
3. **Rollback facile** : En cas de problème, la fonctionnalité peut être désactivée sans déploiement.

### Exemple de Feature Flag en PHP

```php
class FeatureFlags {
    private static $flags = [
        'new_ui' => false,
        'advanced_search' => true,
        'beta_feature' => false
    ];
    
    public static function isEnabled(string $featureName): bool {
        return isset(self::$flags[$featureName]) && self::$flags[$featureName];
    }
}

// Utilisation
if (FeatureFlags::isEnabled('advanced_search')) {
    // Afficher la recherche avancée
} else {
    // Afficher la recherche standard
}
```

### Exemple de Feature Flag en Go

```go
package featureflags

var flags = map[string]bool{
    "new_ui":          false,
    "advanced_search": true,
    "beta_feature":    false,
}

func IsEnabled(featureName string) bool {
    enabled, exists := flags[featureName]
    return exists && enabled
}

// Utilisation
if featureflags.IsEnabled("advanced_search") {
    // Afficher la recherche avancée
} else {
    // Afficher la recherche standard
}
```

## Avantages du Trunk-Based Development

1. **Simplicité** : Modèle facile à comprendre et à mettre en œuvre.
2. **Réduction des conflits de fusion** : Les intégrations fréquentes réduisent les conflits complexes.
3. **CI/CD optimisé** : Parfaitement adapté à l'intégration continue et au déploiement continu.
4. **Feedback rapide** : Les bugs sont identifiés rapidement grâce à l'intégration fréquente.
5. **Meilleure collaboration** : Tous les développeurs travaillent sur la même base de code.
6. **Visibilité** : Les progrès sont visibles immédiatement dans le tronc principal.

## Inconvénients du Trunk-Based Development

1. **Discipline requise** : Nécessite une grande discipline d'équipe pour maintenir la stabilité du tronc.
2. **Infrastructure de tests** : Exige une infrastructure de tests solide et fiable.
3. **Feature flags** : La gestion des feature flags peut devenir complexe avec le temps.
4. **Moins adapté aux équipes distribuées** : Peut être difficile à mettre en œuvre avec des équipes très distribuées.
5. **Gestion de versions** : Plus difficile de maintenir plusieurs versions en production.

## Comparaison avec d'autres modèles

### Trunk-Based Development vs GitFlow

**GitFlow** est plus structuré et complexe :
- Multiples branches à longue durée de vie (develop, master, release, etc.)
- Processus formalisé pour les fonctionnalités, releases et hotfixes
- Adapté aux cycles de release planifiés

**Trunk-Based Development** est plus simple :
- Une seule branche principale
- Intégration continue et fréquente
- Adapté au déploiement continu

### Trunk-Based Development vs GitHub Flow

**GitHub Flow** est un modèle intermédiaire :
- Une branche principale
- Branches de fonctionnalités qui peuvent durer plus longtemps
- Pull requests pour réviser le code avant fusion
- Déploiement après chaque fusion dans la branche principale

**Trunk-Based Development** est plus strict :
- Branches très courtes (généralement < 1 jour)
- Intégration plusieurs fois par jour
- Usage intensif des feature flags

## Cas d'utilisation appropriés pour le Trunk-Based Development

Le Trunk-Based Development est particulièrement adapté pour :

1. **Équipes DevOps** : Organisations pratiquant l'intégration continue et le déploiement continu.
2. **Applications SaaS** : Services web avec déploiements fréquents.
3. **Startups** : Environnements nécessitant une itération rapide.
4. **Équipes co-localisées** : Équipes travaillant ensemble et communiquant facilement.
5. **Produits avec une seule version active** : Applications qui n'ont pas besoin de maintenir plusieurs versions.

À l'inverse, le TBD n'est généralement pas recommandé pour :

1. **Logiciels avec versions multiples** : Produits nécessitant le support de plusieurs versions en parallèle.
2. **Équipes très distribuées** : Sans bonne communication et coordination.
3. **Projets sans tests automatisés** : La qualité du tronc dépend fortement des tests.

## Bonnes pratiques pour le Trunk-Based Development

1. **Tester, tester, tester** : Investir dans des tests automatisés complets (unitaires, intégration, UI).
2. **Intégration continue** : Configurer un pipeline CI qui s'exécute sur chaque commit.
3. **Petits commits** : Privilégier les petits changements fréquents plutôt que les grosses modifications.
4. **Revue de code** : Mettre en place un processus de revue de code efficace.
5. **Gestion des feature flags** : Créer un système robuste pour gérer les feature flags et nettoyer ceux qui ne sont plus nécessaires.
6. **Monitoring** : Surveiller étroitement les déploiements pour détecter rapidement les problèmes.
7. **Pair programming** : Encourager le développement en binôme pour améliorer la qualité du code.

## Outils facilitant le Trunk-Based Development

1. **Outils CI/CD** : Jenkins, CircleCI, GitHub Actions, GitLab CI
2. **Gestionnaires de feature flags** : LaunchDarkly, Split.io, Flagsmith
3. **Outils de revue de code** : GitHub Pull Requests, GitLab Merge Requests
4. **Tests automatisés** : Jest, PHPUnit, Go testing package, Cypress
5. **Monitoring** : Datadog, New Relic, Prometheus

## Exemple de configuration CI pour Trunk-Based Development (GitHub Actions)

```yaml
name: CI Pipeline

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup
        run: npm install
        
      - name: Run linter
        run: npm run lint
        
      - name: Run unit tests
        run: npm run test:unit
        
      - name: Run integration tests
        run: npm run test:integration
        
  deploy:
    needs: test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup
        run: npm install
        
      - name: Build
        run: npm run build
        
      - name: Deploy
        run: |
          # Script de déploiement automatique
          echo "Déploiement de la nouvelle version"
```

## Transition vers le Trunk-Based Development

Pour passer d'un autre modèle (comme GitFlow) au Trunk-Based Development :

1. **Améliorer les tests** : Augmenter la couverture des tests automatisés.
2. **Mettre en place un pipeline CI/CD** : Automatiser les tests et le déploiement.
3. **Implémenter les feature flags** : Créer l'infrastructure nécessaire pour les feature flags.
4. **Former l'équipe** : S'assurer que toute l'équipe comprend les principes du TBD.
5. **Commencer progressivement** : Débuter avec de petites fonctionnalités avant de passer aux plus complexes.
6. **Mesurer les progrès** : Suivre des métriques comme la fréquence des déploiements et le temps de cycle.

## Conclusion

Le Trunk-Based Development est un modèle de gestion de branches qui privilégie la simplicité et l'intégration continue. En encourageant des intégrations fréquentes dans le tronc principal et l'utilisation de feature flags, cette approche accélère le développement et facilite le déploiement continu.

Bien que ce modèle exige une grande discipline et une infrastructure de tests robuste, ses avantages en termes de rapidité, de collaboration et de stabilité en font un choix de plus en plus populaire pour les équipes modernes pratiquant l'Agile et le DevOps.

Le Trunk-Based Development n'est pas adapté à tous les projets, mais pour les équipes cherchant à optimiser leur pipeline de livraison et à réduire le temps entre l'écriture du code et son déploiement en production, il représente une alternative séduisante aux modèles plus complexes comme GitFlow.

## Ressources

- [Trunk Based Development](https://trunkbaseddevelopment.com/) - Site de référence sur le sujet
- [Feature Toggles (aka Feature Flags)](https://martinfowler.com/articles/feature-toggles.html) par Martin Fowler
- [Continuous Delivery](https://continuousdelivery.com/) par Jez Humble
- [Accelerate: Building and Scaling High Performing Technology Organizations](https://itrevolution.com/book/accelerate/) par Nicole Forsgren, Jez Humble et Gene Kim
- [DevOps Handbook](https://itrevolution.com/book/the-devops-handbook/) par Gene Kim, Jez Humble, Patrick Debois et John Willis 