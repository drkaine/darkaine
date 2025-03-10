+++
title = "Les Git Hooks : Automatiser et Optimiser votre Workflow Git"
date = 2025-03-10
draft = false
[taxonomies]
categories = ["DevOps"]
tags = ["CI/CD", "déploiement", "automatisation", "Git", "Darkaine"]
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

# Les Git Hooks : Automatiser et Optimiser votre Workflow Git

> *Les Git Hooks transforment votre workflow de développement en automatisant les tâches répétitives et en garantissant la qualité du code à chaque étape.*

# Qu'est-ce qu'un Git Hook ?
Les Git Hooks sont des scripts qui s'exécutent automatiquement lorsque certains événements se produisent dans un dépôt Git. Ces événements peuvent survenir côté client (sur votre machine locale) ou côté serveur. Les hooks permettent aux développeurs d'automatiser des tâches, d'appliquer des standards de qualité et d'améliorer le workflow de développement.

# Comment fonctionnent les Git Hooks ?
Chaque dépôt Git contient un répertoire caché `.git/hooks` qui inclut des exemples de scripts pour différents hooks. Ces scripts peuvent être écrits dans n'importe quel langage exécutable (Bash, Python, Ruby, etc.) et doivent être nommés correctement pour être activés.
Pour activer un hook, il suffit de créer un fichier exécutable avec le nom approprié dans le répertoire `.git/hooks`, sans extension.

```bash
# Rendre un hook exécutable
chmod +x .git/hooks/pre-commit
```

# Types de Git Hooks
## Hooks côté client
### Hooks de commit
- **pre-commit** : Exécuté avant qu'un commit ne soit créé. Utilisé pour valider le contenu du commit (linting, tests unitaires, etc.). Peut empêcher le commit si les vérifications échouent.
- **prepare-commit-msg** : Exécuté avant que l'éditeur de message de commit ne s'ouvre. Permet de modifier le message par défaut.
- **commit-msg** : Vérifie le message de commit. Peut imposer un format spécifique (par exemple, suivre les conventions de commits conventionnels).
- **post-commit** : Exécuté après la création d'un commit. Utilisé pour des notifications ou pour déclencher des actions.

### Hooks d'email
- **applypatch-msg**, **pre-applypatch**, **post-applypatch** : Utilisés dans le workflow des patches par email.

### Autres hooks client
- **pre-rebase** : Exécuté avant un rebase. Peut empêcher le rebase dans certaines conditions.
- **post-checkout** : Exécuté après un checkout ou un clone. Utilisé pour configurer l'environnement de travail.
- **post-merge** : Exécuté après une fusion. Peut être utilisé pour restaurer des données qui ne sont pas sous contrôle de version.
- **pre-push** : Exécuté avant un push. Vérifie que le push est autorisé et conforme aux standards.

## Hooks côté serveur
- **pre-receive** : Exécuté lorsque le serveur reçoit un push. Peut rejeter le push basé sur des règles spécifiques.
- **update** : Similaire à pre-receive mais exécuté pour chaque branche.
- **post-receive** : Exécuté après qu'un push a été accepté. Utilisé pour des notifications, déploiements continus, etc.

# Exemples concrets de Git Hooks
## Hook pre-commit pour vérifier le code
```bash
#!/bin/bash

echo "Exécution des linters et des tests..."

# Exécution d'un linter
npm run lint
LINT_RESULT=$?

# Exécution des tests unitaires
npm test
TEST_RESULT=$?

# Vérification des résultats
if [ $LINT_RESULT -ne 0 ] || [ $TEST_RESULT -ne 0 ]; then
  echo "❌ Les vérifications ont échoué. Commit annulé."
  exit 1
fi

echo "✅ Toutes les vérifications ont réussi."
exit 0
```
## Hook commit-msg pour valider le format du message
```bash
#!/bin/bash

commit_msg_file=$1
commit_msg=$(cat "$commit_msg_file")

# Vérification du format "type(scope): message"
if ! echo "$commit_msg" | grep -qE "^(feat|fix|docs|style|refactor|perf|test|chore)(\([a-z]+\))?: .+"; then
  echo "❌ Format de message incorrect."
  echo "Le message doit suivre le format: type(scope): message"
  echo "Types autorisés: feat, fix, docs, style, refactor, perf, test, chore"
  exit 1
fi

echo "✅ Format de message valide."
exit 0
```
## Hook post-receive pour le déploiement automatique
```bash
#!/bin/bash

# Chemin vers le répertoire de déploiement
DEPLOY_DIR="/var/www/monapp"

# Branche à déployer
DEPLOY_BRANCH="main"

while read oldrev newrev ref; do
  branch=$(echo $ref | cut -d/ -f3)
  
  if [ "$branch" = "$DEPLOY_BRANCH" ]; then
    echo "Déploiement de la branche $DEPLOY_BRANCH vers $DEPLOY_DIR"
    
    # Checkout du code dans le répertoire de déploiement
    GIT_WORK_TREE=$DEPLOY_DIR git checkout -f $DEPLOY_BRANCH
    
    # Exécution des commandes de déploiement
    cd $DEPLOY_DIR
    npm install
    npm run build
    
    echo "✅ Déploiement terminé avec succès."
  fi
done
```

# Partage des Git Hooks avec l'équipe
Les hooks étant stockés dans `.git/hooks`, ils ne sont pas versionnés par défaut. Plusieurs solutions existent pour les partager :
## Utiliser un répertoire personnalisé
```bash
# Dans le dépôt Git
git config core.hooksPath .githooks
```
## Utiliser un gestionnaire de hooks
- **Husky** pour les projets Node.js
- **pre-commit** pour Python
- **git-hooks** comme solution polyvalente

Exemple de configuration avec Husky (dans package.json) :
```json
{
  "husky": {
    "hooks": {
      "pre-commit": "npm run lint && npm test",
      "commit-msg": "commitlint -E HUSKY_GIT_PARAMS"
    }
  }
}
```

# Bonnes pratiques
1. **Gardez les hooks légers et rapides** - Les hooks qui prennent du temps peuvent frustrer les développeurs.
2. **Offrez un moyen de contournement** - Dans certaines situations, il peut être nécessaire de contourner un hook.
   ```bash
   git commit --no-verify
   ```
3. **Documentez vos hooks** - Assurez-vous que tous les membres de l'équipe comprennent ce que font les hooks.
4. **Testez vos hooks** - Avant de les déployer, assurez-vous qu'ils fonctionnent correctement.
5. **Séparez les préoccupations** - Chaque hook devrait avoir une responsabilité unique et claire.

# Conclusion
Les Git Hooks sont des outils puissants pour automatiser et standardiser les workflows de développement. Ils permettent d'améliorer la qualité du code, d'assurer la cohérence des messages de commit et d'automatiser des tâches répétitives. En intégrant des Git Hooks à votre flux de travail, vous pouvez considérablement améliorer la productivité et la qualité de vos projets.
En maîtrisant l'art des Git Hooks, vous transformerez Git d'un simple outil de contrôle de version en une plateforme d'automatisation complète pour votre équipe de développement.