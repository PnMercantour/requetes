WITH cante AS (
  SELECT
    st_geomfromtext ('POLYGON ((1008689.70956591 6336902.84285154,1008682.58527578 6336800.72802627,1008582.84521389 6336788.85420938,1008378.61556336 6336774.60562911,1008193.38401985 6336741.35894181,1007953.53291864 6336760.35704884,1007616.31651892 6336838.72424033,1007495.20358663 6336900.46808816,1007412.08686839 6336957.46240924,1007366.9663642 6337002.58291343,1007328.97015015 6337052.45294437,1007252.97772205 6337069.07628802,1007153.23766016 6337109.44726545,1007041.62378138 6337149.81824288,1006956.13229976 6337206.81256396,1006901.51274206 6337259.05735828,1006732.9045422 6337332.67502301,1006659.28687747 6337432.4150849,1006668.78593099 6337546.40372706,1006804.14744355 6337444.28890179,1006930.0099026 6337392.04410747,1007013.12662084 6337304.17786247,1007100.99286583 6337254.30783153,1007203.1076911 6337209.18732734,1007352.71778393 6337156.94253302,1007428.71021204 6337076.20057815,1007594.94364852 6336993.08385991,1007863.29191027 6336926.59048532,1008224.25594377 6336869.59616424,1008383.36509011 6336890.96903465,1008689.70956591 6336902.84285154))', 2154) geom
)
SELECT
  coalesce(patrimoniale = 'oui', FALSE) AS patrimoniale,
  coalesce(protegee = 'oui', FALSE) AS protegee,
  date_min as date_debut,
  date_max as date_fin,
  taxref.*,
  nom_cite,
  id_synthese,
  unique_id_sinp,

  dataset_shortname as jdd_nom,
  nature_objet_geo,
  type_regroupement,
  technique_obs,
  statut_bio,
  etat_biologique,
  naturalite,
  preuve_existante,
  precision_diffusion,
  stade_vie,
  sexe,
  objet_denombrement,
  niveau_sensibilite,
  statut_observation,
  floutage_dee,
  statut_source,
  methode_determination
  comportement,
  count_min as nombre_min,
  count_max as nombre_max,
  meta_v_taxref as version_taxref,
  sample_number_proof,
  digital_proof as preuve_numerique,
  non_digital_proof as preuve_non_numerique,
  altitude_min,
  altitude_max,
  the_geom_local AS geom,
  "validator" as validateur,
  validation_comment,
  observers,
  determiner as determinateur,
  id_digitiser,
  comment_context,
  comment_description,
  meta_validation_date,
  meta_create_date,
  meta_update_date,
  reference_biblio,
  cd_hab,
  grp_method as methode_regroupement,
  place_name as nom_lieu,
  "precision"
FROM
  gn_synthese.synthese s
  JOIN cante ON (st_intersects (s.the_geom_local, cante.geom))
  JOIN taxonomie.taxref USING (cd_nom)

  LEFT JOIN (select id_dataset, dataset_shortname from gn_meta.t_datasets) d using (id_dataset)
  LEFT JOIN (select label_fr as stade_vie, id_nomenclature from ref_nomenclatures.t_nomenclatures) sv on s.id_nomenclature_life_stage = sv.id_nomenclature
  LEFT JOIN (select label_default as technique_obs, id_nomenclature as id_nomenclature_obs_technique from ref_nomenclatures.t_nomenclatures) tec_o using (id_nomenclature_obs_technique)
  LEFT JOIN (select label_default as statut_biologique, id_nomenclature as id_nomenclature_bio_status from ref_nomenclatures.t_nomenclatures) satut_bio using (id_nomenclature_bio_status)
  LEFT JOIN (select label_default as etat_biologique, id_nomenclature as id_nomenclature_bio_condition from ref_nomenclatures.t_nomenclatures) condition_bio using (id_nomenclature_bio_condition)
  LEFT JOIN (select label_default as nature_objet_geo, id_nomenclature as id_nomenclature_geo_object_nature from ref_nomenclatures.t_nomenclatures) objet_geo using (id_nomenclature_geo_object_nature)
  LEFT JOIN (select label_default as type_regroupement, id_nomenclature as id_nomenclature_grp_typ from ref_nomenclatures.t_nomenclatures) regrp using (id_nomenclature_grp_typ)
  LEFT JOIN (select label_default as naturalite, id_nomenclature as id_nomenclature_naturalness from ref_nomenclatures.t_nomenclatures) nature using (id_nomenclature_naturalness)
  LEFT JOIN (select label_default as preuve_existante, id_nomenclature as id_nomenclature_exist_proof from ref_nomenclatures.t_nomenclatures) preuve using (id_nomenclature_exist_proof)
  LEFT JOIN (select label_default as sexe, id_nomenclature as id_nomenclature_sex from ref_nomenclatures.t_nomenclatures) sexe using (id_nomenclature_sex)  
  LEFT JOIN (select label_default as precision_diffusion, id_nomenclature as id_nomenclature_diffusion_level from ref_nomenclatures.t_nomenclatures) diffusion using (id_nomenclature_diffusion_level) 
  LEFT JOIN (select label_default as statut_source, id_nomenclature as id_nomenclature_source_status from ref_nomenclatures.t_nomenclatures) statut_source using (id_nomenclature_source_status) 
  LEFT JOIN (select label_default as objet_denombrement, id_nomenclature as id_nomenclature_obj_count from ref_nomenclatures.t_nomenclatures) denombre using (id_nomenclature_obj_count)
  LEFT JOIN (select label_default as statut_observation, id_nomenclature as id_nomenclature_observation_status from ref_nomenclatures.t_nomenclatures) statut_obs using (id_nomenclature_observation_status)
  LEFT JOIN (select label_default as floutage_dee, id_nomenclature as id_nomenclature_blurring from ref_nomenclatures.t_nomenclatures) floutage using (id_nomenclature_blurring)
  LEFT JOIN (select label_default as statut_bio, id_nomenclature as id_nomenclature_biogeo_status from ref_nomenclatures.t_nomenclatures) biologie using (id_nomenclature_biogeo_status)
  LEFT JOIN (select label_default as methode_determination, id_nomenclature as id_nomenclature_determination_method from ref_nomenclatures.t_nomenclatures) methode_deter using (id_nomenclature_determination_method)
  LEFT JOIN (select label_default as niveau_sensibilite, id_nomenclature as id_nomenclature_sensitivity from ref_nomenclatures.t_nomenclatures) niv_sensibilite using (id_nomenclature_sensitivity)
  LEFT JOIN (select label_default as comportement, id_nomenclature as id_nomenclature_behaviour from ref_nomenclatures.t_nomenclatures) comportement using (id_nomenclature_behaviour)
  LEFT JOIN  (
  SELECT
      cd_ref,
      valeur_attribut AS patrimoniale
    FROM
      taxonomie.cor_taxon_attribut
    WHERE
      id_attribut = 1) pat USING (cd_ref)
  LEFT JOIN (
    SELECT
      cd_ref,
      valeur_attribut AS protegee
    FROM
      taxonomie.cor_taxon_attribut
    WHERE
      id_attribut = 2) pro USING (cd_ref)
    WHERE
      id_nomenclature_info_geo_type = 126
