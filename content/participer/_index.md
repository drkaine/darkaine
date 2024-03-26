+++
title = "Participer"
description = "Tu veux partager tes notes ? Voici la marche à suivre"
template = "prose.html"
insert_anchor_links = "none"

[extra]
lang = 'fr'
+++

## Partager ses notes

Bonjour,

Ce site me sert à conserver les notes prises lors de ma veille, mes lectures, etc. J'ai pensé que tant qu'à être en ligne, autant en faire profiter les autres. Le répertoire est public, et tout le monde peut partager ses notes, projets et autres.

Tu crées une branche, publie ta branche, demande une merge request et se sera en ligne 😀.

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

