WITH communes AS (
  SELECT
    id_area,
    area_name commune
  FROM
    ref_geo.l_areas
    JOIN ref_geo.bib_areas_types USING (id_type)
  WHERE
    bib_areas_types.type_code::text = 'COM'::text
),
t_datasets AS (
  SELECT
    *
  FROM
    gn_meta.t_datasets
  WHERE
    ref_nomenclatures.get_cd_nomenclature (id_nomenclature_data_origin) = 'Pu'
    AND id_acquisition_framework NOT IN (7, 90, 91, 92, 93, 95))
SELECT
  id_synthese,
  s.centroid_2154,
  s.unique_id_sinp,
  t_datasets.dataset_name,
  t_datasets.unique_dataset_id,
  s.nom_cite,
  --    COALESCE(patrimoniale.cd_ref IS NOT NULL, false) AS patrimoniale,
  --    COALESCE(protegee.cd_ref IS NOT NULL, false) AS protegee,
  taxref.nom_valide,
  taxref.cd_nom,
  taxref.cd_ref,
  s.count_min,
  s.count_max,
  s.altitude_min,
  s.altitude_max,
  s.date_min,
  s.date_max,
  s.validator,
  s.validation_comment,
  s.observers,
  s.comment_context,
  s.comment_description,
  ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_geo_object_nature) AS nat_obj_geo,
  ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_grp_typ) AS typ_grp,
  ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_obs_technique) AS meth_obs,
  ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_bio_status) AS statut_bio,
  ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_bio_condition) AS eta_bio,
  ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_naturalness) AS naturalite,
  ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_exist_proof) AS preuve_exist,
  ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_valid_status) AS statut_valid,
  ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_diffusion_level) AS niv_precis,
  ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_life_stage) AS stade_vie,
  ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_sex) AS sexe,
  ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_obj_count) AS obj_denbr,
  ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_type_count) AS typ_denbr,
  ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_sensitivity) AS sensibilite,
  ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_observation_status) AS statut_obs,
  ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_blurring) AS dee_flou,
  ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_source_status) AS statut_source,
  ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_info_geo_type) AS type_inf_geo,
  ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_determination_method) AS meth_determin,
  ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_behaviour) AS occ_comportement,
  ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_biogeo_status) AS stat_biogeo
FROM
  gn_synthese.synthese s
  JOIN gn_synthese.cor_area_synthese USING (id_synthese)
  JOIN communes USING (id_area)
  JOIN t_datasets USING (id_dataset)
  JOIN taxonomie.taxref USING (cd_nom)
WHERE
  commune = 'BREIL-SUR-ROYA'
  AND ref_nomenclatures.get_cd_nomenclature (s.id_nomenclature_info_geo_type) = '1';
