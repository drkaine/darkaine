+++
title = "Architecture Oignon"
date = 2024-08-27
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

# Introduction à l'Architecture Oignon

L'**architecture en oignon** (ou **Onion Architecture**) est un modèle de conception logicielle qui met l'accent sur une organisation claire des dépendances et des responsabilités, en plaçant le cœur du système au centre de l'architecture et en construisant autour de celui-ci en couches concentriques. Ce modèle vise à créer des systèmes robustes et facilement testables en limitant les dépendances entre les différentes parties de l'application.

### Structure de l'architecture en oignon

L'architecture en oignon est généralement composée de plusieurs couches disposées autour d'un noyau central. Chaque couche extérieure peut dépendre des couches intérieures, mais les couches intérieures ne dépendent jamais des couches extérieures. Cela garantit que les aspects essentiels de l'application, comme la logique métier, ne sont pas influencés par des détails de mise en œuvre comme les frameworks ou les bases de données.

1. **Noyau central (Core)** :
   - **Rôle** : Contient les éléments les plus fondamentaux de l'application, notamment les entités de domaine (les objets métiers) et les interfaces. Cette couche est totalement indépendante des frameworks et des détails d'implémentation.
   - **Exemples** : Classes représentant les objets métiers (comme `Order`, `Customer`), interfaces pour les services métiers.

2. **Couche de services (Application Services)** :
   - **Rôle** : Contient la logique métier de l'application, les règles métiers, les services qui orchestrent les actions sur les entités de domaine. Elle implémente les interfaces définies dans le noyau central.
   - **Exemples** : Services métier (`OrderService`, `CustomerService`), gestion des cas d'utilisation (use cases).

3. **Couche d'infrastructure (Infrastructure)** :
   - **Rôle** : Cette couche contient des implémentations concrètes des interfaces définies dans les couches internes, comme les services d'accès aux données, les bibliothèques externes, ou les API externes. Elle gère aussi les frameworks spécifiques.
   - **Exemples** : Repositories, systèmes de persistance, gestion des dépendances externes, implémentations de l'accès aux bases de données.

4. **Couche d'interface utilisateur (UI ou Presentation)** :
   - **Rôle** : Contient tout ce qui concerne l'interaction utilisateur, comme les interfaces graphiques, les API REST, ou les applications web. Cette couche dépend des couches de service pour exécuter des actions et afficher des données.
   - **Exemples** : Interfaces web (Angular, React), applications mobiles, contrôleurs MVC.

### Avantages

- **Isolation de la logique métier** : La logique métier est isolée des préoccupations techniques et des dépendances externes, ce qui permet de la tester plus facilement et de la réutiliser.
- **Flexibilité** : L'architecture en oignon permet de changer les couches extérieures sans affecter le noyau central. Par exemple, on peut changer le système de persistance ou le framework UI sans toucher à la logique métier.
- **Testabilité** : Les couches internes, comme la logique métier, peuvent être testées de manière isolée, car elles ne dépendent pas des détails d'implémentation comme les bases de données ou les frameworks.

### Inconvénients

- **Complexité initiale** : L'établissement de cette architecture peut être complexe, surtout pour des projets simples ou pour des équipes peu familiarisées avec ce modèle.
- **Verbosité** : Le besoin de définir des interfaces et des abstractions peut entraîner une certaine verbosité dans le code, surtout pour des applications où cela pourrait ne pas être strictement nécessaire.
- **Inversion des dépendances** : Il peut être difficile pour les développeurs d'adopter et de bien comprendre l'inversion des dépendances (Dependency Inversion Principle), qui est au cœur de cette architecture.

### Exemple concret

Imaginons une application de gestion de commandes :

- **Noyau central** : Contient les entités `Order`, `Product`, et les interfaces comme `IOrderRepository`, qui ne dépendent d'aucun framework.
- **Couche de services** : Implémente la logique métier comme `OrderService`, qui utilise l'interface `IOrderRepository` pour effectuer des opérations sur les commandes.
- **Couche d'infrastructure** : Contient l'implémentation concrète de `IOrderRepository`, qui pourrait utiliser une base de données SQL pour stocker les commandes.
- **Couche d'interface utilisateur** : Comprend une application web en Angular qui interagit avec `OrderService` via une API REST pour afficher et gérer les commandes.

### Conclusion

L'architecture en oignon est une approche puissante pour construire des applications modulaires, maintenables, et testables, en plaçant la logique métier au centre et en isolant cette logique des préoccupations techniques. Cette architecture est particulièrement adaptée aux projets complexes où la flexibilité et la testabilité sont cruciales. Cependant, elle peut introduire une complexité inutile pour les projets plus simples ou pour les équipes qui ne sont pas encore familières avec ce modèle.