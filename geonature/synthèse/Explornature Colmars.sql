WITH params AS (
  SELECT
    id_area area_colmars,
    ref_nomenclatures.get_id_nomenclature ('STATUT_OBS', 'Pr') present,
    id_acquisition_framework ca_explornature
  FROM
    ref_geo.l_areas la,
    gn_meta.t_acquisition_frameworks
  WHERE
    area_name ILIKE 'Colmars'
    AND unique_acquisition_framework_id = 'ceef6608-b2b7-4cdb-bc42-05708fda9b12' -- Explor'nature Colmars
),
taxons_explornature AS (
  -- taxons (cd_ref) de l'explor'nature Colmars
  SELECT DISTINCT
    cd_ref
  FROM
    gn_synthese.synthese s
    JOIN gn_meta.t_datasets USING (id_dataset)
    JOIN gn_synthese.cor_area_synthese cas USING (id_synthese)
    JOIN taxonomie.taxref USING (cd_nom), params
  WHERE
    cas.id_area = area_colmars
    AND id_nomenclature_observation_status = params.present
    AND id_rang IN ('ES', 'VAR', 'SSES', 'FO')
    AND id_acquisition_framework = ca_explornature
),
obs_colmars_ante AS (
  -- observations antérieures des mêmes taxons à Colmars
  SELECT
    cd_ref,
    min(s.date_min)::date premiere_obs_colmars,
    max(date_min)::date derniere_obs_colmars
  FROM
    gn_synthese.synthese s
    JOIN gn_meta.t_datasets USING (id_dataset)
    JOIN gn_synthese.cor_area_synthese cas USING (id_synthese)
    JOIN taxonomie.taxref USING (cd_nom)
    JOIN taxons_explornature USING (cd_ref), params
  WHERE
    cas.id_area = area_colmars
    AND id_nomenclature_observation_status = params.present
    AND id_acquisition_framework != ca_explornature
    AND s.date_min < '2021-07-01'
  GROUP BY
    cd_ref
),
obs_pnm_ante AS (
  -- observations  antérieures des mêmes taxons sur le territoire du PNM (approximé par la base de données entière)
  SELECT
    cd_ref,
    min(s.date_min)::date premiere_obs_pnm,
    max(date_min)::date derniere_obs_pnm
  FROM
    gn_synthese.synthese s
    JOIN gn_meta.t_datasets USING (id_dataset)
    JOIN taxonomie.taxref USING (cd_nom)
    JOIN taxons_explornature USING (cd_ref), params
  WHERE
    id_nomenclature_observation_status = params.present
    AND id_acquisition_framework != ca_explornature
    AND s.date_min < '2021-07-01'
  GROUP BY
    cd_ref
)
SELECT
  nom_complet,
  regne,
  group1_inpn,
  group2_inpn,
  classe,
  ordre,
  famille,
  premiere_obs_colmars,
  derniere_obs_colmars,
  premiere_obs_pnm,
  derniere_obs_pnm
FROM
  taxons_explornature
  LEFT JOIN obs_colmars_ante USING (cd_ref)
  LEFT JOIN obs_pnm_ante USING (cd_ref)
  JOIN taxonomie.taxref ON (taxons_explornature.cd_ref = taxref.cd_nom)
ORDER BY
  regne,
  group1_inpn,
  group2_inpn,
  classe,
  ordre,
  famille,
  nom_complet;
