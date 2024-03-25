+++
title = "Configurer Git"
date = 2024-03-20
draft = false

[taxonomies]
categories = ["Configuration"]
tags = ["configuration", "prise en main"]

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

### Pourquoi des commits signés

Avantages :
* Intégrité du code : Les commits signés garantissent l'intégrité du code en assurant qu'il n'a pas été altéré entre le moment où il a été signé et le moment où il est vérifié.

* Authenticité de l'auteur : Les signatures permettent de vérifier l'identité de l'auteur du commit. Cela aide à garantir que le code provient bien de la personne prétendue et non d'un tiers malveillant.

* Responsabilité accrue : Les commits signés lient l'auteur à son code de manière irréfutable, ce qui encourage une meilleure responsabilité en cas de problème ou de conflit.

* Conformité aux normes de sécurité : Dans certains contextes, comme les projets open source ou les entreprises travaillant avec des réglementations strictes, l'utilisation de commits signés peut être nécessaire pour respecter les normes de sécurité et de conformité.

* Confiance accrue : Les commits signés renforcent la confiance dans le code, car ils montrent un niveau d'engagement et de professionnalisme de la part de l'auteur.

Inconvénients :
* Complexité : La mise en place de commits signés peut être plus complexe, en particulier pour les nouveaux utilisateurs de Git. Cela implique la gestion de clés de chiffrement et la familiarisation avec les commandes associées.

* Ralentissement du processus : Le processus de signature peut ajouter une étape supplémentaire à la création et à la validation des commits, ce qui peut ralentir légèrement le flux de travail.

* Dépendance externe : La vérification des commits signés dépend de la disponibilité et de la validité des clés publiques des auteurs. Si les clés ne sont pas accessibles ou si elles sont compromises, cela peut compromettre l'intégrité du processus de signature.

* Incompatibilité avec certains flux de travail : Certains flux de travail de développement peuvent ne pas bénéficier des commits signés ou peuvent trouver leur intégration contraignante, en particulier dans les environnements moins formels ou moins sensibles aux questions de sécurité.

* Surcharge d'administration : La gestion des clés de chiffrement et la vérification des signatures peuvent ajouter une surcharge administrative, en particulier dans les grands projets avec de nombreux contributeurs.