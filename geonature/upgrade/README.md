# Construction du serveur geonature 2.14.x

Installation d'un serveur geonature 2.14 sur une VM debian 12, en utilisant le script install_all

Restauration des données à partir de celles du serveur de production 2.5.5 suivant une procédure d'export/import table par table avec remplacement des identifiants pk (et conservation des uuid), et correction des nomenclatures invalides.

Création de foreign data wrappers vers l'ancienne base de données.
https://www.postgresql.org/docs/current/sql-importforeignschema.html

Les schémas importés sont préfixés par `f_`.

Le service geonature est associé au role data.mercantour-parcnational.fr qui doit donc avoir les droits d'accès en lecture dans l'ancienne base.

```sql
set role postgres;

CREATE EXTENSION postgres_fdw;

CREATE SERVER srv_geonature
	FOREIGN DATA WRAPPER postgres_fdw
	OPTIONS (service 'geonature');

CREATE USER MAPPING
	FOR postgres
	SERVER srv_geonature;

```

## ref_geo

Le [référentiel géographique](ref_geo.md) est reconstruit à partir de l'installation standard de geonature en activant les objets géographiques pertinents.

## Nomenclature

Création d'une table de correspondance [ref_nomenclatures](ref_nomenclatures.md) entre l'ancienne et la nouvelle nomenclature, complétée à la main pour la traduction des nomenclatures non standard.

## Utilisateurs

Restauration du schéma [utilisateurs](utilisateurs.md).
Création de tables de conversion des id.

## Métadonnées

Restauration du schéma [gn_meta](gn_meta.md)  
Reprendre les fiches jdd avec l'application web (certains attributs sont désormais obligatoires)  
Si besoin, associer les jdd restaurés à l'application occtax  
Sélectionner les jdd ouverts à la saisie

## Taxonomie

Restauration du schéma [taxonomie](taxonomie.md)

## Occtax

Restauration du schéma [pr_occtax](pr_occtax.md).  
Relevés, puis observateurs, puis occurrences, puis comptages.
Les routines de restauration peuvent être appliquées plusieurs fois (les uuid déjà importés sont ignorés).

## Medias

TODO

voir gn_commons.t_medias (correspondance entre media et comptage occtax lorsque le media est importé via occtax)

## Synthese

```sql
create schema f_gn_synthese;
import foreign schema gn_synthese from server srv_geonature into f_gn_synthese;
```

gn_synthese.defaults_nomenclatures_value : il manque foreign key pour id_nomenclature
