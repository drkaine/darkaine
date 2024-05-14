+++
title = "Configurer un serveur"
date = 2024-03-20
draft = false

[taxonomies]
categories = ["Configuration"]
tags = ["configuration", "infrastructure", "prise en main", "Darkaine"]

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

## Configuration générale

Il faut avoir un nom de domaine et relier le DNS à l'IP du serveur utilisé.
Activer le rewrite :
```
sudo a2enmod rewrite
```

S'assurer que le répertoire et son arborescence soient accessibles à l'utilisateur du serveur (en général data-web) :
```
sudo chmod -R 755 chemin/vers/le/répertoire
```

Et avoir un projet à utiliser.

## Configuration Apache

En général, il est installé par défaut, sinon :
```
sudo apt update
sudo apt install apache2
```

Ensuite, il faut créer le fichier de configuration pour relier notre projet au nom de domaine :
```
sudo nano /etc/apache2/sites-available/nom-site.conf
```

Et y mettre la config :
```
<VirtualHost *:80>
    ServerName monsite.com
    ServerAlias www.monsite.com

    DocumentRoot /var/www/monsite.com/public_html

    <Directory /var/www/monsite.com/public_html>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/monsite_error.log
    CustomLog ${APACHE_LOG_DIR}/monsite_access.log combined
</VirtualHost>

```

Puis, il faut relier la configuration de sites-available avec sites-enabled et redémarrer le serveur :
```
sudo a2ensite nom_de_votre_site.conf
sudo systemctl restart apache2
```

Et voilà, votre site est en ligne.


## Configuration Nginx

En général, il n'est pas installé par défaut, donc il faut l'installer et arrêter Apache :
```
sudo apt update
sudo apt install nginx
sudo systemctl stop apache2 
```

Ensuite, il faut créer le fichier de configuration pour relier notre projet au nom de domaine :
```
sudo nano /etc/nginx/sites-available/nom-site.conf
```

Et y mettre la config :
```
server {

    server_name nom-de-domaine www.nom-de-domaine;
    root chemin/vers/le/répertoire #/public pour les frameworks;

    index index.html index.htm index.php;
    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt { access_log off; log_not_found off; }
    error_page 404 /index.php;

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
```

Puis, il faut relier la configuration de sites-available avec sites-enabled et redémarrer le serveur :
```
sudo a2ensite /etc/nginx/sites-available/nom-site.conf
sudo systemcl restart nginx
```

Et voilà, votre site est en ligne.


## Ajouter un certificat SSL

On peut y rajouter un certificat pour être en HTTPS 
* pour Nginx :
```
sudo apt-get install cerbot python3-cerbot-nginx -Y
sudo cerbot --nginx -d www.nom-de-domaine
```

* pour Apache :
```
sudo apt-get install certbot python3-certbot-apache
sudo certbot --apache -d www.nom-de-domaine
```

Pour mettre en place un cron pour le renouvellement automatique du certificat :
```
sudo nano /etc/cron.d/certbot
sudo certbot renew --dry-run # pour simuler le renouvellement
```

## Nginx ou apache ?

### Nginx

Points positifs :
* Performance Élevée : Nginx est largement reconnu pour ses performances élevées, en particulier dans des environnements à forte charge ou avec de nombreuses connexions simultanées, grâce à son modèle asynchrone et orienté vers les événements.
* Faible Utilisation de Mémoire : Nginx est connu pour sa faible empreinte mémoire, ce qui le rend adapté aux environnements où les ressources sont limitées.
* Évolutivité Horizontale : Nginx est bien adapté à l'évolutivité horizontale, ce qui signifie qu'il peut facilement être déployé sur plusieurs serveurs pour équilibrer la charge.
* Gestion des Requêtes Statiques : Nginx excelle dans la gestion des requêtes statiques, telles que les fichiers CSS, JavaScript et les images.

Points négatifs :
* Configuration Complex : Pour les nouveaux utilisateurs, la configuration de Nginx peut sembler plus complexe que celle d'Apache en raison de sa syntaxe non conventionnelle et de son approche de configuration basée sur les directives.
* Modules Limités : Bien que Nginx dispose de nombreux modules, il peut manquer de certaines fonctionnalités avancées disponibles dans Apache en raison de son approche plus modulaire.

### Apache

Points positifs :
* Maturité et Fiabilité : Apache est l'un des serveurs web les plus anciens et les plus largement utilisés. Il a une communauté établie et une longue histoire de développement.
* Module Richesse : Apache offre une large gamme de modules supplémentaires pour étendre ses fonctionnalités, ce qui le rend très flexible et adaptable à différents besoins.
* Compatibilité : En raison de sa longue histoire et de sa popularité, Apache est bien pris en charge par de nombreuses applications et frameworks.
* Configuration facile : La configuration d'Apache est généralement considérée comme relativement simple et intuitive, en particulier pour ceux qui sont familiers avec la syntaxe basée sur les fichiers .htaccess.

Points négatifs :
* Utilisation de Mémoire : Apache utilise généralement plus de ressources système que Nginx, en particulier lorsqu'il gère un grand nombre de connexions simultanées.
* Performance en Charge élevée : Bien qu'Apache soit capable de gérer des charges de trafic importantes, il peut être moins efficace que Nginx dans certaines situations de haute charge en raison de son modèle de traitement des requêtes.
* Configuration Présumée par Processus : La configuration par défaut d'Apache utilise un modèle de processus présumé, où chaque demande crée un nouveau processus ou un nouveau thread, ce qui peut entraîner une surcharge du système en cas de trafic intense.