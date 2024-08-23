+++
title = "Architecture monolithique"
date = 2024-08-22
draft = false

[taxonomies]
categories = ["Architecture"]
tags = ["architecture", "Darkaine"]

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

# Introduction à l'Architecture monolithique

Un **monolith** (ou architecture monolithique) désigne un type d'architecture logicielle où toutes les composantes d'une application sont intégrées dans un seul bloc unifié. Dans ce contexte, toutes les fonctionnalités de l'application — qu'il s'agisse de l'interface utilisateur, de la logique métier, ou des accès aux bases de données — sont regroupées dans un même programme ou un même ensemble de fichiers.

### Caractéristiques d'une architecture monolithique

1. **Un seul déploiement** : Tout le code est déployé ensemble. Si une seule petite partie du code doit être modifiée, l'ensemble de l'application doit être re-déployé.
  
2. **Couplage fort** : Les différentes composantes du logiciel sont fortement interconnectées, ce qui signifie que les changements dans une partie du code peuvent avoir des effets imprévus sur d'autres parties.

3. **Développement simplifié au départ** : Dans les premières phases de développement, l'architecture monolithique peut simplifier les choses, car il n'y a qu'une seule base de code à gérer.

4. **Test et gestion centralisée** : Les tests peuvent être effectués sur l'ensemble du système à la fois, ce qui peut simplifier les tests d'intégration.

### Avantages

- **Simplicité initiale** : Facilité de développement pour les petites équipes ou les projets qui débutent.
- **Performance** : En raison de l'absence de communication sur un réseau entre différents services, les performances peuvent être meilleures dans un environnement monolithique, surtout lorsqu'il s'agit de transactions internes.

### Inconvénients

- **Scalabilité limitée** : Il est difficile de scaler indépendamment les différentes parties d'une application. Si une partie de l'application nécessite plus de ressources, il faut souvent redimensionner l'ensemble du monolithe.
- **Complexité accrue avec le temps** : À mesure que l'application grandit, la gestion du code devient de plus en plus complexe.
- **Déploiement risqué** : Le déploiement d'une nouvelle version de l'application est risqué, car une petite erreur peut potentiellement affecter l'ensemble de l'application.
- **Ralentissement des équipes** : Plusieurs équipes peuvent être amenées à travailler sur la même base de code, ce qui peut entraîner des conflits et ralentir le développement.

### Exemple concret

Supposons qu'on développes une application de commerce en ligne. Dans une architecture monolithique, tout le code — la gestion des utilisateurs, le catalogue de produits, les paiements, et la gestion des commandes — serait regroupé dans une seule et même application. Si tu dois apporter une modification au module de paiement, tu devras re-déployer l'intégralité de l'application, ce qui peut poser des problèmes de disponibilité et de fiabilité.

### Alternatives à l'architecture monolithique

Avec l'essor des applications web complexes et la nécessité de scalabilité, l'architecture monolithique est souvent remplacée par une architecture **microservices**. Dans cette approche, chaque fonction ou service de l'application est développé, déployé et maintenu de manière indépendante. Cela permet une plus grande flexibilité, mais au prix d'une complexité accrue en termes de gestion et de communication entre les services.

### Conclusion

Le choix entre une architecture monolithique et une [architecture microservices](/notes/micro-services) dépend des besoins spécifiques du projet, de l'équipe, et de la vision à long terme du logiciel. Pour des projets de petite taille ou au démarrage, un monolithe peut être parfaitement adapté. Cependant, pour des applications complexes qui nécessitent de la scalabilité et une grande flexibilité, une approche basée sur les microservices peut être plus appropriée.