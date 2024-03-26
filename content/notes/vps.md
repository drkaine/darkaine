+++
title = "Premier pas avec un VPS"
date = 2024-03-20
draft = false

[taxonomies]
categories = ["Configuration"]
tags = ["configuration", "infrastructure", "prise en main", "Darkaine"]

[extra]

name = "Darkaine"                     # Your name
bio = "Je découvre, j'apprends, je prend des notes et je partage mes mémos."                          # Your bio
avatar = "img/avatar.jpeg"            # Your avatar
links = [                             # Your links
    {name = "GitHub", icon = "github", url = "https://github.com/drkaine"},
    {name = "Twitter", icon = "twitter", url = "https://twitter.com/Darkaine1"},
    {name = "Bluesky", icon = "bluesky", url = "https://bsky.app/profile/darkaine.bsky.social"},
]

+++

## Qu'est ce qu'un VPS :

Un VPS, ou Serveur Privé Virtuel, est un ordinateur virtuel dans le cloud. Au lieu d'avoir un ordinateur physique, un VPS offre un espace sur un serveur distant, plus ou moins puissant selon l'offre. Il se gère comme un ordinateur classique, installation et exécution de logiciels, mais à distance.

Imaginez-le comme une section isolée et sécurisée d'un grand ordinateur, où vous avez un contrôle total sur ce que vous y installez et sur la manière dont vous l'utilisez.

Les VPS sont souvent utilisés pour héberger des sites web, des applications ou pour effectuer des tâches informatiques spécifiques, offrant ainsi une flexibilité et une gestion plus simples que l'achat et la gestion de notre propre serveur physique.


### Les avantages :

Les VPS ont comme avantages :

* D'être abordables : ils sont généralement moins chers que les serveurs physiques dédiés, ce qui les rend accessibles à un plus large éventail d'utilisateurs.
* La scalabilité : il est possible, et généralement facile, d'ajuster les ressources (comme la puissance du processeur, la mémoire RAM et l'espace de stockage) en fonction des besoins.
* La flexibilité : on a un contrôle total sur notre environnement virtuel, ce qui nous permet d'installer et de configurer les logiciels dont on a besoin, et de personnaliser les paramètres selon nos besoins.
* La sécurité : ils offrent généralement un niveau de sécurité élevé, avec des fonctionnalités telles que des pare-feu et des mesures de protection contre les attaques DDoS.


### Les inconvénients :


Les VPS ont comme inconvénients :

* Des ressources partagées : bien que chaque VPS soit isolé, les ressources physiques du serveur sont partagées entre plusieurs utilisateurs, ce qui peut parfois entraîner des problèmes de performances si d'autres utilisateurs consomment trop de ressources.
* Une dépendance au fournisseur : on dépend du fournisseur de services pour la disponibilité et la fiabilité du serveur. Tout problème avec le fournisseur de services peut affecter notre VPS.
* Des compétences techniques : la gestion d'un VPS nécessite généralement une certaine expertise technique pour l'installation, la configuration et la maintenance du système d'exploitation et des logiciels.
* La responsabilité de la sécurité : Bien que les fournisseurs offrent souvent des mesures de sécurité, la responsabilité de sécuriser notre VPS incombe toujours à l'utilisateur. Cela signifie que nous devons prendre des mesures appropriées pour protéger nos données et notre environnement contre les cybermenaces.
* La possibilité de surutilisation : Si le fournisseur surcharge ses serveurs avec trop de VPS, cela peut entraîner une dégradation des performances pour tous les utilisateurs sur ce serveur.


## Premiers pas avec un VPS

Après avoir sélectionné son offre VPS, en choisissant sa RAM, son CPU, son OS et son stockage, il faut récupérer l'adresse IP, le nom de l'utilisateur et le mot de passe. Une fois toutes ces informations en main, sur sa machine physique, on se crée une clé SSH.

 ``` 
 ssh-keygen -t rsa -b 4096 -C "your_email@example.com" 
 ```

Ensuite, la commande suivante sert à se connecter à son VPS :

 ``` 
 NOM_Utilisateur@IPV4 # exemple ubuntu@00.00.000.000 
 ```

Une des premières choses à faire une fois connecté est de changer son mot de passe avec la commande :

 ``` 
 passwd 
 ```

Puis mettre à jour son VPS (commande sous Linux) :

``` 
sudo apt update & sudo apt upgrade 
```

Pour mettre à jours son Linux :
```
do-release-upgrade
```

Pour redémarrer son serveur :

``` 
sudo reboot 
```

Il ne reste plus qu'à installer les gestionnaires de paquets et les langages que nous voulons utiliser puis [configurer Git](/notes/git) pour pouvoir commencer à travailler. Pour avoir un site fonctionnel et ouvert, il faut avoir un nom de domaine, le rattacher au VPS et [configurer son serveur (exemple : apache ou nginx)](/notes/configuration-server).
