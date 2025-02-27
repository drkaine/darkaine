+++
title = "Commandes linux à retenir"
date = 2025-02-27
draft = false
outdate_alert = false

[taxonomies]
categories = ["Cheatsheet"]
tags = ["cheatsheet", "command", "linux", "Darkaine"]

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

## Commandes Linux à retenir

Voici une liste de commandes Linux essentielles, accompagnées d'exemples d'utilisation pour mieux comprendre leur fonctionnement :

* **`pwd`** : Affiche le chemin du répertoire courant.
  ```bash
  pwd
  # Exemple de sortie : /home/user
  ```

* **`ls`** : Liste le contenu du répertoire courant.
  - **`-l`** : Affiche en version longue (détails).
  - **`-a`** : Affiche les fichiers cachés.
  ```bash
  ls -la
  # Exemple de sortie :
  # drwxr-xr-x  5 user user 4096 févr. 27 12:00 .
  # drwxr-xr-x  3 user user 4096 févr. 27 12:00 ..
  # -rw-r--r--  1 user user    0 févr. 27 12:00 fichier.txt
  ```

* **`cd`** : Change de répertoire.
  ```bash
  cd /chemin/vers/le/répertoire
  ```

* **`mkdir`** : Crée un nouveau dossier.
  ```bash
  mkdir nouveau_dossier
  ```

* **`clear`** : Nettoie le terminal.
  ```bash
  clear
  ```

* **`mv`** : Déplace ou renomme un fichier ou un dossier.
  ```bash
  mv ancien_nom.txt nouveau_nom.txt
  ```

* **`cp`** : Copie un fichier ou un dossier.
  ```bash
  cp fichier.txt /chemin/vers/le/nouveau_dossier/
  ```

* **`touch`** : Crée un fichier vide ou met à jour la date d'accès d'un fichier.
  ```bash
  touch nouveau_fichier.txt
  ```

* **`cat`** : Affiche le contenu d'un fichier.
  ```bash
  cat fichier.txt
  ```

* **`head`** : Affiche les premières lignes d'un fichier.
  - **`-n NOMBRE`** : Spécifie le nombre de lignes à afficher.
  ```bash
  head -n 5 fichier.txt
  ```

* **`tail`** : Affiche les dernières lignes d'un fichier.
  - **`-n NOMBRE`** : Spécifie le nombre de lignes à afficher.
  - **`-f`** : Surveille le fichier de façon dynamique.
  ```bash
  tail -f fichier.log
  ```

* **`wget`** : Télécharge un fichier depuis le web.
  ```bash
  wget https://exemple.com/fichier.zip
  ```

* **`rm`** : Supprime un fichier ou un dossier.
  - **`-R`** : Supprime un dossier et tout son contenu.
  ```bash
  rm -R dossier_a_supprimer
  ```

* **`grep`** : Recherche une expression régulière (REGEX) dans un fichier.
  ```bash
  grep "texte_a_rechercher" fichier.txt
  ```

* **`wc`** : Compte le nombre de mots, de lignes et de caractères dans un fichier.
  ```bash
  wc fichier.txt
  ```

* **`history`** : Affiche l'historique des commandes du terminal.
  ```bash
  history
  ```

* **`sudo`** : Exécute une commande avec les droits d'administrateur.
  ```bash
  sudo apt update
  ```

* **`chmod`** : Change les permissions d'un fichier ou d'un dossier.
  ```bash
  chmod 755 fichier.txt
  ```

* **`chown`** : Change le propriétaire d'un fichier ou d'un dossier.
  ```bash
  chown user:user fichier.txt
  ```

* **`find`** : Recherche des fichiers dans un répertoire.
  ```bash
  find /chemin/vers/le/répertoire -name "*.txt"
  ```

* **`tar`** : Archive ou extrait des fichiers.
  - Pour créer une archive :
  ```bash
  tar -cvf archive.tar /chemin/vers/le/répertoire
  ```
  - Pour extraire une archive :
  ```bash
  tar -xvf archive.tar
  ```

* **`df`** : Affiche l'espace disque utilisé et disponible.
  ```bash
  df -h
  ```

* **`top`** : Affiche les processus en cours et leur utilisation des ressources.
  ```bash
  top
  ```

## Conclusion

Ces commandes Linux sont essentielles pour naviguer et gérer votre système. En les maîtrisant, vous pourrez travailler plus efficacement dans un environnement Linux. N'hésitez pas à consulter la documentation officielle ou à utiliser la commande `man` pour obtenir plus d'informations sur chaque commande. Par exemple, pour obtenir des détails sur `ls`, vous pouvez utiliser :

```bash
man ls
```

Cela vous donnera accès à la page de manuel de la commande, où vous trouverez des options supplémentaires et des exemples d'utilisation.

## Ressources Supplémentaires

- [Linux Command Line Documentation](https://linuxcommand.org/) : Documentation complète sur les commandes Linux.
- [The Linux Documentation Project](https://www.tldp.org/) : Un projet qui fournit des guides et des manuels sur Linux.
- [Explainshell](https://explainshell.com/) : Un outil pour expliquer les commandes shell.