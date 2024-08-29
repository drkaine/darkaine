+++
title = "Clean Architecture"
date = 2024-08-29
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

# Qu'est-ce que la Clean Architecture?

La **Clean Architecture**, proposée par Robert C. Martin (aussi connu sous le nom d'Uncle Bob), est un modèle de conception logicielle qui vise à créer des systèmes logiciels maintenables, testables, et évolutifs. Elle est basée sur le principe de séparation des préoccupations, ce qui permet de structurer l'application en couches concentriques où chaque couche a une responsabilité spécifique et est indépendante des autres. L'idée centrale est de protéger la logique métier de l'application des détails d'implémentation comme les bases de données, les frameworks, ou les interfaces utilisateur.

### Structure de la Clean Architecture

La Clean Architecture est souvent représentée sous forme de cercles concentriques, où chaque couche interne est plus essentielle et moins dépendante des détails extérieurs. Les couches extérieures peuvent dépendre des couches intérieures, mais jamais l'inverse, un peu comme [l'architecture oignon](/notes/onion). Voici les principales couches de la Clean Architecture :

1. **Entités (Entities)** :
   - **Rôle** : Les entités sont au cœur de l'application. Ce sont des objets métier qui encapsulent les règles métier les plus générales et les plus réutilisables. Elles sont indépendantes des frameworks, des bases de données et des interfaces utilisateur.
   - **Exemples** : Classes comme `User`, `Order`, ou `Product`, qui contiennent la logique métier fondamentale.

2. **Cas d'utilisation (Use Cases ou Interactors)** :
   - **Rôle** : Cette couche contient les cas d'utilisation spécifiques à l'application. Les cas d'utilisation orchestrent les interactions entre les entités pour accomplir des tâches spécifiques. Ils définissent ce que l'application fait exactement, en termes de processus métier.
   - **Exemples** : Classes comme `CreateOrder`, `UpdateUserProfile`, qui orchestrent les règles métier pour répondre aux besoins spécifiques de l'utilisateur.

3. **Interface adaptateurs (Interface Adapters)** :
   - **Rôle** : Cette couche adapte les données d'un format à un autre pour permettre l'interaction entre les cas d'utilisation et les couches extérieures comme les bases de données, les interfaces utilisateur, ou les systèmes externes. Elle gère également les interfaces de conversion de données.
   - **Exemples** : Les contrôleurs (dans un MVC), les présentateurs (dans un modèle MVP), les gateways, les repositories.

4. **Cadres et pilotes (Frameworks & Drivers)** :
   - **Rôle** : Cette couche contient les détails d'implémentation tels que les frameworks, les bases de données, les systèmes de fichiers, et les API externes. Elle se situe à l'extérieur de l'architecture, car elle ne doit pas influencer les couches internes.
   - **Exemples** : Bases de données SQL/NoSQL, frameworks web (Django, Spring), bibliothèques externes, interfaces utilisateur.

### Les principes clés de la Clean Architecture

1. **Dépendance inversée** :
   - Les couches intérieures ne doivent pas dépendre des couches extérieures. Les dépendances doivent toujours pointer vers l'intérieur du cercle.

2. **Indépendance des frameworks** :
   - L'architecture doit être indépendante des frameworks utilisés. Les frameworks sont des outils qui aident à implémenter l'application, mais ils ne doivent pas dicter la structure du code.

3. **Testabilité** :
   - Le code doit être facilement testable. En isolant la logique métier des détails d'implémentation, il devient possible de tester la plupart des composants en isolation.

4. **Indépendance de l'interface utilisateur** :
   - Les détails concernant l'interface utilisateur (UI) doivent être isolés de la logique métier, permettant de changer d'interface sans affecter le cœur de l'application.

5. **Indépendance de la base de données** :
   - L'application ne doit pas être liée à une base de données spécifique. Les bases de données doivent être traitées comme des détails d'implémentation interchangeables.

### Avantages

- **Modularité** : La séparation en couches permet une meilleure organisation du code et facilite l'ajout de nouvelles fonctionnalités.
- **Testabilité** : La logique métier peut être testée indépendamment des couches externes.
- **Flexibilité** : Les détails d'implémentation (comme les frameworks ou les bases de données) peuvent être changés sans affecter le cœur de l'application.
- **Maintenabilité** : La structure claire permet de comprendre et de modifier le code plus facilement au fil du temps.

### Inconvénients

- **Complexité initiale** : La mise en place de la Clean Architecture peut être complexe et sembler excessive pour des projets de petite taille.
- **Courbe d'apprentissage** : Les développeurs doivent bien comprendre les principes de séparation des préoccupations et de dépendance inversée pour tirer le meilleur parti de cette architecture.
- **Verbosité** : La création de multiples couches, interfaces, et abstractions peut ajouter une certaine verbosité au code.

### Exemple concret

Prenons l'exemple d'une application de gestion des commandes :

- **Entités** : Classes comme `Order`, `Product`, qui encapsulent la logique métier essentielle comme la validation d'une commande ou le calcul du prix.
- **Cas d'utilisation** : Classe `ProcessOrder` qui orchestre la création d'une commande, la vérification des stocks, et l'enregistrement de la commande.
- **Interface adaptateurs** : Contrôleur `OrderController` qui reçoit les requêtes HTTP, convertit les données en objets de domaine, et appelle `ProcessOrder` pour traiter la commande.
- **Cadres et pilotes** : Implémentation d'un repository pour accéder à la base de données, comme `OrderRepositoryImpl` qui utilise une base de données SQL pour stocker les commandes.

### Conclusion

La Clean Architecture est un modèle puissant pour construire des applications évolutives et maintenables en mettant l'accent sur la séparation des préoccupations et en isolant la logique métier des détails d'implémentation. Elle est particulièrement adaptée aux projets complexes qui nécessitent une grande flexibilité, une testabilité élevée, et une maintenance sur le long terme. Cependant, elle peut être excessive pour des projets simples et requiert une bonne compréhension des concepts sous-jacents pour être implémentée efficacement.