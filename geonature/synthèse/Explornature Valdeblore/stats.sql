-- observations Valdeblore entre le 30 juin 2022 0h et le 4 juillet 0h
-- seules les obs du cadre d'acquisition '948880b0-7e46-4941-bbd9-ded1635bf716' sont prises en compte
-- ce qui permet d'exclure des doublons issus de partenaires.
WITH params AS (
  SELECT id_area commune,
    '2022-06-30'::date debut,
    '2022-07-04'::date fin,
    ref_nomenclatures.get_id_nomenclature ('STATUT_OBS', 'Pr') present,
    id_acquisition_framework ca_explornature
  FROM ref_geo.l_areas la,
    gn_meta.t_acquisition_frameworks
  WHERE area_name = 'VALDEBLORE'
    AND unique_acquisition_framework_id = '948880b0-7e46-4941-bbd9-ded1635bf716'::uuid -- Explor'nature Valdeblore
),
taxons_explornature AS (
  -- taxons (cd_ref) de l'explor'nature
  SELECT DISTINCT cd_ref
  FROM gn_synthese.synthese s
    JOIN gn_meta.t_datasets USING (id_dataset)
    JOIN gn_synthese.cor_area_synthese cas USING (id_synthese)
    JOIN taxonomie.taxref USING (cd_nom),
    params
  WHERE cas.id_area = commune
    and date_min >= debut
    and date_max < fin
    AND id_nomenclature_observation_status = params.present
    AND id_rang IN ('ES', 'VAR', 'SSES')
    AND id_acquisition_framework = ca_explornature
),
obs_ante AS (
  -- observations antérieures des mêmes taxons sur la commune
  SELECT cd_ref,
    min(s.date_min)::date premiere_obs_commune,
    max(date_max)::date derniere_obs_commune
  FROM gn_synthese.synthese s
    JOIN gn_meta.t_datasets USING (id_dataset)
    JOIN gn_synthese.cor_area_synthese cas USING (id_synthese)
    JOIN taxonomie.taxref USING (cd_nom)
    JOIN taxons_explornature USING (cd_ref),
    params
  WHERE cas.id_area = commune
    AND id_nomenclature_observation_status = params.present
    AND id_acquisition_framework != ca_explornature
    AND s.date_max < debut
  GROUP BY cd_ref
),
obs_pnm_ante AS (
  -- observations  antérieures des mêmes taxons sur le territoire du PNM (approximé par la base de données entière)
  SELECT cd_ref,
    min(s.date_min)::date premiere_obs_pnm,
    max(date_max)::date derniere_obs_pnm
  FROM gn_synthese.synthese s
    JOIN gn_meta.t_datasets USING (id_dataset)
    JOIN taxonomie.taxref USING (cd_nom)
    JOIN taxons_explornature USING (cd_ref),
    params
  WHERE id_nomenclature_observation_status = params.present
    AND id_acquisition_framework != ca_explornature
    AND s.date_min < debut
  GROUP BY cd_ref
)
SELECT nom_complet,
  regne,
  group1_inpn,
  group2_inpn,
  classe,
  ordre,
  famille,
  premiere_obs_commune,
  derniere_obs_commune,
  premiere_obs_pnm,
  derniere_obs_pnm
FROM taxons_explornature
  LEFT JOIN obs_ante USING (cd_ref)
  LEFT JOIN obs_pnm_ante USING (cd_ref)
  JOIN taxonomie.taxref ON (taxons_explornature.cd_ref = taxref.cd_nom)
ORDER BY regne,
  group1_inpn,
  group2_inpn,
  classe,
  ordre,
  famille,
  nom_complet;