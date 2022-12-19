# Importation et remaniement des données concernant les abeilles sauvages en
# Belgique. Ne modifiez pas ce code mais essayez de la comprendre et
# inspirez-vous en...
# Comme les données brutes sont trop volumineuses, elles ne sont pas stockées
# dans le dépôt GitHub (data/raw/ est ajouté dans le fichier .gitignore).
# Par contre, les données brutes sont téléchargeables depuis un serveur afin de 
# rendre l'analyse reproductible (il faut que toutes les étapes de votre analyse
# puissent être reproduites à partir du clonage de votre dépôt Github).

# Packages ----
SciViews::R("spatial")
# également nécessaires, mais non chargés directement
#library(mapview)
#library(pryr)

# Importation des données brutes ----
# Si le sous-dossier data/raw n'existe pas, nous récupérons les données
if (!file.exists("data/raw")) {
  dir.create("data/raw")
  # Téléchargement du fichier compressé
  data_url <- "https://go.sciviews.org/bees_belgium"
  data_tar_xz <- "data/bees_belgium.tar.xz"
  download.file(url = data_url, destfile = data_tar_xz)
  # Décompression dans le dossier data
  untar(data_tar_xz, exdir = "data")
  # Élimination du fichier compressé temporaire
  unlink(data_tar_xz)
}

# Les données proviennent initialement de <https://doi.org/10.15468/dl.465vwp>
# Cependant, le site GBiF nécessite un login et le téléchargement direct des
# données n'est pas possible depuis ce site. Par conséquent, les données brutes
# sont fournies à partir d'une autre source via l'URL
# https://go.sciviews.org/bees_belgium
bee_data <- "data/raw/wild_belgian_bees.csv"
bee <- read$tsv(bee_data)
table(bee$year)

# On se concentre sur les observations de 2016
bee_2016 %<-% filter(bee, year == "2016")
str(bee_2016)
class(bee_2016)
nrow(bee_2016)

# Transformation en objet sf
bee_2016_sf <- st_as_sf(bee_2016,
  coords = c("decimalLongitude", "decimalLatitude"), crs = 4326)
# Visualisation interactive
mapview::mapview(bee_2016_sf) # série de point pour chaque observation
class(bee_2016_sf)

# Sauvegarde des données réduites à 2016 sous forme compressée
# Note: cette instruction est mise en commentaire pour éviter d'écraser par
# mégarde le fichier de départ!
#write$rds(bee_2016_sf, "data/wild_bees_belgium.rds", compress = "xz")

# Carte de Belgique ----
# Les données proviennent de
# https://www.geo.be/catalog/details/fb1e2993-2020-428c-9188-eb5f75e284b9?l=fr
# Elles sont aussi stockées sous une forme directement téléchargeable dans R
# depuis "https://go.sciviews.org/bees_belgium" (voir plus haut)
map_data <- "data/raw/map_belgium/AD_2_Municipality.shp"
belgium <- st_read(map_data)
pryr::object_size(belgium)
# Données trop volumineuses que nous allons maintenant simplifier
be <- st_simplify(belgium, dTolerance = 0.001)
pryr::object_size(be)

# Sauvegarde des données simplifiées dans le dépôt GitHub
# Note: cette instruction est commentée pour éviter de les écraser par mégarde
#write_sf(obj = be, dsn = "data/map_belgium/belgium.shp")

# Vérification finale ---
bee <- st_as_sf(read("data/wild_bees_belgium.rds"))
mapview::mapview(bee)
