+++
title = "Value Objects"
date = 2025-03-05
draft = false

[taxonomies]
categories = ["Développement"]
tags = ["value objects", "DDD", "Darkaine", "refactoring", "immutabilité"]

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

# Value Objects

## Qu'est-ce qu'un Value Object ?

Un Value Object est un concept du Domain-Driven Design ([DDD](/notes/DDD)) qui représente un objet défini uniquement par ses attributs, sans identité propre. Contrairement aux entités qui sont identifiées par un ID unique, deux Value Objects avec les mêmes attributs sont considérés comme identiques.

Les caractéristiques essentielles des Value Objects sont :

1. **Immutabilité** : Une fois créés, ils ne peuvent pas être modifiés.
2. **Égalité basée sur les attributs** : Deux Value Objects sont égaux si tous leurs attributs sont égaux.
3. **Auto-validation** : Ils garantissent leur propre validité.
4. **Encapsulation de concept** : Ils représentent un concept cohérent du domaine métier.

## Exemples de Value Objects courants

Voici quelques exemples typiques de Value Objects :

- **Adresse postale**
- **Montant monétaire** (avec devise)
- **Numéro de téléphone**
- **Adresse email**
- **Plage de dates**
- **Coordonnées géographiques**

## Exemples en PHP

### Value Object simple : Email

```php
class Email {
    private $address;

    public function __construct(string $address) {
        if (!filter_var($address, FILTER_VALIDATE_EMAIL)) {
            throw new InvalidArgumentException("Adresse email invalide: {$address}");
        }
        $this->address = $address;
    }

    public function getAddress(): string {
        return $this->address;
    }

    public function getDomain(): string {
        return substr(strrchr($this->address, "@"), 1);
    }

    public function equals(Email $other): bool {
        return $this->address === $other->getAddress();
    }

    public function __toString(): string {
        return $this->address;
    }
}
```

### Value Object avec opérations : Money

```php
class Money {
    private $amount;
    private $currency;

    public function __construct(float $amount, string $currency) {
        if ($amount < 0) {
            throw new InvalidArgumentException("Le montant ne peut pas être négatif");
        }
        
        if (strlen($currency) !== 3) {
            throw new InvalidArgumentException("Le code devise doit contenir 3 caractères");
        }
        
        $this->amount = $amount;
        $this->currency = strtoupper($currency);
    }

    public function getAmount(): float {
        return $this->amount;
    }

    public function getCurrency(): string {
        return $this->currency;
    }

    public function equals(Money $other): bool {
        return $this->amount === $other->getAmount() && 
               $this->currency === $other->getCurrency();
    }

    public function add(Money $other): Money {
        if ($this->currency !== $other->getCurrency()) {
            throw new InvalidArgumentException(
                "Impossible d'additionner des montants de devises différentes"
            );
        }
        
        return new Money($this->amount + $other->getAmount(), $this->currency);
    }

    public function subtract(Money $other): Money {
        if ($this->currency !== $other->getCurrency()) {
            throw new InvalidArgumentException(
                "Impossible de soustraire des montants de devises différentes"
            );
        }
        
        return new Money($this->amount - $other->getAmount(), $this->currency);
    }
    
    public function multiply(float $factor): Money {
        return new Money($this->amount * $factor, $this->currency);
    }
    
    public function allocate(array $ratios): array {
        $total = array_sum($ratios);
        $amounts = [];
        $remainder = $this->amount;
        
        foreach ($ratios as $ratio) {
            $share = floor($this->amount * $ratio / $total);
            $amounts[] = new Money($share, $this->currency);
            $remainder -= $share;
        }
        
        // Distribution du reste
        for ($i = 0; $i < $remainder; $i++) {
            $amounts[$i] = new Money(
                $amounts[$i]->getAmount() + 1, 
                $this->currency
            );
        }
        
        return $amounts;
    }
    
    public function __toString(): string {
        return number_format($this->amount, 2) . ' ' . $this->currency;
    }
}
```

### Utilisation des Value Objects

```php
// Création de Value Objects
$email = new Email("contact@example.com");
$price = new Money(100.0, 'EUR');
$discount = new Money(15.0, 'EUR');

// Opérations sur les Value Objects
$finalPrice = $price->subtract($discount);
echo "Prix final : " . $finalPrice; // Affiche "Prix final : 85.00 EUR"

// Allocation proportionnelle
$ratios = [70, 30];
$shares = $finalPrice->allocate($ratios);
echo "Part 1 : " . $shares[0]; // Affiche "Part 1 : 59.50 EUR"
echo "Part 2 : " . $shares[1]; // Affiche "Part 2 : 25.50 EUR"

// Validation automatique
try {
    $invalidEmail = new Email("not-an-email");
} catch (InvalidArgumentException $e) {
    echo $e->getMessage(); // Affiche "Adresse email invalide: not-an-email"
}
```

## Exemples en Go

### Value Object simple : Email

```go
package main

import (
    "errors"
    "fmt"
    "regexp"
    "strings"
)

type Email struct {
    address string
}

var emailRegex = regexp.MustCompile(`^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$`)

func NewEmail(address string) (Email, error) {
    if !emailRegex.MatchString(address) {
        return Email{}, errors.New(fmt.Sprintf("adresse email invalide: %s", address))
    }
    return Email{address: address}, nil
}

func (e Email) Address() string {
    return e.address
}

func (e Email) Domain() string {
    parts := strings.Split(e.address, "@")
    return parts[1]
}

func (e Email) Equals(other Email) bool {
    return e.address == other.address
}

func (e Email) String() string {
    return e.address
}
```

### Value Object avec opérations : Money

```go
package main

import (
    "errors"
    "fmt"
    "math"
    "strings"
)

type Money struct {
    amount   float64
    currency string
}

func NewMoney(amount float64, currency string) (Money, error) {
    if amount < 0 {
        return Money{}, errors.New("le montant ne peut pas être négatif")
    }
    
    if len(currency) != 3 {
        return Money{}, errors.New("le code devise doit contenir 3 caractères")
    }
    
    return Money{
        amount:   amount,
        currency: strings.ToUpper(currency),
    }, nil
}

func (m Money) Amount() float64 {
    return m.amount
}

func (m Money) Currency() string {
    return m.currency
}

func (m Money) Equals(other Money) bool {
    return m.amount == other.amount && m.currency == other.currency
}

func (m Money) Add(other Money) (Money, error) {
    if m.currency != other.currency {
        return Money{}, errors.New("impossible d'additionner des montants de devises différentes")
    }
    
    return NewMoney(m.amount + other.amount, m.currency)
}

func (m Money) Subtract(other Money) (Money, error) {
    if m.currency != other.currency {
        return Money{}, errors.New("impossible de soustraire des montants de devises différentes")
    }
    
    return NewMoney(m.amount - other.amount, m.currency)
}

func (m Money) Multiply(factor float64) (Money, error) {
    return NewMoney(m.amount * factor, m.currency)
}

func (m Money) Allocate(ratios []int) ([]Money, error) {
    var total int
    for _, ratio := range ratios {
        total += ratio
    }
    
    amounts := make([]Money, len(ratios))
    var remainder float64 = m.amount
    
    for i, ratio := range ratios {
        share := math.Floor(m.amount * float64(ratio) / float64(total))
        money, err := NewMoney(share, m.currency)
        if err != nil {
            return nil, err
        }
        amounts[i] = money
        remainder -= share
    }
    
    // Distribution du reste
    for i := 0; i < int(remainder); i++ {
        newAmount := amounts[i].amount + 1
        money, err := NewMoney(newAmount, m.currency)
        if err != nil {
            return nil, err
        }
        amounts[i] = money
    }
    
    return amounts, nil
}

func (m Money) String() string {
    return fmt.Sprintf("%.2f %s", m.amount, m.currency)
}
```

### Utilisation des Value Objects en Go

```go
func main() {
    // Création de Value Objects
    email, err := NewEmail("contact@example.com")
    if err != nil {
        fmt.Println("Erreur :", err)
        return
    }
    
    price, err := NewMoney(100.0, "EUR")
    if err != nil {
        fmt.Println("Erreur :", err)
        return
    }
    
    discount, err := NewMoney(15.0, "EUR")
    if err != nil {
        fmt.Println("Erreur :", err)
        return
    }
    
    // Opérations sur les Value Objects
    finalPrice, err := price.Subtract(discount)
    if err != nil {
        fmt.Println("Erreur :", err)
        return
    }
    
    fmt.Println("Prix final :", finalPrice) // Affiche "Prix final : 85.00 EUR"
    
    // Allocation proportionnelle
    ratios := []int{70, 30}
    shares, err := finalPrice.Allocate(ratios)
    if err != nil {
        fmt.Println("Erreur :", err)
        return
    }
    
    fmt.Println("Part 1 :", shares[0]) // Affiche "Part 1 : 59.00 EUR"
    fmt.Println("Part 2 :", shares[1]) // Affiche "Part 2 : 26.00 EUR"
    
    // Validation automatique
    _, err = NewEmail("not-an-email")
    if err != nil {
        fmt.Println(err) // Affiche "adresse email invalide: not-an-email"
    }
}
```

## Implémentation des Value Objects

### Principes d'implémentation

1. **Immuabilité** : Ne fournissez aucune méthode qui modifie l'état interne. Toute opération qui "modifie" l'objet doit retourner une nouvelle instance.

2. **Validation au constructeur** : Toute validation doit être effectuée lors de la création de l'objet, garantissant que toutes les instances sont valides.

3. **Comparaison d'égalité** : Implémentez une méthode d'égalité qui compare tous les attributs pertinents.

4. **Méthodes métier** : Ajoutez des méthodes qui ont un sens dans le contexte métier (comme `getDomain()` pour un email).

5. **Représentation sous forme de chaîne** : Implémentez une méthode de conversion en chaîne pour faciliter l'affichage et le débogage.

## Value Objects vs Primitive Obsession

La [Primitive Obsession](/notes/primitive-obsession) est un anti-pattern qui consiste à utiliser des types primitifs (chaînes, nombres, booléens) pour représenter des concepts métier complexes. Les Value Objects sont la solution à ce problème.

### Avantages par rapport aux primitives

1. **Validation intégrée** : Les Value Objects valident leur contenu, contrairement aux primitives qui acceptent n'importe quelle valeur.

2. **Comportement enrichi** : Ils peuvent contenir des méthodes spécifiques au domaine, comme `formatPhoneNumber()` pour un numéro de téléphone.

3. **Prévention des erreurs** : Le système de types empêche de mélanger des concepts différents (par exemple, un `EmailAddress` ne peut pas être utilisé à la place d'un `PhoneNumber`).

4. **Documentation implicite** : Le code devient plus expressif et auto-documenté.

## Quand utiliser des Value Objects ?

Les Value Objects sont particulièrement utiles dans les situations suivantes :

1. Lorsque vous avez besoin d'effectuer des opérations sur une valeur (comme l'addition de montants).
2. Quand des règles de validation spécifiques doivent être appliquées.
3. Lorsque la valeur est utilisée dans plusieurs endroits du code.
4. Quand des comportements spécifiques sont associés à la valeur.
5. Pour éviter les confusions entre différents types de données similaires (comme différents types d'identifiants).

## Avantages des Value Objects

1. **Immutabilité** : Réduction des erreurs liées à la modification accidentelle des données.
2. **Clarté sémantique** : Représentation claire et explicite des concepts métier.
3. **Encapsulation de la validation** : Les règles métier sont définies une seule fois à l'endroit approprié.
4. **Testabilité** : Plus facile à tester car immuable et sans effets secondaires.
5. **Sécurité** : Prévention des erreurs de type et de validation.

## Inconvénients des Value Objects

1. **Complexité du code** : Plus de classes et de fichiers à gérer.
2. **Sérialisation** : Nécessite des adaptateurs pour la conversion vers/depuis des formats comme JSON.
3. **Performance** : La création de nombreux objets peut avoir un impact sur les performances dans certains cas.
4. **Courbe d'apprentissage** : Requiert une compréhension des principes du [DDD](/notes/DDD) et des bonnes pratiques.

## Conclusion

Les Value Objects constituent un outil fondamental dans le Domain-Driven Design pour représenter des concepts métier de manière claire, immuable et auto-validante. Bien qu'ils introduisent une certaine complexité, leurs avantages en termes de clarté, de sécurité et de robustesse du code en font un élément essentiel dans la boîte à outils du développeur soucieux de créer un code qui reflète fidèlement le domaine métier.

La transition de la Primitive Obsession vers l'utilisation de Value Objects est l'un des refactorings les plus bénéfiques pour améliorer la qualité et la maintenabilité du code.

## Ressources

- [Domain-Driven Design: Tackling Complexity in the Heart of Software](https://www.oreilly.com/library/view/domain-driven-design-tackling/9780134439780/) par Eric Evans
- [Implementing Domain-Driven Design](https://www.oreilly.com/library/view/implementing-domain-driven-design/9780134439780/) par Vaughn Vernon
- [Value Objects in Domain-Driven Design](https://martinfowler.com/eaa.html#ValueObject) par Martin Fowler
- [Refactoring from Anemic Domain Model to the Rich One](https://blog.pragmatists.com/refactoring-from-anemic-domain-model-to-the-rich-one-d094089a19b3)
- [Value Object: A Better Implementation](https://leanpub.com/value-object) 