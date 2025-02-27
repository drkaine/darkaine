+++
title = "Configurer Git"
date = 2025-02-27
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

## Configurer de façon globale Git

Pour commencer, il est essentiel de configurer les informations de l'utilisateur dans Git. Cela permet d'associer vos commits à votre identité. Voici comment procéder :

1. **Configurer le nom d'utilisateur** :
   ```bash
   git config --global user.name "Votre Nom"
   ```

2. **Configurer l'adresse e-mail** :
   ```bash
   git config --global user.email "votre.email@example.com"
   ```

### Vérification de la Configuration

Pour vérifier que vos informations sont correctement configurées, vous pouvez utiliser la commande suivante :

```bash
git config --list
```

Cela affichera toutes les configurations, y compris votre nom et votre e-mail.

## Créer une Clé SSH

Pour interagir avec des dépôts distants, il est recommandé de créer une clé SSH. Voici comment procéder :

1. **Générer une clé SSH** :
   ```bash
   ssh-keygen -t rsa -b 4096 -C "votre.email@example.com"
   ```

   Suivez les instructions à l'écran pour choisir l'emplacement et le mot de passe de la clé.

2. **Démarrer l'agent SSH** :
   ```bash
   eval "$(ssh-agent -s)"
   ```

3. **Ajouter votre clé SSH à l'agent** :
   ```bash
   ssh-add ~/.ssh/id_rsa
   ```

4. **Ajouter la clé publique à GitHub** :
   Copiez la clé publique dans votre presse-papiers :
   ```bash
   cat ~/.ssh/id_rsa.pub
   ```

   Ensuite, allez dans les paramètres de votre compte GitHub, sous "SSH and GPG keys", et ajoutez une nouvelle clé SSH.

## Avoir des Commits Signés

Pour garantir l'intégrité de vos commits, vous pouvez les signer avec GnuPG (GPG). Voici comment configurer cela :

1. **Installer GnuPG** :
   ```bash
   sudo apt update
   sudo apt install gnupg
   ```

2. **Générer une clé GPG** :
   ```bash
   gpg --full-generate-key
   ```

   Suivez les instructions pour créer votre clé.

3. **Lister vos clés secrètes** :
   ```bash
   gpg --list-secret-keys --keyid-format LONG
   ```

   Notez l'ID de votre clé (par exemple, `3AA5C34371567BD2`).

4. **Ajouter la clé à la configuration Git** :
   ```bash
   git config --global user.signkey ID_GPG
   git config --global commit.gpgSign true  # Signer les commits automatiquement
   ```

5. **Ajouter la clé à GitHub** :
   Exportez votre clé publique :
   ```bash
   gpg --armor --export ID_GPG
   ```

   Ajoutez cette clé dans les paramètres de votre compte GitHub sous "GPG keys".

## Pourquoi des Commits Signés ?

### Avantages :
- **Intégrité du Code** : Les commits signés garantissent que le code n'a pas été altéré.
- **Authenticité de l'Auteur** : Vérifie l'identité de l'auteur du commit.
- **Responsabilité Accrue** : L'auteur est lié à son code, ce qui encourage une meilleure responsabilité.

### Inconvénients :
- **Complexité** : La mise en place peut être complexe pour les nouveaux utilisateurs.
- **Ralentissement du Processus** : Le processus de signature peut ajouter une étape supplémentaire.
- **Dépendance Externe** : La vérification des commits signés dépend de la disponibilité des clés publiques.

## Conclusion

Configurer Git correctement est essentiel pour un développement efficace. En suivant ces étapes, vous vous assurez que vos contributions sont bien identifiées et sécurisées. N'hésitez pas à consulter la documentation officielle de Git pour plus d'informations et d'options avancées.

## Ressources Supplémentaires

- [Git Documentation](https://git-scm.com/doc) : Documentation officielle de Git.
- [Pro Git Book](https://git-scm.com/book/en/v2) : Un livre complet sur Git, disponible en ligne.
- [GitHub Guides](https://guides.github.com/) : Guides pratiques pour utiliser Git et GitHub.
- [SSH Keys on GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh) : Instructions pour configurer des clés SSH sur GitHub.
- [GPG for Signing Commits](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/generating-a-new-gpg-key) : Guide pour générer une clé GPG pour signer vos commits.