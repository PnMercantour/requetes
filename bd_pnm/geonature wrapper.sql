-- Foreign data wrapper: postgres_fdw
-- DROP FOREIGN DATA WRAPPER postgres_fdw;
-- https://www.postgresql.org/docs/13/sql-createforeigndatawrapper.html
-- https://www.postgresql.org/docs/13/postgres-fdw.html
CREATE FOREIGN DATA WRAPPER postgres_fdw HANDLER postgres_fdw_handler VALIDATOR postgres_fdw_validator OPTIONS ();

-- essai avec services
-- fichier .pg_service.conf dans le répertoire racine de l'utilisateur postgres
-- déposer certificats de l'utilisateur data.mercantour-parcnational.fr dans ~postgres/.postgresql
CREATE SERVER srv_geonature FOREIGN DATA WRAPPER postgres_fdw OPTIONS (
    service 'geonature'
);

CREATE USER MAPPING FOR postgres SERVER srv_geonature;

-- Après l'import du schema, supprimer les foreign tables inutiles.
import FOREIGN SCHEMA gn_synthese
FROM
    SERVER srv_geonature INTO gn_synthese;

-- vue matérialisée avec les données minimales pour faire des jointures
-- id_synthese, cd_nom, date_min et géométrie
-- le cd_ref peut être obtenu dans la table importée taxonomy.taxref
-- les autres attributs (et un filtrage additionnel) peuvent être requêtés dans la foreign table gn_synthese.synthese
CREATE MATERIALIZED VIEW gn_synthese.synthese_proxy AS
SELECT
    synthese.id_synthese,
    synthese.cd_nom,
    synthese.date_min,
    synthese.centroid_2154
FROM
    gn_synthese.synthese WITH DATA;

CREATE UNIQUE INDEX ON gn_synthese.synthese_proxy (id_synthese);

CREATE INDEX ON gn_synthese.synthese_proxy USING gist (centroid_2154);

-- le schema taxonomy est importé en entier (FDW ne se justifie pas, les données sont stables dans le temps).
-- exemple de jointure entre géométrie locale et géométrie importée :
SELECT
    unp.*,
    count(id_synthese)
FROM
    ag_pasto.c_unite_pastorale_unp unp
    LEFT JOIN gn_synthese.synthese_proxy ON (st_within (centroid_2154, geom))
GROUP BY
    unp.id;

