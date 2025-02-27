+++
title = "Premier Pas avec un VPS"
date = 2025-02-27
draft = false

[taxonomies]
categories = ["Configuration"]
tags = ["configuration", "infrastructure", "prise en main", "Darkaine"]

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

## Qu'est-ce qu'un VPS ?

Un VPS, ou Serveur Privé Virtuel, est un ordinateur virtuel dans le cloud. Au lieu d'avoir un ordinateur physique, un VPS offre un espace sur un serveur distant, plus ou moins puissant selon l'offre. Il se gère comme un ordinateur classique, installation et exécution de logiciels, mais à distance.

Imaginez-le comme une section isolée et sécurisée d'un grand ordinateur, où vous avez un contrôle total sur ce que vous y installez et sur la manière dont vous l'utilisez.

Les VPS sont souvent utilisés pour héberger des sites web, des applications ou pour effectuer des tâches informatiques spécifiques, offrant ainsi une flexibilité et une gestion plus simples que l'achat et la gestion de notre propre serveur physique.

### Les Avantages

Les VPS présentent plusieurs avantages :

- **Abordabilité** : Ils sont généralement moins chers que les serveurs physiques dédiés, ce qui les rend accessibles à un plus large éventail d'utilisateurs.
- **Scalabilité** : Il est possible, et généralement facile, d'ajuster les ressources (comme la puissance du processeur, la mémoire RAM et l'espace de stockage) en fonction des besoins.
- **Flexibilité** : Vous avez un contrôle total sur votre environnement virtuel, ce qui vous permet d'installer et de configurer les logiciels dont vous avez besoin, et de personnaliser les paramètres selon vos besoins.
- **Sécurité** : Ils offrent généralement un niveau de sécurité élevé, avec des fonctionnalités telles que des pare-feu et des mesures de protection contre les attaques DDoS.

### Les Inconvénients

Cependant, les VPS ont aussi des inconvénients :

- **Ressources Partagées** : Bien que chaque VPS soit isolé, les ressources physiques du serveur sont partagées entre plusieurs utilisateurs, ce qui peut parfois entraîner des problèmes de performances si d'autres utilisateurs consomment trop de ressources.
- **Dépendance au Fournisseur** : Vous dépendez du fournisseur de services pour la disponibilité et la fiabilité du serveur. Tout problème avec le fournisseur de services peut affecter votre VPS.
- **Compétences Techniques** : La gestion d'un VPS nécessite généralement une certaine expertise technique pour l'installation, la configuration et la maintenance du système d'exploitation et des logiciels.
- **Responsabilité de la Sécurité** : Bien que les fournisseurs offrent souvent des mesures de sécurité, la responsabilité de sécuriser votre VPS incombe toujours à l'utilisateur. Cela signifie que vous devez prendre des mesures appropriées pour protéger vos données et votre environnement contre les cybermenaces.
- **Possibilité de Surutilisation** : Si le fournisseur surcharge ses serveurs avec trop de VPS, cela peut entraîner une dégradation des performances pour tous les utilisateurs sur ce serveur.

## Premiers Pas avec un VPS

Après avoir sélectionné votre offre VPS, en choisissant votre RAM, votre CPU, votre OS et votre stockage, il faut récupérer l'adresse IP, le nom de l'utilisateur et le mot de passe. Une fois toutes ces informations en main, sur votre machine physique, créez une clé SSH.

```bash
ssh-keygen -t rsa -b 4096 -C "votre_email@example.com"
```

Ensuite, la commande suivante sert à se connecter à votre VPS :

```bash
NOM_Utilisateur@IPV4 # exemple ubuntu@00.00.000.000
```

Une des premières choses à faire une fois connecté est de changer votre mot de passe avec la commande :

```bash
passwd
```

Puis mettez à jour votre VPS (commande sous Linux) :

```bash
sudo apt update && sudo apt upgrade
```

Pour mettre à jour votre Linux :

```bash
do-release-upgrade
```

Pour redémarrer votre serveur :

```bash
sudo reboot
```

Il ne reste plus qu'à installer les gestionnaires de paquets et les langages que vous souhaitez utiliser, puis [configurer Git](/notes/git) pour pouvoir commencer à travailler. Pour avoir un site fonctionnel et ouvert, il faut avoir un nom de domaine, le rattacher au VPS et [configurer votre serveur (exemple : Apache ou Nginx)](/notes/configuration-server).

## Ressources Supplémentaires

- [DigitalOcean - Introduction to VPS](https://www.digitalocean.com/community/tutorials/what-is-a-vps) : Un guide d'introduction aux VPS.
- [Linode - Getting Started with a VPS](https://www.linode.com/docs/guides/getting-started-with-linode/) : Un guide pour débuter avec un VPS sur Linode.
- [Vultr - How to Set Up a VPS](https://www.vultr.com/docs/how-to-set-up-a-vps) : Un tutoriel sur la configuration d'un VPS.
- [AWS - What is a VPS?](https://aws.amazon.com/what-is/vps/) : Une explication des VPS dans le contexte d'AWS.
- [VPS vs. Dedicated Server](https://www.hostinger.com/tutorials/vps-vs-dedicated-server) : Un article comparant les VPS et les serveurs dédiés pour aider à choisir la meilleure option.
