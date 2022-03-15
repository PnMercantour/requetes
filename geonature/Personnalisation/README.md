# Personnalisation de l'instance geonature du PNM

## Taxonomie

table taxonomy.tr_especes_enjeu_agropasto

Liste des espèces d'insectes à enjeu pour l'agropastoralisme

Liste établie par un expert et communiquée par MFL.
taxon 54085 Maculinea arion renommée en 631133 (Phengaris arion) qui est le cd_ref de l'espèce en v11.

L'attribut cd_nom correspond au nom valide en taxref V11, utiliser cet attribut pour filtrer les observations.

L'attribut cd_ref a été défini à partir d'une version plus récente de taxref : ne pas utiliser pour l'instant.

## Synthèse

### Ajout d'une colonne `centroid_2154` à la table `gn_synthese.synthese`

Motivation: Les agents du PNM utilisent QGIS (en 2154) comme client de la base geonature. QGIS ne traite que des sources de données géométriques homogènes, or la colonne `the_geom_local` peut contenir des objets géométriques arbitraires, le plus souvent des points, mais parfois aussi des polygones ou des segments de droite.

On ajoute à la table `gn_synthese.synthese` la colonne `centroid_2154` de type `geometry(POINT, 2154)`, calculée comme le centroide de la valeur de la colonne `the_geom_local`.

On crée un trigger pour le calcul automatique de la valeur `centroid_2154` à partir de celle de `the_geom_local`.

On crée un index géométrique sur cette nouvelle colonne.

Remarque 1: La colonne `the_geom_point` remplit une fonction similaire pour les clients web (en 4326). On a préféré l'option de créer une colonne dans le SRS 2154 plutôt que de reprojeter à la volée.

Remarque 2: Le calcul à la volée du centroide de `the_geom_local`, par exemple dans une vue, n'est pas une option viable car en l'absence d'index sur la colonne géométrique, les performances de QGIS s'effondrent et rendent l'outil inutilisable.

## Occtax

### Valeur valide pour id_nomenclature_observation_status

Motivation : occtax mobile donne la valeur NULL à cet attribut lorsqu'il est écrit dans la table `pr_occtax.t_occurrences_occtax`. La valeur par défaut n'est pas prise en compte.

En attendant la correction du problème dans occtax mobile (tout simplement ne plus écrire cet attribut ou écrire la valeur `present`), on ajoute un trigger sur la table pour forcer la valeur `present` lorsqu'elle vaut NULL sur un INSERT ou UPDATE.
