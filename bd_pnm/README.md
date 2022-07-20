# Base de données PNM

## ag_pasto

Schéma des données agropastorales.
Le schéma n'a pas encore été migré depuis la base de données historique (les projets qgis exploitent les données de la base historique, service mercantour)
Le schéma est mis à jour manuellement (pg_dump/restore). Dernière mise à jour le 20 juillet 2022.
Il est recommandé pour les nouveaux projets (exemple PAEC) de pointer sur ce schéma de préférence à celui de la base historique, afin de faciliter la migration et l'arrêt à terme de la base historique.

## apn

?

## arauzier

Traitement de données flore

## bd_aigle_royal

Données migrées (mais un peu anciennes). La base de données historique n'est plus alimentée.

## bd_bouquetin

?

## bd_cables_avifaune

?

## bd_chiro

?

## bd_lacs

?

## bd_sentiers

fdw geotrek (non fonctionnel)
A restaurer ou supprimer

## bd_source

?

## charte

?

## chataigneraie

?

## eau

schéma migré et partiellement mis à jour

## eau_lacs

nouveau schéma

## eau_zh

Nouveau schéma. Contient les données relatives aux zones humides

## faune

Schéma migré. Utilisé par l'application survol.

## flore

Nouveau schéma

## foret

?

## geonature

import geonature, utilisé par le schéma arauzier.
A supprimer après mise à jour des traitements (en utilisant gn_synthese)

## geophysique

?

## gn_synthese

Le schema gn_synthese reproduit, avec des foreign data wrappers, la structure du schema analogue de la base de données geonature.

Pour garantir les performance des requêtes geo, la table synthese est reproduite dans la vue matérialisée `gn_synthese.synthese_avec_partenaires`.
Cette vue est indexée sur les colonnes `id_synthese`, `geom` (qui correspond au `centroid_2154` dans la table originale), `cd_nom` et `date_min`.
Tous les attributs de la table originale sont repris dans la vue, à l'exception des géométries originales.

Le schéma doit être utilisé conjointement avec les schémas taxonomie et ref_nomenclature.

La vue est rafraichie quotidiennement par un script de maintenance (voir le crontab de l'utilisateur postgres sur le serveur de base de données).

## lievre_variable

?

## limites

Nouveau schéma.
La table limites donne les limites du PNM, suivant plusieurs échelles de précision, l'attribut layer donne l'ordre logique de superposition des couches (z-index) pour les applications graphiques.

A mettre à jour (modifications récentes des limites dans la base de données historique. geom_simple à optimiser)

## limregl

Copie du schéma de même nom dans la base historique.

Nombreuses tables qui contiennent chacune une unique géométrie.

Fonctionnellement remplacé par le schéma limites.

Utilisé dans de nombreux projets carto. Ne pas supprimer.

Note : des modifications récentes dans la base historique doivent être reportées dans ce schéma.

## observatoire_bati

?

## old_bd_chiro

??

## old_bd_diag_tly

?

## old_bd_ogm

?

## paec

Nouveau schéma.

## pieges_photo

Nouveau schéma.
Emplacement des pièges photo Roya/Vésubie

## public

Postgis

## ref_bd_carthage

?

## ref_bd_ogm

?

# ref_geo

Copie du ref_geo de geonature
A mettre à jour avant toute utilisation

## ref_info_espece

listes rouges, taxonomies, etc
A supprimer?

## ref_inpn

Taxref, encore! habref.
A supprimer ou mettre à jour (lien geonature ou installation propre avec liaisons entre les tables)

## ref_maille

Maillages
Intérêt des Mailles UTM?
A supprimer ?

## ref_nomenclatures

Copie (2022-07-20) des nomenclatures geonature. A utiliser avec gn_synthese.

## ref_occ_sol

?

## ref_statut_protection

?

## rice

? zonages PNM PNR

## site_prio

?

## site_prioritaire

??

## stage_foret

?

## survol

Schéma actif: gestion des aires de sensibilité au survol. voir projet associé https://github.com/PnMercantour/autorisations_survol
Exploite les données des schémas faune, aigle_royal

Normalement à jour (vérifier que personne n'utilise une version obsolète du projet qgis liée à la base de données historique)

## taxonomie

Copie de la taxonomie (v11) de geonature. Utilisé conjointement avec gn_synthese.

## topology

Postgis ?

## tourisme

?

## unesco

?

## urb

urbanisme?

## vegetation

?

# Schémas supprimés lors de la migration

## bd_geonature

## bd_partenaire

Imports non structurés de données d'observation partenaires.

## bd_synthese

Imports anciens de geonature

## cadastre et cadastre21

Import du cadastre

## ref_bd_carto

Données obsolètes

## ref_bdtopo

Données obsolètes

## ref_esp_hab

## wrk

Résultats de traitements de données ?
