+++
title = "Configurer un Serveur"
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

## Configuration générale

Pour configurer un serveur, il est essentiel d'avoir un nom de domaine et de relier le DNS à l'IP du serveur utilisé. Voici les étapes à suivre :

1. **Activer le module de réécriture** :
   ```bash
   sudo a2enmod rewrite
   ```

2. **S'assurer que le répertoire et son arborescence soient accessibles à l'utilisateur du serveur** (en général `data-web`) :
   ```bash
   sudo chmod -R 755 /chemin/vers/le/répertoire
   ```

3. **Avoir un projet à utiliser** : Assurez-vous que votre projet est prêt à être déployé sur le serveur.

## Configuration Apache

Apache est souvent installé par défaut sur de nombreux systèmes. Si ce n'est pas le cas, vous pouvez l'installer avec les commandes suivantes :

```bash
sudo apt update
sudo apt install apache2
```

### Création du fichier de configuration

Ensuite, il faut créer le fichier de configuration pour relier votre projet au nom de domaine :

```bash
sudo nano /etc/apache2/sites-available/nom-site.conf
```

### Exemple de configuration

Voici un exemple de configuration à insérer dans le fichier :

```apache
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

### Activation du site

Puis, il faut relier la configuration de `sites-available` avec `sites-enabled` et redémarrer le serveur :

```bash
sudo a2ensite nom_de_votre_site.conf
sudo systemctl restart apache2
```

Et voilà, votre site est en ligne !

## Configuration Nginx

Nginx n'est pas toujours installé par défaut, donc il faut l'installer et arrêter Apache si nécessaire :

```bash
sudo apt update
sudo apt install nginx
sudo systemctl stop apache2 
```

### Création du fichier de configuration

Ensuite, créez le fichier de configuration pour relier votre projet au nom de domaine :

```bash
sudo nano /etc/nginx/sites-available/nom-site.conf
```

### Exemple de configuration

Voici un exemple de configuration à insérer dans le fichier :

```nginx
server {
    server_name nom-de-domaine www.nom-de-domaine;
    root /chemin/vers/le/répertoire; # /public pour les frameworks;

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

### Activation du site

Puis, reliez la configuration de `sites-available` avec `sites-enabled` et redémarrez le serveur :

```bash
sudo ln -s /etc/nginx/sites-available/nom-site.conf /etc/nginx/sites-enabled/
sudo systemctl restart nginx
```

Et voilà, votre site est en ligne !

## Ajouter un Certificat SSL

Pour sécuriser votre site avec HTTPS, vous pouvez ajouter un certificat SSL. Voici comment procéder :

### Pour Nginx :

```bash
sudo apt-get install certbot python3-certbot-nginx -Y
sudo certbot --nginx -d www.nom-de-domaine
```

### Pour Apache :

```bash
sudo apt-get install certbot python3-certbot-apache
sudo certbot --apache -d www.nom-de-domaine
```

### Configuration du renouvellement automatique

Pour mettre en place un cron pour le renouvellement automatique du certificat :

```bash
sudo nano /etc/cron.d/certbot
sudo certbot renew --dry-run # pour simuler le renouvellement
```

## Nginx ou Apache ?

### Nginx

**Points positifs** :
- **Performance Élevée** : Nginx est reconnu pour ses performances élevées, surtout dans des environnements à forte charge.
- **Faible Utilisation de Mémoire** : Nginx a une faible empreinte mémoire, adapté aux environnements limités.
- **Évolutivité Horizontale** : Nginx est bien adapté à l'évolutivité horizontale.
- **Gestion des Requêtes Statiques** : Nginx excelle dans la gestion des requêtes statiques.

**Points négatifs** :
- **Configuration Complexe** : La configuration peut sembler plus complexe pour les nouveaux utilisateurs.
- **Modules Limités** : Certaines fonctionnalités avancées d'Apache peuvent manquer.

### Apache

**Points positifs** :
- **Maturité et Fiabilité** : Apache est l'un des serveurs web les plus anciens et les plus utilisés.
- **Module Richesse** : Offre une large gamme de modules supplémentaires.
- **Compatibilité** : Bien pris en charge par de nombreuses applications.
- **Configuration Facile** : Généralement considérée comme intuitive.

**Points négatifs** :
- **Utilisation de Mémoire** : Utilise généralement plus de ressources que Nginx.
- **Performance en Charge Élevée** : Peut être moins efficace que Nginx dans certaines situations.
- **Configuration Présumée par Processus** : Peut entraîner une surcharge en cas de trafic intense.

## Conclusion

Configurer un serveur peut sembler complexe, mais en suivant ces étapes, vous serez en mesure de mettre en place un environnement de production solide. Que vous choisissiez Apache ou Nginx, assurez-vous de bien comprendre les besoins de votre application et de choisir la solution qui convient le mieux. N'hésitez pas à consulter la documentation officielle pour des informations plus détaillées et des options avancées.

## Ressources Supplémentaires

- [Apache HTTP Server Documentation](https://httpd.apache.org/docs/) : Documentation officielle d'Apache.
- [Nginx Documentation](https://nginx.org/en/docs/) : Documentation officielle de Nginx.
- [Certbot Documentation](https://certbot.eff.org/docs/) : Documentation sur Certbot pour la gestion des certificats SSL.
- [DigitalOcean - How To Set Up Nginx](https://www.digitalocean.com/community/tutorials/how-to-set-up-nginx) : Un guide sur la configuration de Nginx.
- [DigitalOcean - How To Set Up Apache](https://www.digitalocean.com/community/tutorials/how-to-set-up-apache) : Un guide sur la configuration d'Apache.