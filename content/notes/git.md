+++
title = "Configurer Git"
date = 2024-03-20
description = "Configurer git en global et avoir des commit signés"

[taxonomies]
categories = ["Configuration"]
tags = ["configuration", "prise en main"]

[extra]
lang = "fr"

+++

## Configurer de façon global Git

D'abord on commence par mettre les variables du user dans la config :
```
git congig --global user.name "nom"
git congig --global user.email "nom@test.fr"
```

Ensuite il faut créer une clef SSH :
```
ssh -keygen -t rsa -bb 4096 -C "nom@test.fr"
```

Démarrer l'agent SSH et configure votre shell pour communiquer avec lui :
```
eval "$(ssh-agent -s)"
```

Pour ajouter des clés privées SSH à l'agent SSH en cours d'exécution. L'agent SSH est un programme qui gère les clés privées et permet à l'utilisateur de se connecter à des serveurs sans avoir à spécifier manuellement la clé privée à chaque fois :
```
ssh-add  ~/.ssh/id_rsa
```

Il ne reste plus qu'à ajouter la clef publique sur [github](https://github.com/settings/keys):
```
cat ~/.ssh/id_rsa.pub
```

## Avoir des commit signés

En premier, s'il n'est pas installé de base, installer GnuPG(GPG) :
```
sudo apt update
sudo apt install gnupg
```

Ensuite générer une clef et l'afficher :
```
gpg --full-generate-key
gpg --list-secret-keys --keyid-format LONG
```

Le terminal nous affiche :
```
$ gpg --list-secret-keys --keyid-format=long
/Users/hubot/.gnupg/secring.gpg
------------------------------------
sec   4096R/3AA5C34371567BD2 2016-03-10 [expires: 2017-03-10]
uid                          Hubot <hubot@example.com>
ssb   4096R/4BB6D45482678BE3 2016-03-10

# l'id est 3AA5C34371567BD2
```

L'ajouter à la config Git :
```
git config --global user.signkey ID_GPG
git config --global commit.gpgSign true # signer les commits automatiquement
```

Puis il faut rajouter la clef dans github :
```
gpg --armor --export ID_GPG
```
Voir la doc [github](https://docs.github.com/fr/authentication/managing-commit-signature-verification/generating-a-new-gpg-key)