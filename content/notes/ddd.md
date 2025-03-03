+++
title = "Domain-Driven Design (DDD)"
date = 2025-03-03
draft = false

[taxonomies]
categories = ["Développement"]
tags = ["DDD", "architecture", "Darkaine"]

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

# Domain-Driven Design (DDD)

## Qu'est-ce que le DDD ?

Le Domain-Driven Design (DDD) est une approche de conception logicielle qui se concentre sur la modélisation du domaine d'application. L'idée principale est de créer un modèle qui reflète les besoins et les règles du domaine métier, facilitant ainsi la communication entre les développeurs et les experts métier.

## Principes du DDD

1. **Modèle de domaine** : Créer un modèle qui représente les concepts clés du domaine.
2. **Ubiquitous Language** : Utiliser un langage commun entre les développeurs et les experts métier pour éviter les malentendus.
3. **Bounded Context** : Définir des limites claires autour des modèles pour éviter les conflits et les ambiguïtés.
4. **Entités et Valeurs** : Distinguer entre les entités (objets ayant une identité) et les objets de valeur (objets définis par leurs attributs).

## Exemples en PHP

### Modèle de domaine

```php
class Product {
    private $id;
    private $name;
    private $price;

    public function __construct($id, $name, $price) {
        $this->id = $id;
        $this->name = $name;
        $this->price = $price;
    }

    public function getId() {
        return $this->id;
    }

    public function getName() {
        return $this->name;
    }

    public function getPrice() {
        return $this->price;
    }
}
```

### Service de domaine

```php
class ProductService {
    private $products = [];

    public function addProduct(Product $product) {
        $this->products[$product->getId()] = $product;
    }

    public function getProduct($id) {
        return $this->products[$id] ?? null;
    }
}
```

## Exemples en Go

### Modèle de domaine

```go
package main

type Product struct {
    ID    string
    Name  string
    Price float64
}

func NewProduct(id, name string, price float64) *Product {
    return &Product{ID: id, Name: name, Price: price}
}
```

### Service de domaine

```go
package main

type ProductService struct {
    products map[string]*Product
}

func NewProductService() *ProductService {
    return &ProductService{products: make(map[string]*Product)}
}

func (s *ProductService) AddProduct(product *Product) {
    s.products[product.ID] = product
}

func (s *ProductService) GetProduct(id string) *Product {
    return s.products[id]
}
```

## Avantages du DDD

1. **Alignement avec le métier** : Le DDD favorise une meilleure compréhension des besoins métier, ce qui conduit à des solutions plus adaptées.
2. **Modularité** : En définissant des contextes délimités, le DDD encourage une architecture modulaire, facilitant la maintenance et l'évolution du code.
3. **Communication améliorée** : L'utilisation d'un langage commun réduit les malentendus entre les équipes techniques et métier.

## Inconvénients du DDD

1. **Complexité** : Le DDD peut introduire une complexité supplémentaire, surtout pour les petites applications où une approche plus simple pourrait suffire.
2. **Courbe d'apprentissage** : Les équipes doivent comprendre les concepts du DDD, ce qui peut nécessiter du temps et des efforts.
3. **Surcharge de modélisation** : Il peut être tentant de trop modéliser le domaine, ce qui peut conduire à un code inutilement complexe.

## Ressources

- [Domain-Driven Design: Tackling Complexity in the Heart of Software](https://www.oreilly.com/library/view/domain-driven-design-tackling/9780134439780/) par Eric Evans
- [Implementing Domain-Driven Design](https://www.oreilly.com/library/view/implementing-domain-driven-design/9780134439780/) par Vaughn Vernon
- [Domain-Driven Design Community](https://domainlanguage.com/ddd/)

## Conclusion

Le Domain-Driven Design est une approche puissante pour modéliser des systèmes complexes en se concentrant sur le domaine métier. Bien qu'il puisse introduire une certaine complexité, ses avantages en termes d'alignement avec le métier et de communication en font une méthode précieuse pour de nombreux projets. 