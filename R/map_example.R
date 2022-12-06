# Carte exemple

# Packages ----
SciViews::R("spatial")

# Importation des données
be <- st_read("data/map_belgium/belgium.shp")
class(be) # Déjà un objet sf

bee <- read("data/wild_bees_belgium.rds")
class(bee) # Déjà un objet sf

# Première carte (pas très lisible)
tm_shape(be) +
  tm_borders() +
  # Superposition des points issus du tableau bee
  tm_shape(bee) +
  tm_dots()
# Il est intéressant de noter  que certains points sont dans la Mer du Nord ;)
# Sacré Bombus !

# Variables à disposition
str(be)
str(bee)

# Systèmes de coordonnées géographiques utilisés
st_crs(be)
st_crs(bee)
# WGS 84 dans les deux cas, on est bon, pas besoin de transformer

# Nous voulons placer les observations dans les polygones des communes belges.
# Le lien entre les deux tableaux peut être fait via les coordonnées
# géographiques (en déterminant dans quelle commune chaque observation a été
# faite). Attention que des observations proches de frontières peuvent être
# attribuées à une autre commune, ou même hors territoire belge, à cause des
# approximations introduites dans l'arrondi des coordonnées des points de bee !
bee2 <- st_join(be, bee, left = TRUE)
# Avec left = TRUE, on est certain de garder toutes les communes, même s'il n'y
# a aucune observation dedans. Par contre, on perd les points hors territoire
# belge.

nrow(bee)
nrow(bee2)
# Plus de points après qu'avant ? Attention: une observation sur un frontière de
# commune sera compté deux fois (dans les deux communes). Il faut filtrer pour
# éliminer les entrées dupliquées. Nous pouvons nous baser ici sur recordNumber.
bee2 <- filter(bee2, !duplicated(recordNumber))
nrow(bee2)
# Il nous reste donc 13090 observations.

# Cartographie des Megachilidae
# Ici, on va retravailler le jeu de données comme suit:
# - On ne récupère que les entrées relatives aux Megachilidae
# - On résume le tableau en dénombrant le nombre d'observations par commune
#   en regroupant par NISCode
bee2 %>.%
  filter(., family ==  "Megachilidae") %>.%
  group_by(., NISCode) %>.%
  summarise(., observations = n()) ->
  mega

tm_shape(mega) +
  tm_borders() +
  tm_compass() +
  tm_scale_bar(position = c("left", "bottom")) +
  tm_fill("observations", title = "Observations") +
  tm_legend(position = c(0.05, 0.2))
# Ici, la carte est incomplète car il manque les communes sans observations

# Nous allons donc créer un fond de carte avec les données du tableau be et
# superposer ensuite les observations issues du tableau mega.
tm_shape(be) +
  tm_borders() +
  tm_fill("gray") +
  # Seconde couche: on colorie les communes en fonction des observations de mega
  tm_shape(mega) +
  tm_borders() +
  tm_fill("observations", title = "Observations") +
  # Arrangement des annotations de cartes
  tm_legend(position = c(0.05, 0.2)) +
  tm_compass() +
  tm_scale_bar(position = c("left", "bottom")) ->
  mega_map
# Affichage de la carte
mega_map

# Sauvegarde pour inclure la carte exemple dans README.md sans la recalculer
#tmap_save(mega_map, "figures/mega_map.png", dpi = 100)
