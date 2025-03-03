+++
title = "Astuces PHP"
date = 2025-02-20
draft = false

[taxonomies]
categories = ["Configuration"]
tags = ["configuration", "prise en main", "Darkaine"]

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

# Astuces en vrac pour PHP

## Mauvaises habitudes à perdre

### 1. Tester qu'un tableau n'est pas vide avant de boucler dessus
Utilisez `foreach` ou les méthodes sur les tableaux qui gèrent les cas où le tableau est vide. Cela permet de réduire l'indentation.

```php
$items = []; // tableau vide
foreach ($items as $item) {
    // Traitement
}
```

### 2. Encapsuler tout le contenu d'une méthode dans un if
Utilisez plutôt un early return avec un if contraire pour un code plus lisible.

```php
function example($condition) {
    if (!$condition) {
        return;
    }
    // Traitement
}
```

### 3. Utiliser plusieurs fois la méthode `isset`
`isset` peut prendre plusieurs valeurs en argument.

```php
if (isset($var1, $var2)) {
    // Traitement
}
```

### 4. Combiner `echo` avec `sprintf`
Utilisez plutôt `printf` directement pour une meilleure lisibilité.

```php
printf("Bonjour %s, vous avez %d nouveaux messages.", $name, $count);
```

### 5. Vérifier la présence d'une clé dans un tableau
Utilisez `array_key_exists` ou `isset` au lieu de combiner `in_array` et `array_keys`.

```php
if (array_key_exists('key', $array)) {
    // Traitement
}
```

### 6. Tester qu'un tableau est vide
Utilisez `$var === []` ou `isset` si elle est déclarée.

```php
if ($var === []) {
    // Traitement
}
```

### 7. Récupérer la première et la dernière clé d'un tableau
Utilisez `array_key_first` et `array_key_last`.

```php
$firstKey = array_key_first($array);
$lastKey = array_key_last($array);
```

### 8. Filtrer les éléments d'un tableau
Utilisez `array_filter` pour conserver les clés et `array_values` pour réinitialiser les clés.

```php
$filtered = array_filter($array, function($item) {
    return $item > 10; // Exemple de condition
});
```

### 9. Vérifier si une chaîne est présente dans une autre chaîne
Utilisez `str_contains`, `str_starts_with`, et `str_ends_with`.

```php
if (str_contains($string, 'recherche')) {
    // Traitement
}
```

### 10. Remplacer les `switch` par des `match`
Utilisez `match` pour une syntaxe plus concise.

```php
$result = match($value) {
    1 => 'Un',
    2 => 'Deux',
    default => 'Autre',
};
```

## Autres astuces utiles

### 11. Utiliser les types de retour
Déclarez les types de retour pour améliorer la lisibilité et la sécurité du code.

```php
function add(int $a, int $b): int {
    return $a + $b;
}
```

### 12. Gérer les exceptions
Utilisez `try-catch` pour gérer les exceptions et éviter les plantages.

```php
try {
    $result = someFunction();
} catch (Exception $e) {
    echo 'Erreur : ' . $e->getMessage();
}
```

### 13. Utiliser les espaces de noms
Organisez votre code en utilisant des espaces de noms pour éviter les conflits de noms.

```php
namespace MonProjet\Utils;

class Helper {
    // Méthodes
}
```

### 14. Profiter des traits
Utilisez des traits pour réutiliser du code dans plusieurs classes.

```php
trait Logger {
    public function log($message) {
        echo $message;
    }
}

class MyClass {
    use Logger;
}
```

### 15. Utiliser Composer
Utilisez Composer pour gérer vos dépendances et autoloader vos classes.

```bash
composer require vendor/package
```

## Références en PHP

### Qu'est-ce qu'une référence ?

En PHP, une référence permet à deux variables de pointer vers le même contenu. Cela signifie que si vous modifiez la valeur d'une variable, l'autre variable reflétera également ce changement.

### Exemple de référence

```php
$a = 10;
$b = &$a; // $b est une référence à $a
$b = 20; // Modifie $a également

echo $a; // Affiche 20
```

### Références avec des tableaux

Les références peuvent également être utilisées avec des tableaux. Si vous assignez un tableau à une autre variable par référence, les modifications apportées à l'un affecteront l'autre.

```php
$array1 = [1, 2, 3];
$array2 = &$array1; // $array2 est une référence à $array1
$array2[0] = 10; // Modifie $array1 également

print_r($array1); // Affiche [10, 2, 3]
```

### Références avec des objets

Les objets en PHP sont toujours passés par référence par défaut. Cela signifie que si vous assignez un objet à une autre variable, les deux variables pointeront vers le même objet.

```php
class MyClass {
    public $value;
}

$obj1 = new MyClass();
$obj1->value = 5;
$obj2 = $obj1; // $obj2 référence le même objet que $obj1
$obj2->value = 10;

echo $obj1->value; // Affiche 10
```

### Intérêts des références

1. **Économie de mémoire** : Les références permettent d'éviter la duplication de données, ce qui peut être bénéfique pour la mémoire.
2. **Modification directe** : Les références permettent de modifier directement la valeur d'une variable à partir d'une autre variable.

### Points d'attention

- **Complexité** : L'utilisation de références peut rendre le code plus difficile à comprendre, surtout pour les développeurs moins expérimentés.
- **Effets secondaires** : Les modifications apportées à une variable référencée peuvent avoir des effets inattendus sur d'autres parties du code.

### Dangers des références

- **Difficulté de débogage** : Les références peuvent rendre le débogage plus complexe, car il peut être difficile de suivre quelles variables pointent vers quelles valeurs.
- **Modifications involontaires** : Il est facile de modifier une variable sans s'en rendre compte, ce qui peut entraîner des bugs difficiles à traquer.

## Différence entre `==` et `===`

### `==` (Égalité lâche)

L'opérateur `==` compare deux valeurs pour l'égalité, mais il effectue une conversion de type si les types des valeurs sont différents. Cela signifie que PHP essaiera de convertir les valeurs en un type commun avant de les comparer.

#### Exemple :

```php
$a = 0;
$b = '0';

if ($a == $b) {
    echo "Les valeurs sont égales (==)"; // Cette ligne sera exécutée
}
```

### `===` (Égalité stricte)

L'opérateur `===` compare à la fois la valeur et le type. Si les types des valeurs sont différents, la comparaison renverra `false` sans effectuer de conversion de type.

#### Exemple :

```php
$a = 0;
$b = '0';

if ($a === $b) {
    echo "Les valeurs sont égales (===)"; // Cette ligne ne sera pas exécutée
} else {
    echo "Les valeurs ne sont pas égales (===)"; // Cette ligne sera exécutée
}
```

### Quand utiliser `==` ou `===` ?

- **Utilisez `===`** lorsque vous voulez vous assurer que les valeurs sont identiques en type et en valeur. Cela évite les comportements inattendus dus à la conversion de type.
- **Utilisez `==`** lorsque vous êtes certain que la conversion de type est souhaitable et que vous voulez comparer des valeurs qui pourraient être de types différents.

## Typage fort en PHP

PHP est un langage à typage faible, ce qui signifie que les types de données peuvent être convertis automatiquement. Cependant, avec l'introduction de PHP 7, des fonctionnalités de typage fort ont été ajoutées, permettant aux développeurs de déclarer des types pour les paramètres de fonction et les valeurs de retour.

### Comment fonctionne le typage fort en PHP ?

Pour activer le typage fort, vous devez utiliser la directive `declare(strict_types=1);` au début de votre fichier PHP. Cela signifie que PHP ne fera pas de conversion de type automatique et que les types doivent correspondre exactement.

#### Exemple de typage fort

```php
declare(strict_types=1);

function multiply(int $a, int $b): int {
    return $a * $b;
}

$result = multiply(5, 10); // Fonctionne
// $result = multiply(5, "10"); // Provoquerait une erreur de type
```

### Limites du typage fort

1. **Rigidité** : Le typage fort peut rendre le code plus rigide, car il nécessite que les types soient respectés. Cela peut être contraignant dans certains cas où la flexibilité est souhaitable.
2. **Conversion de type** : Les développeurs doivent être conscients des conversions de type implicites qui peuvent se produire dans d'autres parties du code, surtout si `strict_types` n'est pas utilisé.

### Intérêts du typage fort

1. **Clarté** : Le typage fort rend le code plus clair en indiquant explicitement quels types de données sont attendus.
2. **Sécurité** : Cela réduit les erreurs de type, car PHP renverra une erreur si un type incorrect est passé à une fonction.
3. **Maintenance** : Facilite la maintenance du code, car les développeurs peuvent comprendre rapidement les types de données attendus.

## Conventions de code en PHP

Les conventions de code sont des règles et des recommandations qui aident à maintenir la lisibilité et la cohérence du code. Voici quelques-unes des conventions les plus courantes en PHP :

### 1. Nommage des variables et des fonctions

- Utilisez le style `camelCase` pour les noms de variables et de fonctions.
- Les noms de classes doivent être en `PascalCase`.

#### Exemples :

```php
// Noms de variables
$firstName = "John";
$lastName = "Doe";

// Noms de fonctions
function calculateTotal($price, $quantity) {
    return $price * $quantity;
}

// Noms de classes
class UserProfile {
    // ...
}
```

### 2. Indentation et espaces

- Utilisez des espaces pour l'indentation (généralement 4 espaces).
- Ajoutez des espaces autour des opérateurs pour améliorer la lisibilité.

#### Exemple :

```php
if ($a > $b) {
    echo "A est plus grand que B";
}
```

### 3. Commentaires

- Utilisez des commentaires pour expliquer le code complexe ou les décisions de conception.

#### Exemple :

```php
/**
 * Calcule le total d'un prix multiplié par une quantité.
 */
function calculateTotal($price, $quantity) {
    return $price * $quantity;
}
```

### 4. Utilisation des espaces de noms

- Utilisez des espaces de noms pour organiser votre code et éviter les conflits de noms.

#### Exemple :

```php
namespace MonProjet\Utils;

class Helper {
    // Méthodes
}
```

### 5. Respect des standards PSR

- Suivez les recommandations des standards PSR (PHP Standards Recommendations), notamment PSR-1, PSR-2 et PSR-12, qui définissent des conventions de codage pour PHP.

## Conclusion

Ces astuces vous aideront à écrire un code PHP plus propre, plus efficace et plus maintenable. N'hésitez pas à explorer davantage les fonctionnalités de PHP et à consulter la documentation officielle pour des informations plus détaillées.
