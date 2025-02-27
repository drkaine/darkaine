+++
title = "Conventional Commits"
date = 2025-02-27
draft = false

[taxonomies]
categories = ["Développement"]
tags = ["conventional commits", "git", "pratiques", "Darkaine"]

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

## Qu'est-ce que les Conventional Commits ?

Les **Conventional Commits** sont une convention de message de commit qui vise à rendre l'historique des commits plus lisible et à faciliter l'automatisation des versions et des changelogs. En suivant cette convention, les développeurs peuvent mieux comprendre les changements apportés au code et les outils peuvent générer automatiquement des versions et des notes de version.

## Pourquoi utiliser les Conventional Commits ?

1. **Clarté** : Les messages de commit sont plus clairs et plus informatifs, ce qui facilite la compréhension des changements.
2. **Automatisation** : Permet l'automatisation de la génération de changelogs et de versions, ce qui réduit le travail manuel.
3. **Collaboration** : Améliore la collaboration entre les membres de l'équipe en fournissant un format standardisé.
4. **Gestion des versions** : Facilite la gestion des versions sémantiques (SemVer) en indiquant le type de changement (ajout, modification, suppression).

## Structure d'un message de commit

Un message de commit suivant la convention doit respecter la structure suivante :

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### 1. Type

Le type indique la nature du changement. Voici quelques types courants :

- **feat** : Une nouvelle fonctionnalité.
- **fix** : Une correction de bug.
- **docs** : Des modifications de documentation.
- **style** : Des changements qui n'affectent pas le code (formatage, espaces, etc.).
- **refactor** : Une modification du code qui n'ajoute pas de fonctionnalité ni ne corrige de bug.
- **perf** : Une amélioration de performance.
- **test** : Ajout ou modification de tests.
- **chore** : Modifications de tâches de maintenance.

### 2. Scope (facultatif)

Le scope est une indication optionnelle qui précise la zone du code concernée par le changement. Par exemple, cela pourrait être le nom d'un module ou d'une fonctionnalité.

### 3. Description

La description doit être concise et expliquer brièvement le changement. Elle doit commencer par une lettre minuscule et ne pas dépasser 72 caractères.

### 4. Body (facultatif)

Le corps du message peut fournir des détails supplémentaires sur le changement, expliquant le raisonnement derrière celui-ci ou les implications.

### 5. Footer (facultatif)

Le pied de page peut inclure des informations supplémentaires, comme des références à des tickets ou des issues, ou des notes sur la version.

## Exemples de messages de commit

Voici quelques exemples de messages de commit conformes aux conventions :

```
feat(auth): ajouter la fonctionnalité de connexion par Google

Ajout d'une option de connexion par Google pour améliorer l'expérience utilisateur.

fix(api): corriger le bug de récupération des utilisateurs

Correction d'un problème où les utilisateurs ne pouvaient pas être récupérés à partir de l'API.
```

## Conclusion

L'adoption des **Conventional Commits** dans votre flux de travail peut grandement améliorer la lisibilité de l'historique des commits et faciliter l'automatisation des processus de versionnement. En suivant cette convention, vous contribuez à un environnement de développement plus organisé et collaboratif.

## Ressources Supplémentaires

- [Conventional Commits Specification](https://www.conventionalcommits.org/en/v1.0.0/)
- [Semantic Versioning](https://semver.org/)
- [Git Commit Message Guidelines](https://chris.beams.io/posts/git-commit/) 