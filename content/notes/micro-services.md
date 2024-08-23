+++
title = "Architecture microservices"
date = 2024-08-23
draft = false

[taxonomies]
categories = ["Architecture"]
tags = ["aarchitecture", "Darkaine"]

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
# Introduction à l'Architecture microservices


### Qu'est-ce qu'une architecture microservices?

L'architecture **microservices** est une approche de conception logicielle dans laquelle une application est décomposée en une collection de petits services indépendants, chacun étant responsable d'une seule fonction ou d'un ensemble de fonctionnalités spécifiques. Contrairement à une [architecture monolithique](/notes/monolith), où toutes les fonctionnalités sont regroupées dans un seul bloc, les microservices permettent de développer, déployer et maintenir chaque composant indépendamment.

### Caractéristiques d'une architecture microservices

1. **Indépendance des services** : Chaque microservice est une application autonome qui gère un ensemble spécifique de fonctionnalités. Ils peuvent être développés, testés et déployés indépendamment les uns des autres.

2. **Communication via API** : Les microservices communiquent entre eux via des API (souvent REST ou gRPC), ce qui permet une grande flexibilité dans la manière dont les services interagissent.

3. **Polyglottisme technologique** : Chaque microservice peut être développé dans un langage de programmation ou une technologie différente, ce qui permet de choisir l'outil le plus adapté à chaque tâche.

4. **Déploiement indépendant** : Les équipes peuvent déployer les microservices individuellement, sans affecter le reste du système, ce qui permet une mise à jour plus fréquente et un déploiement plus sûr.

5. **Scalabilité granulaire** : Les microservices peuvent être scalés indépendamment, ce qui permet d'allouer des ressources spécifiques à des parties de l'application qui en ont le plus besoin.

### Avantages

- **Modularité et flexibilité** : Chaque service est modulaire, ce qui facilite les modifications et l'ajout de nouvelles fonctionnalités sans affecter l'ensemble du système.
- **Scalabilité** : Chaque microservice peut être scalé de manière indépendante, ce qui permet d'optimiser les ressources.
- **Résilience** : Un échec dans un microservice ne met pas nécessairement en danger l'ensemble de l'application, car les autres services peuvent continuer à fonctionner.
- **Déploiement rapide et continu** : Les équipes peuvent mettre à jour et déployer leurs services sans attendre que l'ensemble du système soit prêt.
- **Gestion d'équipe** : Les services étant indépendant, il est plus simple de découper les tâches entre les équipes que sur un monolith ou il peut y avoir des conflits.

### Inconvénients

- **Complexité accrue** : La gestion de nombreux services indépendants peut devenir complexe, nécessitant des outils de gestion avancés pour l'orchestration et la surveillance.
- **Communication entre services** : La communication entre microservices introduit une latence réseau et peut entraîner des problèmes de fiabilité.
- **Débogage difficile** : Localiser la source d'un problème dans un environnement de microservices peut être plus complexe que dans un système monolithique.
- **Gestion des données distribuées** : Les données peuvent être dispersées entre plusieurs microservices, ce qui complique la gestion de la cohérence des données.
- **Communication inter-équipe** : Chaque service peut être développé par une équipe différente, ce qui peut amener des problèmes de communication, une route qui change de fonctionnement ou de nom sont que les clients soient au courant etc.

### Exemple concret

Imaginons une application de commerce en ligne conçue en utilisant une architecture microservices. Les différentes fonctionnalités telles que la gestion des utilisateurs, le catalogue de produits, les paiements, et la gestion des commandes sont chacune implémentées comme des microservices distincts. Par exemple, le service de paiement pourrait être développé en Python, tandis que le catalogue de produits pourrait être développé en Java. Si on doit modifier le service de paiement, on peut le déployer sans affecter le reste de l'application.

### Défis courants

- **Orchestration** : Gérer la coordination entre plusieurs services, par exemple avec un outil comme Kubernetes.
- **Surveillance et traçage** : Surveiller les performances et tracer les erreurs à travers de multiples microservices nécessite des outils spécialisés.
- **Gestion des versions** : Assurer la compatibilité entre différentes versions de microservices peut devenir complexe.
- **Gestion des services** : Assurer le suivies des équipes et des services d'un point de vue projet/produit pour assurer une cohérence dans l'avancement du produit final.

### Conclusion

L'architecture microservices est particulièrement adaptée aux grandes applications nécessitant une évolutivité et une flexibilité élevée. Elle permet de répondre rapidement aux besoins changeants du marché en déployant des modifications de manière isolée. Cependant, elle n'est pas sans défis, notamment en termes de complexité et de gestion. Le choix entre une  [architecture monolithique](/notes/monolith) et une architecture microservices dépend du contexte de développement, des besoins spécifiques du projet, et de la capacité de l'équipe à gérer cette complexité.