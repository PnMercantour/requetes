--  VM qui précalcule les observations d'espèces patrimoniales ou protégées et qui surtout calcule et indexe le centroide de l'observation (les observations rattachées sont ignorées).
-- L'indexation de l'attribut géométrique est essentielle pour la performance des requêtes.
-- Pour reconstruire l'observation :
--  faire une jointure sur le serveur avec la table synthese
-- compléter par une jointure sur le client avec les tables taxref, dataset et acquisition_framework
CREATE MATERIALIZED VIEW gn_synthese.vm_synthese_pp TABLESPACE pg_default AS
WITH params AS (
  SELECT
    ref_nomenclatures.get_id_nomenclature ('STATUT_OBS'::character varying, 'Pr'::character
      varying) AS present,
    ref_nomenclatures.get_id_nomenclature ('TYP_INF_GEO'::character varying, '1'::character varying) AS georef
)
SELECT
  s.id_synthese,
  st_centroid (s.the_geom_local) AS geom
FROM
  gn_synthese.synthese s
  JOIN taxonomie.v_taxref_pp USING (cd_nom),
  params
WHERE
  s.id_nomenclature_observation_status = params.present
  AND s.id_nomenclature_info_geo_type = params.georef WITH DATA;

-- View indexes:
CREATE INDEX vm_synthese_pp_geom_idx ON gn_synthese.vm_synthese_pp USING gist (geom);

CREATE UNIQUE INDEX vm_synthese_pp_id_synthese_idx ON gn_synthese.vm_synthese_pp USING btree (id_synthese);
