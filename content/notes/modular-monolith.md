+++
title = "Architecture Modular Monolith"
date = 2025-03-02
draft = false

[taxonomies]
categories = ["Architecture"]
tags = ["architecture", "microservices", "Darkaine"]

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

# Architecture Modular Monolith

## Définition

Un **Modular Monolith** est une approche architecturale qui combine les caractéristiques d'un monolithe traditionnel avec une structure modulaire bien définie. Il s'agit d'une application unique déployée comme un seul artefact, mais dont les composants internes sont organisés en modules indépendants avec des frontières explicites.

## Différences avec un monolithe classique

| Monolithe Classique | Monolithe Modulaire |
|---------------------|---------------------|
| Structure interne souvent désorganisée | Modules clairement délimités avec frontières explicites |
| Couplage fort entre composants | Couplage faible entre modules |
| Dépendances internes implicites | Dépendances entre modules explicites et contrôlées |
| Code généralement organisé par couches techniques | Code organisé par domaines métier |
| Difficulté à établir des limites de responsabilité | Responsabilités clairement définies par module |

## Points positifs

- **Simplicité de déploiement** : Comme pour un [monolithe](/notes/monolith) classique, un seul artefact à déployer
- **Performance** : Pas de latence réseau entre les modules comme dans une architecture [microservices](/notes/microservices)
- **Gouvernance graduelle** : Possibilité d'établir progressivement les règles de modularité
- **Chemin vers les microservices** : Facilite une éventuelle migration future vers des microservices
- **Testabilité** : Les modules bien délimités sont plus faciles à tester isolément
- **Développement parallèle** : Les équipes peuvent travailler sur différents modules simultanément
- **Maintenabilité améliorée** : Chaque module peut évoluer indépendamment tant que les interfaces publiques sont respectées

## Points négatifs

- **Discipline requise** : Nécessite une rigueur constante pour maintenir les frontières entre modules
- **Complexité d'organisation** : Structure de code plus sophistiquée qu'un monolithe simple
- **Risque de dérive** : Sans gouvernance stricte, peut dégénérer en "monolithe spaghetti"
- **Scalabilité limitée** : Reste une application unique du point de vue des ressources (contrairement aux microservices)
- **Déploiement monolithique** : Un changement dans un module nécessite toujours le déploiement complet

## Implémentation

### Exemple en Go

```go
// Structure de projet
monolith/
  ├── clients/
  │     ├── api/           // API publique du module
  │     │     └── service.go
  │     ├── internal/      // Implémentation interne (privée)
  │     │     └── repository.go
  │     └── module.go      // Initialisation du module
  ├── products/
  │     ├── api/
  │     ├── internal/
  │     └── module.go
  ├── orders/
  │     ├── api/
  │     ├── internal/
  │     └── module.go
  └── shared/             // Composants partagés
        └── infrastructure/
```

```go
// clients/api/service.go
package clientapi

type Client struct {
    ID   string
    Name string
    // ...
}

type ClientService interface {
    FindByID(id string) (*Client, error)
    Save(client *Client) error
}

// clients/internal/service.go
package clientinternal

import (
    "monolith/clients/api"
)

type clientService struct {
    repository Repository
}

func NewClientService(repo Repository) api.ClientService {
    return &clientService{
        repository: repo,
    }
}

func (s *clientService) FindByID(id string) (*api.Client, error) {
    // Implémentation
}

// Dans le module orders qui dépend de clients
// orders/internal/service.go
package orderinternal

import (
    clientapi "monolith/clients/api"
)

type OrderService struct {
    clientService clientapi.ClientService
}

func NewOrderService(clientService clientapi.ClientService) *OrderService {
    return &OrderService{
        clientService: clientService,
    }
}

func (s *OrderService) CreateOrder(order *Order) error {
    // Utilise uniquement l'API publique du module clients
    client, err := s.clientService.FindByID(order.ClientID)
    if err != nil {
        return err
    }
    // ...
}
```

### Exemple en JavaScript (Node.js)

```javascript
// Structure de projet
monolith/
  ├── modules/
  │     ├── clients/
  │     │     ├── api.js         // API publique du module
  │     │     ├── internal/      // Implémentation interne (privée)
  │     │     │     └── repository.js
  │     │     └── index.js       // Point d'entrée du module
  │     ├── products/
  │     │     ├── api.js
  │     │     ├── internal/
  │     │     └── index.js
  │     └── orders/
  │           ├── api.js
  │           ├── internal/
  │           └── index.js
  └── shared/                   // Composants partagés
        └── infrastructure/
```

```javascript
// modules/clients/api.js
class Client {
  constructor(id, name) {
    this.id = id;
    this.name = name;
  }
}

// Interface publique du module clients
module.exports = {
  Client,
  // Service abstrait (interface)
  ClientService: class ClientService {
    async findById(id) { throw new Error('Not implemented'); }
    async save(client) { throw new Error('Not implemented'); }
  }
};

// modules/clients/internal/service.js
const { Client, ClientService } = require('../api');

class ClientServiceImpl extends ClientService {
  constructor(repository) {
    super();
    this.repository = repository;
  }

  async findById(id) {
    // Implémentation
    const data = await this.repository.findById(id);
    return new Client(data.id, data.name);
  }

  async save(client) {
    // Implémentation
  }
}

// modules/clients/index.js
const { Client, ClientService } = require('./api');
const { ClientServiceImpl } = require('./internal/service');
const { ClientRepository } = require('./internal/repository');

function initModule(container) {
  const repository = new ClientRepository(container.get('database'));
  container.register('clientService', new ClientServiceImpl(repository));
}

module.exports = {
  initModule,
  // Exposer uniquement l'API publique
  api: { Client, ClientService }
};

// modules/orders/internal/service.js
class OrderService {
  constructor(clientService) {
    this.clientService = clientService;
  }

  async createOrder(order) {
    // Utilise uniquement l'API publique du module clients
    const client = await this.clientService.findById(order.clientId);
    // ...
  }
}

// modules/orders/index.js
function initModule(container) {
  // Injection de dépendance entre modules
  const clientService = container.get('clientService');
  container.register('orderService', new OrderService(clientService));
}
```

## Techniques de modularisation

1. **Modules par domaine métier** : Organisation selon les sous-domaines (DDD)
2. **Modules par équipe** : Alignement sur la structure organisationnelle
3. **Modules par cycle de vie** : Regroupement des composants qui évoluent ensemble

## Outils et frameworks

- **Go** : Packages Go avec interfaces explicites, wire pour l'injection de dépendances
- **JavaScript** : Monorepos avec Lerna, Nx, ou Turborepo, modules ES
- **TypeScript** : Namespaces, modules avec visibilité, NestJS avec ses modules
- **Java** : Java Platform Module System (JPMS), Maven/Gradle multi-modules
- **.NET** : Solution avec plusieurs projets, internal/public visibility

## Cas d'usage idéals

- Applications d'entreprise complexes nécessitant une évolution progressive
- Équipes souhaitant améliorer leur architecture sans adopter immédiatement les microservices
- Systèmes où les coûts opérationnels des microservices ne se justifient pas
- Applications avec des domaines métier clairs mais fortement interdépendants

## Exemples réels

Shopify, GitHub et Etsy ont tous utilisé des approches monolithiques modulaires pour leurs applications principales, leur permettant de gérer la complexité tout en maintenant la simplicité opérationnelle d'un déploiement unique.

## Conclusion

Le Monolithe Modulaire représente un compromis architectural efficace entre la simplicité d'un monolithe classique et la flexibilité des microservices. Il permet d'obtenir une grande partie des avantages de la modularité sans la complexité opérationnelle des architectures distribuées.

Cette approche requiert cependant une discipline de développement et une gouvernance technique rigoureuse pour maintenir les frontières entre modules et éviter les dépendances circulaires qui dégraderaient la qualité de l'architecture au fil du temps.

## Ressources

### Livres

- **Building Evolutionary Architectures** par Neal Ford, Rebecca Parsons et Patrick Kua - Un ouvrage qui explore comment créer des architectures qui peuvent évoluer au fil du temps, avec des chapitres dédiés à la modularité.
- **Monolith to Microservices** par Sam Newman - Bien que centré sur la migration vers les microservices, ce livre aborde en profondeur l'approche du monolithe modulaire comme étape intermédiaire.
- **Clean Architecture** par Robert C. Martin - Présente des principes qui s'appliquent parfaitement à l'organisation d'un monolithe modulaire.

### Articles & Blogs

- [**Modular Monoliths**](https://www.kamilgrzybek.com/design/modular-monolith-primer/) par Kamil Grzybek - Une série d'articles détaillant les principes et l'implémentation de monolithes modulaires.
- [**Shopify's Journey to Modularity**](https://engineering.shopify.com/blogs/engineering/deconstructing-monolith-designing-software-maximizes-developer-productivity) - Comment Shopify a restructuré son monolithe Ruby en un système modulaire.
- [**The Majestic Monolith**](https://m.signalvnoise.com/the-majestic-monolith/) par David Heinemeier Hansson - Un plaidoyer pour les monolithes bien conçus par le créateur de Ruby on Rails.

### Conférences & Présentations

- [**Modular Monoliths**](https://www.youtube.com/watch?v=5OjqD-ow8GE) par Simon Brown - Une présentation clé sur l'approche, avec des exemples concrets et des stratégies.
- [**Decomposing a Monolith**](https://www.youtube.com/watch?v=9I9GdSQ1bbM) par Sam Newman - Techniques pour découper un monolithe existant en modules cohérents.

### Outils & Frameworks

- [**ArchUnit**](https://www.archunit.org/) - Un outil pour vérifier et faire respecter les frontières architecturales dans une application Java.
- [**NestJS**](https://nestjs.com/) - Un framework Node.js qui encourage une architecture modulaire.
- [**Go Interfaces**](https://golang.org/doc/effective_go#interfaces) - Documentation sur l'utilisation des interfaces en Go pour créer des frontières modulaires.
- [**Nx**](https://nx.dev/) - Un ensemble d'outils pour développer des applications monorepo en JavaScript/TypeScript avec une approche modulaire.

### Exemples de Code

- [**Modular Monolith with DDD**](https://github.com/kgrzybek/modular-monolith-with-ddd) - Un exemple complet d'implémentation d'un monolithe modulaire en .NET avec Domain-Driven Design.
- [**Go-Clean-Arch**](https://github.com/bxcodec/go-clean-arch) - Un exemple d'architecture propre en Go qui peut être adaptée à un monolithe modulaire.

### Communautés

- [**Domain-Driven Design Community**](https://dddcommunity.org/) - Une communauté dédiée aux pratiques DDD, qui sont souvent appliquées dans les monolithes modulaires.
- [**Software Architecture Discord**](https://discord.gg/Yg5bzd7wVa) - Un serveur Discord pour les discussions sur l'architecture logicielle, y compris les monolithes modulaires. 