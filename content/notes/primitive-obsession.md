+++
title = "Primitive Obsession"
date = 2025-03-04
draft = false

[taxonomies]
categories = ["Développement"]
tags = ["primitive obsession", "DDD", "Darkaine", "refactoring", "value objects"]

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

# Primitive Obsession

## Qu'est-ce que la Primitive Obsession ?

La Primitive Obsession est un anti-pattern en programmation qui se produit lorsque des types primitifs (comme les chaînes, les entiers, les booléens, etc.) sont utilisés pour représenter des concepts métier complexes. Cela peut entraîner un code difficile à comprendre, à maintenir et à étendre, car les primitives ne capturent pas la richesse sémantique ou le comportement des concepts qu'elles représentent.

## Cas courants de Primitive Obsession

Voici quelques situations typiques où la Primitive Obsession se manifeste :

1. **Identifiants** : Utiliser des chaînes ou des entiers simples pour représenter des ID.
2. **Informations de contact** : Stocker des numéros de téléphone, adresses email, etc. sous forme de simples chaînes.
3. **Unités de mesure** : Représenter des montants, des distances ou des poids par de simples nombres.
4. **États et énumérations** : Utiliser des chaînes ou des entiers pour représenter des états ou des types.
5. **Dates et heures** : Manipuler des dates comme des chaînes ou des timestamps.

## Exemples en PHP

### Mauvaise utilisation des types primitifs

```php
class Order {
    private $orderId;
    private $customerId;
    private $totalAmount;
    private $status; // "pending", "shipped", "delivered"
    private $email;  // Email du client

    public function __construct(string $orderId, string $customerId, float $totalAmount, string $status, string $email) {
        $this->orderId = $orderId;
        $this->customerId = $customerId;
        $this->totalAmount = $totalAmount;
        $this->status = $status;
        $this->email = $email;
    }

    public function getOrderId(): string {
        return $this->orderId;
    }

    public function getCustomerId(): string {
        return $this->customerId;
    }

    public function getTotalAmount(): float {
        return $this->totalAmount;
    }
    
    public function getStatus(): string {
        return $this->status;
    }
    
    public function getEmail(): string {
        return $this->email;
    }
    
    public function setStatus(string $status): void {
        // Pas de validation, n'importe quelle chaîne peut être acceptée
        $this->status = $status;
    }
}
```

### Amélioration avec des objets de valeur

```php
class OrderId {
    private $id;

    public function __construct(string $id) {
        if (empty($id)) {
            throw new InvalidArgumentException("L'ID de commande ne peut pas être vide");
        }
        $this->id = $id;
    }

    public function getValue(): string {
        return $this->id;
    }
    
    public function equals(OrderId $other): bool {
        return $this->id === $other->getValue();
    }
}

class CustomerId {
    private $id;

    public function __construct(string $id) {
        if (empty($id)) {
            throw new InvalidArgumentException("L'ID client ne peut pas être vide");
        }
        $this->id = $id;
    }

    public function getValue(): string {
        return $this->id;
    }
    
    public function equals(CustomerId $other): bool {
        return $this->id === $other->getValue();
    }
}

class Money {
    private $amount;
    private $currency;
    
    public function __construct(float $amount, string $currency = 'EUR') {
        if ($amount < 0) {
            throw new InvalidArgumentException("Le montant ne peut pas être négatif");
        }
        $this->amount = $amount;
        $this->currency = $currency;
    }
    
    public function getAmount(): float {
        return $this->amount;
    }
    
    public function getCurrency(): string {
        return $this->currency;
    }
    
    public function add(Money $other): Money {
        if ($this->currency !== $other->getCurrency()) {
            throw new InvalidArgumentException("Impossible d'additionner des montants de devises différentes");
        }
        return new Money($this->amount + $other->getAmount(), $this->currency);
    }
}

class OrderStatus {
    private const PENDING = 'pending';
    private const SHIPPED = 'shipped';
    private const DELIVERED = 'delivered';
    private const CANCELED = 'canceled';
    
    private static $validStatuses = [
        self::PENDING,
        self::SHIPPED,
        self::DELIVERED,
        self::CANCELED,
    ];
    
    private $status;
    
    public function __construct(string $status) {
        if (!in_array($status, self::$validStatuses)) {
            throw new InvalidArgumentException("Statut de commande invalide: {$status}");
        }
        $this->status = $status;
    }
    
    public function getValue(): string {
        return $this->status;
    }
    
    public static function pending(): self {
        return new self(self::PENDING);
    }
    
    public static function shipped(): self {
        return new self(self::SHIPPED);
    }
    
    public static function delivered(): self {
        return new self(self::DELIVERED);
    }
    
    public static function canceled(): self {
        return new self(self::CANCELED);
    }
    
    public function isPending(): bool {
        return $this->status === self::PENDING;
    }
    
    public function isShipped(): bool {
        return $this->status === self::SHIPPED;
    }
    
    public function isDelivered(): bool {
        return $this->status === self::DELIVERED;
    }
    
    public function isCanceled(): bool {
        return $this->status === self::CANCELED;
    }
}

class EmailAddress {
    private $email;
    
    public function __construct(string $email) {
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            throw new InvalidArgumentException("Adresse email invalide: {$email}");
        }
        $this->email = $email;
    }
    
    public function getValue(): string {
        return $this->email;
    }
    
    public function getDomain(): string {
        return substr(strrchr($this->email, "@"), 1);
    }
}

class Order {
    private $orderId;
    private $customerId;
    private $totalAmount;
    private $status;
    private $email;

    public function __construct(
        OrderId $orderId, 
        CustomerId $customerId, 
        Money $totalAmount, 
        OrderStatus $status, 
        EmailAddress $email
    ) {
        $this->orderId = $orderId;
        $this->customerId = $customerId;
        $this->totalAmount = $totalAmount;
        $this->status = $status;
        $this->email = $email;
    }

    public function getOrderId(): OrderId {
        return $this->orderId;
    }

    public function getCustomerId(): CustomerId {
        return $this->customerId;
    }

    public function getTotalAmount(): Money {
        return $this->totalAmount;
    }
    
    public function getStatus(): OrderStatus {
        return $this->status;
    }
    
    public function getEmail(): EmailAddress {
        return $this->email;
    }
    
    public function updateStatus(OrderStatus $newStatus): void {
        // La validation est déjà incluse dans l'objet OrderStatus
        $this->status = $newStatus;
    }
    
    public function isPending(): bool {
        return $this->status->isPending();
    }
    
    public function isShipped(): bool {
        return $this->status->isShipped();
    }
}
```

## Exemples en Go

### Mauvaise utilisation des types primitifs

```go
type Order struct {
    OrderID     string
    CustomerID  string
    TotalAmount float64
    Status      string   // "pending", "shipped", "delivered"
    Email       string
}

func NewOrder(orderID, customerID string, amount float64, status, email string) Order {
    return Order{
        OrderID:     orderID,
        CustomerID:  customerID,
        TotalAmount: amount,
        Status:      status,
        Email:       email,
    }
}

func (o *Order) SetStatus(status string) {
    // Pas de validation
    o.Status = status
}
```

### Amélioration avec des types définis et des validations

```go
package main

import (
    "errors"
    "fmt"
    "regexp"
)

// OrderID encapsule l'identifiant de commande
type OrderID string

func NewOrderID(id string) (OrderID, error) {
    if id == "" {
        return "", errors.New("l'ID de commande ne peut pas être vide")
    }
    return OrderID(id), nil
}

func (id OrderID) String() string {
    return string(id)
}

// CustomerID encapsule l'identifiant client
type CustomerID string

func NewCustomerID(id string) (CustomerID, error) {
    if id == "" {
        return "", errors.New("l'ID client ne peut pas être vide")
    }
    return CustomerID(id), nil
}

func (id CustomerID) String() string {
    return string(id)
}

// Money représente un montant avec sa devise
type Money struct {
    Amount   float64
    Currency string
}

func NewMoney(amount float64, currency string) (Money, error) {
    if amount < 0 {
        return Money{}, errors.New("le montant ne peut pas être négatif")
    }
    if currency == "" {
        currency = "EUR"
    }
    return Money{Amount: amount, Currency: currency}, nil
}

func (m Money) Add(other Money) (Money, error) {
    if m.Currency != other.Currency {
        return Money{}, errors.New("impossible d'additionner des montants de devises différentes")
    }
    result, err := NewMoney(m.Amount+other.Amount, m.Currency)
    return result, err
}

// OrderStatus représente le statut d'une commande
type OrderStatus string

const (
    OrderStatusPending   OrderStatus = "pending"
    OrderStatusShipped   OrderStatus = "shipped"
    OrderStatusDelivered OrderStatus = "delivered"
    OrderStatusCanceled  OrderStatus = "canceled"
)

func NewOrderStatus(status string) (OrderStatus, error) {
    s := OrderStatus(status)
    switch s {
    case OrderStatusPending, OrderStatusShipped, OrderStatusDelivered, OrderStatusCanceled:
        return s, nil
    default:
        return "", fmt.Errorf("statut de commande invalide: %s", status)
    }
}

func (s OrderStatus) IsPending() bool {
    return s == OrderStatusPending
}

func (s OrderStatus) IsShipped() bool {
    return s == OrderStatusShipped
}

func (s OrderStatus) IsDelivered() bool {
    return s == OrderStatusDelivered
}

func (s OrderStatus) IsCanceled() bool {
    return s == OrderStatusCanceled
}

// EmailAddress représente une adresse email
type EmailAddress string

var emailRegex = regexp.MustCompile(`^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$`)

func NewEmailAddress(email string) (EmailAddress, error) {
    if !emailRegex.MatchString(email) {
        return "", fmt.Errorf("adresse email invalide: %s", email)
    }
    return EmailAddress(email), nil
}

func (e EmailAddress) String() string {
    return string(e)
}

// Order représente une commande
type Order struct {
    OrderID     OrderID
    CustomerID  CustomerID
    TotalAmount Money
    Status      OrderStatus
    Email       EmailAddress
}

func NewOrder(orderID OrderID, customerID CustomerID, amount Money, status OrderStatus, email EmailAddress) Order {
    return Order{
        OrderID:     orderID,
        CustomerID:  customerID,
        TotalAmount: amount,
        Status:      status,
        Email:       email,
    }
}

func (o *Order) UpdateStatus(status OrderStatus) {
    o.Status = status
}

func (o *Order) IsPending() bool {
    return o.Status.IsPending()
}

func (o *Order) IsShipped() bool {
    return o.Status.IsShipped()
}

// Exemple d'utilisation
func ExampleUsage() {
    // Création des objets de valeur avec validation
    orderID, _ := NewOrderID("ORD-12345")
    customerID, _ := NewCustomerID("CUST-6789")
    amount, _ := NewMoney(99.99, "EUR")
    status, _ := NewOrderStatus("pending")
    email, _ := NewEmailAddress("client@exemple.fr")
    
    // Création de la commande
    order := NewOrder(orderID, customerID, amount, status, email)
    
    // Utilisation des méthodes
    if order.IsPending() {
        fmt.Println("La commande est en attente")
    }
    
    // Mise à jour du statut
    newStatus, _ := NewOrderStatus("shipped")
    order.UpdateStatus(newStatus)
    
    if order.IsShipped() {
        fmt.Println("La commande a été expédiée")
    }
}
```

## Avantages de l'évitement de la Primitive Obsession

1. **Clarté sémantique** : En utilisant des objets de valeur ou des types définis, le code devient plus clair et plus expressif, car il capture mieux les intentions métier et les règles du domaine.

2. **Validation à la source** : Les objets de valeur peuvent inclure des validations, ce qui réduit les erreurs liées à l'utilisation incorrecte des types primitifs. La validation est effectuée lors de la création de l'objet, garantissant que toutes les instances sont valides.

3. **Encapsulation** : Les comportements associés aux concepts métier peuvent être encapsulés dans des classes spécifiques, ce qui facilite la maintenance et l'évolution du code.

4. **Prévention des erreurs** : L'utilisation de types spécifiques empêche les mélanges accidentels (comme passer un ID client là où un ID de commande est attendu).

5. **Création de méthodes métier** : Possibilité d'ajouter des méthodes spécifiques qui ont du sens dans le contexte métier (comme `isPending()`, `isShipped()` pour un statut).

## Inconvénients de l'évitement de la Primitive Obsession

1. **Complexité accrue** : L'introduction de nouveaux types peut ajouter une complexité supplémentaire, surtout pour des concepts simples ou des applications de petite taille.

2. **Surcharge de code** : Créer des classes pour chaque concept peut entraîner une prolifération de classes, ce qui peut être perçu comme une surcharge inutile dans certains contextes.

3. **Courbe d'apprentissage** : Pour les équipes non familiarisées avec le [DDD](/notes/DDD) ou les Value Objects, cette approche peut nécessiter un temps d'adaptation.

4. **Sérialisation/Désérialisation** : Travailler avec des formats comme JSON ou les bases de données peut nécessiter des adaptateurs supplémentaires pour convertir entre les types primitifs et les Value Objects.

## Quand utiliser des Value Objects ?

Il est judicieux de remplacer les primitives par des Value Objects dans les cas suivants :

1. **Lorsque les valeurs ont des règles de validation spécifiques** (comme les emails, les numéros de téléphone).
2. **Quand des comportements sont associés à la valeur** (comme un calcul de TVA pour un prix).
3. **Pour distinguer différents types d'identifiants** ou de références qui pourraient être confondus.
4. **Lorsqu'il existe un ensemble fini de valeurs possibles** (comme des statuts, des types).
5. **Quand la valeur représente un concept important du domaine métier**.

## Conclusion

La Primitive Obsession est un anti-pattern courant qui peut nuire à la qualité et à la maintenabilité du code. En remplaçant les types primitifs par des objets de valeur ou des types définis, les développeurs peuvent créer un code plus clair, plus robuste et plus aligné avec les concepts métier.

Bien que cette approche puisse sembler verbeuse au premier abord, elle offre des avantages significatifs en termes de sécurité, de clarté et de maintenabilité. Comme pour toute technique, il est important de trouver le bon équilibre et d'appliquer cette approche là où elle apporte une réelle valeur ajoutée.

## Ressources

- [Refactoring: Improving the Design of Existing Code](https://refactoring.guru/refactoring) par Martin Fowler
- [Domain-Driven Design: Tackling Complexity in the Heart of Software](https://www.oreilly.com/library/view/domain-driven-design-tackling/9780134439780/) par Eric Evans
- [Clean Code: A Handbook of Agile Software Craftsmanship](https://www.oreilly.com/library/view/clean-code-a/9780136083239/) par Robert C. Martin
- [Implementing Domain-Driven Design](https://www.oreilly.com/library/view/implementing-domain-driven-design/9780134439780/) par Vaughn Vernon 