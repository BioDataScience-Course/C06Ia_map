# Réalisation de cartes de la distribution des abeilles sauvages en Belgique

## Avant-propos

Les consignes sont reprises dans ce document, ainsi que sous forme de commentaires dans les différents fichiers. Elles sont susceptibles d'évoluer. N'hésitez pas à vérifier le lien suivant afin de voir si des modifications n'y ont pas été apportées : https://github.com/BioDataScience-Course/C06Ia_map.

## Objectifs

Cette assignation vous permettra de nous démontrer que vous avez acquis les compétences suivantes :

- Importer et manipuler des données spatiales dans R

- Réaliser des cartes dans R

## Consignes

Complétez le carnet de notes `docs/bees_notes.Rmd` afin de proposer entre 3 et 5 cartes. Détaillez vos réflexions pour obtenir chaque carte. Votre objectif est donc de proposer une cartographie originale et instructive de la distribution des abeilles sauvages en Belgique. Respectez les règles qui font que votre carte aura un rendu professionnel.

Vous pouvez réaliser vos cartes avec {chart}, {ggplot2}, {mapview}, {leaflet} ou encore {tmap}. Vous pouvez proposer des cartes réalisées avec les différents packages pour montrer que vous les maîtrisez.

Vous avez à votre disposition les données suivantes :

- `data/wild_bees_belgium.rds` : un fichier RDS qd'un sous-échantillon des données "Wild Bees of Belgium", DOI : [`DOI10.15468/dl.465vwp`](https://www.gbif.org/dataset/0d7c6a1a-0aab-47dc-8256-f23fefac69cd). 

- Le sous-dossier `data/map_belgium` contient plusieurs fichiers nécessaires à la réalisation de cartes de la Belgique. Les données sont détaillées par communes. Elles proviennent de <https://www.geo.be/catalog/details/fb1e2993-2020-428c-9188-eb5f75e284b9?l=fr>. Vous avez la possibilité de travailler plutôt sur la cartes des régions ou des provinces, selon votre choix.

- Vous pouvez ajouter des données supplémentaires mais votre projet doit rester reproductible et il doit contenir l'ensemble des fichiers nécessaires à la réalisation de vos cartes sous une forme qui tient dans votre dépôt GitHub. Faites donc attention à la taille de vos fichiers et limitez-vous aux données strictement indispensables pour vos cartes (utilisez des scripts d'importation et de nettoyage des données pour que la récupération des données additionnelles soit reproductible).

Vous avez un script qui vous présente le pré-traitement des données et un script qui vous propose un exemple de carte. N'hésitez pas à vous en inspirer.

![Dénombrement de la présence de la famile des Megachilidae par commune en 2016](figures/mega_map.png)

## Astuces

Dans ce dépôt, vous avez une importation de données trop volumineuses pour être incluses dans le système de gestion de version git/GitHub qui sont téléchargées dans le dossier `data/raw` par ailleurs exclus du versioning (dans `.gitignore`). Le script d'importation traite aussi et réduit la taille des données pour finir par enregistrer dans `data` des versions condensées et remaniées de ces données. **Vous pouvez vous inspirer de ce mécanisme plus tard si vous vous trouvez dans une situation similaire, par exemple, durant votre mémoire.**

La réalisation de cartes nécessite pas mal de remaniements des données. On cherche des fonds de carte au format GeoTIFF, des shapefiles de ESRI ou encore directement des données à partir d'un package R et puis on peut faire une carte dans R. Il ne faut pas disposer d'un programme dédié et complexe de cartographie. Cependant, la taille des fichiers et le temps de calcul selon la puissance votre ordinateur peuvent souvent être un problème. Nous vous conseillons d'employer `aggregate()` afin de réduire la résolution d'un raster. Vous pouvez aussi utiliser `sf::st_simplify()` pour réduire la complexité (et la résolution) d'un objet **sf**.
