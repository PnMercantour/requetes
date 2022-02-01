WITH perimetre AS (
  SELECT
    geom
  FROM
    ref_geo.l_areas
  WHERE
    id_area = 5496
)
SELECT
  nom_cite,
  date_min AS date_debut,
  date_max AS date_fin,
  dataset_shortname AS jdd_nom,
  id_synthese,
  unique_id_sinp,
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
  methode_determination comportement,
  count_min AS nombre_min,
  count_max AS nombre_max,
  meta_v_taxref AS version_taxref,
  sample_number_proof,
  digital_proof AS preuve_numerique,
  non_digital_proof AS preuve_non_numerique,
  altitude_min,
  altitude_max,
  the_geom_local AS geom,
  "validator" AS validateur,
  validation_comment,
  observers,
  determiner AS determinateur,
  id_digitiser,
  comment_context,
  comment_description,
  meta_validation_date,
  meta_create_date,
  meta_update_date,
  reference_biblio,
  cd_hab,
  grp_method AS methode_regroupement,
  place_name AS nom_lieu,
  "precision",
  taxref.*,
  coalesce(patrimoniale = 'oui', FALSE) AS patrimoniale,
  coalesce(protegee = 'oui', FALSE) AS protegee
FROM
  gn_synthese.synthese s
  JOIN perimetre ON (st_intersects (s.the_geom_local, perimetre.geom))
  JOIN taxonomie.taxref USING (cd_nom)
  LEFT JOIN (
    SELECT
      id_dataset,
      dataset_shortname
    FROM
      gn_meta.t_datasets) d USING (id_dataset)
  LEFT JOIN (
    SELECT
      label_fr AS stade_vie,
      id_nomenclature
    FROM
      ref_nomenclatures.t_nomenclatures) sv ON s.id_nomenclature_life_stage = sv.id_nomenclature
  LEFT JOIN (
    SELECT
      label_default AS technique_obs,
      id_nomenclature AS id_nomenclature_obs_technique
    FROM
      ref_nomenclatures.t_nomenclatures) tec_o USING (id_nomenclature_obs_technique)
  LEFT JOIN (
    SELECT
      label_default AS statut_biologique,
      id_nomenclature AS id_nomenclature_bio_status
    FROM
      ref_nomenclatures.t_nomenclatures) satut_bio USING (id_nomenclature_bio_status)
  LEFT JOIN (
    SELECT
      label_default AS etat_biologique,
      id_nomenclature AS id_nomenclature_bio_condition
    FROM
      ref_nomenclatures.t_nomenclatures) condition_bio USING (id_nomenclature_bio_condition)
  LEFT JOIN (
    SELECT
      label_default AS nature_objet_geo,
      id_nomenclature AS id_nomenclature_geo_object_nature
    FROM
      ref_nomenclatures.t_nomenclatures) objet_geo USING (id_nomenclature_geo_object_nature)
  LEFT JOIN (
    SELECT
      label_default AS type_regroupement,
      id_nomenclature AS id_nomenclature_grp_typ
    FROM
      ref_nomenclatures.t_nomenclatures) regrp USING (id_nomenclature_grp_typ)
  LEFT JOIN (
    SELECT
      label_default AS naturalite,
      id_nomenclature AS id_nomenclature_naturalness
    FROM
      ref_nomenclatures.t_nomenclatures) nature USING (id_nomenclature_naturalness)
  LEFT JOIN (
    SELECT
      label_default AS preuve_existante,
      id_nomenclature AS id_nomenclature_exist_proof
    FROM
      ref_nomenclatures.t_nomenclatures) preuve USING (id_nomenclature_exist_proof)
  LEFT JOIN (
    SELECT
      label_default AS sexe,
      id_nomenclature AS id_nomenclature_sex
    FROM
      ref_nomenclatures.t_nomenclatures) sexe USING (id_nomenclature_sex)
  LEFT JOIN (
    SELECT
      label_default AS precision_diffusion,
      id_nomenclature AS id_nomenclature_diffusion_level
    FROM
      ref_nomenclatures.t_nomenclatures) diffusion USING (id_nomenclature_diffusion_level)
  LEFT JOIN (
    SELECT
      label_default AS statut_source,
      id_nomenclature AS id_nomenclature_source_status
    FROM
      ref_nomenclatures.t_nomenclatures) statut_source USING (id_nomenclature_source_status)
  LEFT JOIN (
    SELECT
      label_default AS objet_denombrement,
      id_nomenclature AS id_nomenclature_obj_count
    FROM
      ref_nomenclatures.t_nomenclatures) denombre USING (id_nomenclature_obj_count)
  LEFT JOIN (
    SELECT
      label_default AS statut_observation,
      id_nomenclature AS id_nomenclature_observation_status
    FROM
      ref_nomenclatures.t_nomenclatures) statut_obs USING (id_nomenclature_observation_status)
  LEFT JOIN (
    SELECT
      label_default AS floutage_dee,
      id_nomenclature AS id_nomenclature_blurring
    FROM
      ref_nomenclatures.t_nomenclatures) floutage USING (id_nomenclature_blurring)
  LEFT JOIN (
    SELECT
      label_default AS statut_bio,
      id_nomenclature AS id_nomenclature_biogeo_status
    FROM
      ref_nomenclatures.t_nomenclatures) biologie USING (id_nomenclature_biogeo_status)
  LEFT JOIN (
    SELECT
      label_default AS methode_determination,
      id_nomenclature AS id_nomenclature_determination_method
    FROM
      ref_nomenclatures.t_nomenclatures) methode_deter USING (id_nomenclature_determination_method)
  LEFT JOIN (
    SELECT
      label_default AS niveau_sensibilite,
      id_nomenclature AS id_nomenclature_sensitivity
    FROM
      ref_nomenclatures.t_nomenclatures) niv_sensibilite USING (id_nomenclature_sensitivity)
  LEFT JOIN (
    SELECT
      label_default AS comportement,
      id_nomenclature AS id_nomenclature_behaviour
    FROM
      ref_nomenclatures.t_nomenclatures) comportement USING (id_nomenclature_behaviour)
  LEFT JOIN (
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
  AND ordre = 'Chiroptera'
ORDER BY
  date_debut DESC;
