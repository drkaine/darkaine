+++
title = "Participer"
description = "Tu veux partager tes notes ? Voici la marche à suivre"
template = "prose.html"
insert_anchor_links = "none"

[extra]
lang = 'fr'
+++

# Participer à notre projet

Bonjour et bienvenue !

Ce projet est une initiative collaborative visant à partager des connaissances et des ressources. Nous sommes ravis que tu souhaites y participer. Voici comment tu peux contribuer.

## Pourquoi participer ?

Ce site me sert à conserver les notes prises lors de ma veille, mes lectures, etc. J'ai pensé que tant qu'à être en ligne, autant en faire profiter les autres. Le répertoire est public, et tout le monde peut partager ses notes, projets et autres.

## Comment contribuer ?

### 1. Créer une branche

Pour commencer, crée une branche pour tes modifications. Utilise un nom descriptif pour ta branche :

```bash
git checkout -b nom_de_ta_branche
```

### 2. Publier ta branche

Une fois tes modifications effectuées, publie ta branche sur le dépôt distant :

```bash
git push origin nom_de_ta_branche
```

### 3. Demander une merge request

Après avoir publié ta branche, demande une merge request (MR) pour que tes modifications soient examinées. Assure-toi de fournir une description claire de ce que tu as changé et pourquoi.

### 4. Attendre la révision

Une fois ta MR soumise, elle sera examinée par un membre de l'équipe. Sois prêt à répondre aux commentaires et à apporter des modifications si nécessaire.

## Règles de contribution

- **Respecte les autres** : Sois courtois et respectueux dans tes interactions.
- **Écris des messages de commit clairs** : Indique ce que tu as changé et pourquoi.
- **Teste tes modifications** : Assure-toi que tout fonctionne avant de soumettre ta MR.
- **Respecte le style de code** : Suis les conventions de style du projet.

## Ressources utiles

- [Guide de contribution GitHub](https://docs.github.com/en/get-started/quickstart)
- [Markdown Guide](https://www.markdownguide.org/)
- [Documentation du projet](lien_vers_la_documentation)

## Questions ?

Si tu as des questions ou besoin d'aide, n'hésite pas à ouvrir une issue ou à contacter un membre de l'équipe.

Merci de contribuer à notre projet ! Ensemble, nous pouvons créer quelque chose de formidable.

## Partager ses notes

### Mise en place du projet

Pour cela cloner le [projet](https://github.com/drkaine/darkaine), installé [rust](https://www.rust-lang.org/fr/tools/install) et [zola](https://www.getzola.org/documentation/getting-started/installation/) et enfin ajouté le thème [selena](https://github.com/isunjn/serene/blob/latest/USAGE.md) et build le site :
```
git submodule add -b latest https://github.com/isunjn/serene.git themes/serene
zola build # construit le html grâce au markdown
zola serve # lance un serveur local
```

### Participer

Pour cela créer un fichier markdown dans "content/notes". Le fichier doit débuter avec :
```
+++
title = "titre"
date = 2024-03-25
description = "description"
draft = false # false permet d'afficher la page

[taxonomies]
categories = ["categories"] # La catégorie sera créée automatiquement
tags = ["tags 1", "tags 2", "tags 3"] # Idem

[extra]
lang = "fr"
show_comment = false # ne pas afficher les commentaires
math = true # afficher les formules et signes mathématiques
mermaid = false # afficher les diagramme
outdate_warn = true # mettre une alerte de contenue dépassé
outdate_warn_days = 120 # le nombre de jours avant que l'alerte s'affiche

name = "" # Ton nom
id = "" # Ton id / peudo
bio = "" # Ta description
avatar = "img/avatar/avatar.jpeg" # Ton avatar, à ajouter dans "static/img/avatar"
links = [ # Tes liens
    {name = "GitHub", icon = "github", url = "https://github.com/NOM"},
    {name = "Twitter", icon = "twitter", url = "https://twitter.com/NOM"},
    {name = "Bluesky", icon = "bluesky", url = "https://bsky.app/profile/NOM.bsky.social"},
]

+++

Ce que tu veux partager en markdown
```

## Partager ses projets

Pour partager ses projets, il faut rajouter dans "content/projects/data.toml" :
```
[[project]]
author = "nom"
name = "nom du projet"
desc = "description du projet"
tags = ["tag"]
img = "chemin/image" # image à rajouter dans "static/img/projets"
links = [
  { name = "Site", url = "url" },
  { name = "Github", url = "lien vers le repos" },
]
```
## Evolution

Si tu as des idées d'évolution tu peux faire le développement dans une branche, ou créer une issue.