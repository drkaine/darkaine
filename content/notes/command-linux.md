+++
title = "Commandes linux à retenir"
date = 2024-03-26
draft = false
outdate_alert = false

[taxonomies]
categories = ["Cheatsheet"]
tags = ["cheatsheet", "command", "linux", "Darkaine"]

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

## Commandes linux à retenir

* pwd => savoir où on est, donne le chemin du répertoire courant
* ls => liste le contenue du répertoire courant :
    - -l version longue
    - -a affiche les dossiers caché
* cd => sert à ce déplacer dans un autre dossier
* [tab] => auto-clomplétion
* mkdir => crée un nouveau dossier
* clear => nettoie le terminal
* mv => sert à déplacer un élément (dossier ou fichier) et permet aussi de le renomer
* cp => copie un dossier
* touch => crée un fichier
* cat => affiche le contenu d'un fichier
* head => affiche les premières lignes d'un fichier
    - -n NOMBRE => le nombre de lignes
* tail -> affiche lignes d'un fichier :
    - -n NOMBRE => le nombre de lignes
    - -f => surveille le fichier de façon dynamique
* wget => télécharger un élément
* rm => supprime un fichier
    - -R => supprime le dossier et tout ce qui est dedans
* grep => recherche une expréssion régulière (REGEX) dans un fichier
* wc => compte le nombre de mot, ligne et character d'un fichier
* history => affiche l'historique des commandes du terminal
* sudo => permet d'avoir les droits root pour la commande qui suit