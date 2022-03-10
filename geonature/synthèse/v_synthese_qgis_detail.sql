CREATE OR REPLACE VIEW gn_synthese.v_synthese_qgis_detail AS
SELECT
  id_synthese,
  centroid_2154,
  unique_id_sinp,
  dataset_name,
  unique_dataset_id,
  nom_cite,
  COALESCE(patrimoniale.cd_ref IS NOT NULL, FALSE) AS patrimoniale,
  COALESCE(protegee.cd_ref IS NOT NULL, FALSE) AS protegee,
  taxref.*,
  meta_v_taxref,
  count_min,
  count_max,
  altitude_min,
  altitude_max,
  date_min,
  date_max,
  validator,
  validation_comment,
  observers,
  comment_context,
  comment_description,
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
  JOIN taxonomie.taxref USING (cd_nom)
  JOIN gn_meta.t_datasets USING (id_dataset)
  LEFT JOIN (
    SELECT
      cor_taxon_attribut.cd_ref
    FROM
      taxonomie.cor_taxon_attribut
      JOIN taxonomie.bib_attributs ba USING (id_attribut)
    WHERE
      ba.nom_attribut::text = 'patrimonial'::text
      AND cor_taxon_attribut.valeur_attribut = 'oui'::text) patrimoniale USING (cd_ref)
  LEFT JOIN (
    SELECT
      cor_taxon_attribut.cd_ref
    FROM
      taxonomie.cor_taxon_attribut
      JOIN taxonomie.bib_attributs ba USING (id_attribut)
    WHERE
      ba.nom_attribut::text = 'protection_stricte'::text
      AND cor_taxon_attribut.valeur_attribut = 'oui'::text) protegee USING (cd_ref);

COMMENT ON VIEW gn_synthese.v_synthese_qgis_detail IS 'Vue détaillée des observations, avec dataset et extrait taxref';

GRANT SELECT ON TABLE gn_synthese.v_synthese_qgis_detail TO gn_consult;

