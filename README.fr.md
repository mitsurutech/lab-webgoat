# Lab OWASP WebGoat avec Docker Compose : leçons guidées de sécurité web, avec WebWolf, dans une copie privée

[English](README.md) | [Français](README.fr.md) | [日本語](README.ja.md) | [Español](README.es.md)

[![check](https://github.com/mitsurutech/lab-webgoat/actions/workflows/check.yml/badge.svg)](https://github.com/mitsurutech/lab-webgoat/actions/workflows/check.yml)

Un **lab de sécurité des applications web** prêt à l’emploi pour la classe, proposé par la [plateforme d’apprentissage MitsuruTech](https://mitsurutech.co.uk/fr/learning), où les écoles et les établissements donnent à chaque élève ses propres bases de données, conteneurs et terminal dans le navigateur. Chaque élève reçoit sa propre copie d’**OWASP WebGoat**, un parcours guidé de leçons qui expliquent chacune une faille (injection, contrôle d’accès défaillant, désérialisation non sécurisée, erreurs de JWT, traversée de répertoires et plus encore) puis demandent à l’élève de l’exploiter, avec **WebWolf** à côté pour les leçons qui ont besoin d’un second acteur. Il convient pour une première introduction et pour du travail à faire à la maison, sans rien installer et sans risque pour la machine de quiconque.

C’est un seul fichier `docker-compose`, `compose.yaml`, qui fonctionne de la même façon sur votre machine et sur la plateforme, où chaque élève dispose d’une copie privée sans aucune sortie vers Internet.

## La règle à retenir

**Attaquez votre propre copie, et rien d’autre.** Tout ce que fait ce lab se passe dans votre copie privée, qui n’a aucune route vers Internet ni vers les autres élèves : la seule chose que vous pouvez atteindre est l’application que le lab a démarrée pour vous. Ne dirigez jamais un outil vers un site web, un réseau ou une machine qui ne vous appartient pas, dans un lab comme ailleurs : au Royaume-Uni, c’est une infraction au titre du [Computer Misuse Act 1990](https://www.legislation.gov.uk/ukpga/1990/18/contents), et la plupart des pays ont une loi équivalente. Comprendre comment fonctionnent les failles, c’est apprendre à écrire des logiciels qui n’en ont pas, et une bonne première discussion en classe porte sur la raison d’être de cette règle et sur ce qu’est la divulgation responsable.

## Ce que contient le lab

| Service | Image | Mémoire | Ce que c’est |
| --- | --- | --- | --- |
| `webgoat` | [`webgoat/webgoat:v2026.5`](https://hub.docker.com/r/webgoat/webgoat) | 1 Go | WebGoat et WebWolf, des applications Java, exécutées sous un compte sans privilèges (1001) et sans aucune capacité |
| `web` | [`nginx:1.27-alpine`](https://hub.docker.com/_/nginx) | 64 Mo | un petit proxy placé devant |

Le proxy n’est là que pour une raison : WebGoat répond 404 sur `/` et vit à `/WebGoat`, si bien que le lien du lab ouvrirait une page d’erreur. Il renvoie `/` vers `/WebGoat/` et transmet tout le reste avec l’adresse propre du navigateur. WebGoat reçoit un gigaoctet, le plus parmi les trois labs de sécurité, car c’est une application Java ; il démarre en environ sept secondes et utilise à peu près 450 Mo en usage léger.

Les images sont des programmes tiers, exécutés sans modification à partir des images publiques des projets eux-mêmes et figées sur une version (jamais `latest`), de sorte que le lab ne change pas sous les pieds d’une classe d’une leçon à l’autre. Rien n’est construit ici et rien de ce dépôt n’est distribué dans ces images.

## L’utiliser sur la plateforme

La [plateforme d’apprentissage MitsuruTech](https://mitsurutech.co.uk/fr/learning) donne à chaque élève sa propre copie d’un lab, dans le navigateur, avec un terminal à côté.

**Pour l’essayer :** ouvrez la [page des conteneurs](https://mitsurutech.co.uk/fr/container), trouvez ce lab dans **Laboratoires d’exemple** et appuyez sur Démarrer. Aucun compte n’est nécessaire pour en essayer un.

**Pour le donner comme travail à une classe :**

1. Dans votre module, créez une tâche de type **Lab** et choisissez **Dans un dépôt GitHub**.
2. Indiquez `https://github.com/mitsurutech/lab-webgoat` avec la branche `main`. Le fichier compose par défaut est `compose.yaml`. Faites d’abord un fork du dépôt si vous voulez modifier le fichier.
3. Publiez. La copie de chaque élève part du commit que vous avez publié, de sorte qu’une modification ultérieure ici ne change pas un lab déjà donné.
4. Précisez dans la tâche ce qu’il faut rendre (voir [Pour les enseignants](#pour-les-enseignants)), puis distribuez-la comme n’importe quelle autre tâche.

Le [guide des labs de sécurité](https://mitsurutech.co.uk/fr/help/security-labs) du manuel et son [guide des labs de conteneurs](https://mitsurutech.co.uk/fr/help/labs) disent le reste : ce qu’un fichier compose peut contenir, la mémoire dont dispose une copie, et comment un enseignant ouvre, suit et note la copie d’un élève.

Pas encore de compte d’établissement ? [La première année est gratuite](https://mitsurutech.co.uk/fr/pricing) jusqu’à 50 élèves, et [l’inscription](https://mitsurutech.co.uk/fr/signup) ne demande qu’une adresse e-mail.

## L’exécuter sur votre propre machine

Il vous faut Docker avec le plugin Compose. Le premier démarrage télécharge les images.

```bash
docker compose -f compose.yaml -f local.yaml up
```

Ouvrez <http://localhost:8080/WebGoat> pour WebGoat et <http://localhost:9090/WebWolf> pour WebWolf.

`local.yaml` publie les ports sur `127.0.0.1` uniquement, de sorte que le lab n’est accessible que depuis votre ordinateur et nulle part ailleurs. Arrêtez-le avec `Ctrl-C` et supprimez-le avec `docker compose -f compose.yaml -f local.yaml down -v`. Faites-le tourner sur une machine depuis laquelle vous acceptez d’attaquer : l’application est volontairement vulnérable.

## Pas à pas

1. **Inscrivez-vous.** Ouvrez WebGoat, choisissez **Register** et inventez un nom d’utilisateur et un mot de passe pour cette copie.
2. **Commencez en haut de la liste des leçons.** Chaque leçon explique une faille, comme l’injection, le contrôle d’accès défaillant, la désérialisation non sécurisée, les erreurs de JWT ou la traversée de répertoires, puis vous demande de l’exploiter. La leçon est marquée comme terminée quand vous y parvenez.
3. **Utilisez WebWolf quand une leçon l’indique.** Le lab propose deux liens, WebGoat et WebWolf, et WebWolf sert aux leçons qui ont besoin d’un second acteur, par exemple une qui vous envoie un message. Connectez-vous-y avec le même compte.
4. **Votre progression dure tant que le lab tourne.** Elle n’est pas conservée à l’arrêt du lab.

## Pour les enseignants

Rien dans ce lab n’est noté automatiquement. L’élève rend des preuves et vous les notez, comme pour n’importe quel autre lab.

**Demandez des preuves en deux volets.** D’abord, la preuve du travail : une capture d’écran de chaque leçon marquée comme terminée, avec l’adresse propre du lab visible dans le navigateur, pour qu’il soit clair que c’est sa copie. Ensuite, la compréhension : pour chacun, une explication écrite avec ses propres mots de ce qu’est la faille, de l’entrée exacte utilisée et de la raison pour laquelle elle a fonctionné, de ce qu’un attaquant pourrait en faire et de la façon dont le code aurait dû être écrit. Le second volet vous dit si c’est compris ou recopié depuis un pas-à-pas. Pour un travail plus solide, demandez la correction en plus de l’attaque.

**Place dans un cursus.** WebGoat convient à une première introduction à chaque classe de failles, avec l’explication à côté, et aux bases de la cryptographie, des jetons et de la désérialisation. Il appuie aussi le volet juridique et éthique d’une unité : autorisation et périmètre, Computer Misuse Act 1990 et divulgation responsable. Vérifiez le libellé exact dans l’unité de votre propre organisme certificateur : aucun n’est cité ici.

**Qui voit quoi.** Ces labs sont souvent utilisés avec des élèves de 16 et 17 ans. Une copie est privée pour l’élève qui l’a démarrée. Un membre du personnel qui enseigne le module peut l’ouvrir pour voir ce que l’élève a fait, et l’ouverture du travail d’un élève est consignée dans le journal d’accès, que l’élève peut lire.

## Ce qui ne fonctionne pas dans un lab

La progression de WebGoat ne dure que tant que le lab tourne. Le lab n’a aucune sortie vers Internet : une leçon qui a besoin d’un site sur Internet ne peut donc pas être terminée. WebGoat est une application Java et reçoit 1 Go, le plus parmi les trois labs de sécurité, et il met quelques secondes de plus à démarrer que les autres.

## Dépannage

- **La page de connexion n’apparaît pas juste après Démarrer.** Attendez quelques secondes et appuyez de nouveau sur Ouvrir : le lab ne se déclare prêt que lorsque WebGoat répond à travers son proxy.
- **Le second lien, WebWolf, ne vous connecte pas.** Inscrivez-vous d’abord dans WebGoat, puis connectez-vous à WebWolf avec le même compte.
- **Sur votre machine, le port 8080 ou 9090 est déjà utilisé.** Changez les numéros de gauche dans `local.yaml` et ouvrez ces ports à la place.

## Vérification du lab

`test/check.sh` démarre le lab comme le lanceur de la plateforme démarre chaque service (toutes les capacités retirées, `no-new-privileges`, une limite de processus, des limites de mémoire et aucune sortie vers Internet), puis vérifie depuis l’intérieur de son réseau ce que cette page promet. Il nécessite Docker et s’exécute à chaque push, ce qui correspond au badge en haut de la page.

```bash
test/check.sh
```

## Versions et licences tierces

[WebGoat](https://github.com/WebGoat/WebGoat) est sous licence GPL-2.0 et [nginx](https://nginx.org) sous BSD-2-Clause. Les images sont `webgoat/webgoat:v2026.5` et `nginx:1.27-alpine`.

## Licence

Cette œuvre est sous licence [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/). Vous pouvez la partager et l’adapter pour apprendre et enseigner, à condition de citer Mitsuru Technologies Ltd, de ne pas l’utiliser commercialement et de partager tout ce que vous en tirez sous la même licence. Le texte complet est dans le fichier `LICENSE`. Elle couvre le fichier compose, les tests et cette documentation. L’application qu’il contient garde la licence de son propre projet, indiquée plus haut.

## À propos

Réalisé par [Mitsuru Technologies](https://mitsurutech.co.uk) pour la [plateforme d’apprentissage MitsuruTech](https://mitsurutech.co.uk/fr/learning) : Python, Java, Go, Node, SQL et Linux dans le navigateur pour les écoles et les établissements, avec des labs de conteneurs, des applications web déployées depuis GitHub et des quiz qui se corrigent tout seuls. Essayez du code sans compte dans le [bac à sable](https://mitsurutech.co.uk/fr/playground).

D’autres labs du même éditeur : [lab-juice-shop](https://github.com/mitsurutech/lab-juice-shop), [lab-dvwa](https://github.com/mitsurutech/lab-dvwa), [lab-webgoat](https://github.com/mitsurutech/lab-webgoat), [lab-mysql-phpmyadmin](https://github.com/mitsurutech/lab-mysql-phpmyadmin), [lab-git-gitea](https://github.com/mitsurutech/lab-git-gitea) et [lab-sample](https://github.com/mitsurutech/lab-sample).
