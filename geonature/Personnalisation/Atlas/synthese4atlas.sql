-- gn_synthese.synthese4atlas source
CREATE OR REPLACE VIEW gn_synthese.synthese4atlas AS WITH datasets AS (
        SELECT DISTINCT t_datasets.id_dataset
        FROM gn_synthese.synthese synthese_1
            JOIN gn_meta.t_datasets ON synthese_1.id_dataset = t_datasets.id_dataset
            JOIN gn_meta.cor_dataset_actor ON t_datasets.id_dataset = cor_dataset_actor.id_dataset
            JOIN ref_nomenclatures.t_nomenclatures actor_role ON cor_dataset_actor.id_nomenclature_actor_role = actor_role.id_nomenclature
        WHERE (
                actor_role.cd_nomenclature::text = ANY (
                    ARRAY ['2'::character varying::text, '3'::character varying::text, '4'::character varying::text, '5'::character varying::text, '6'::character varying::text, '7'::character varying::text, '8'::character varying::text]
                )
            )
            AND cor_dataset_actor.id_organism = 1
    )
SELECT synthese.id_synthese,
    synthese.unique_id_sinp,
    synthese.unique_id_sinp_grp,
    synthese.id_source,
    synthese.id_module,
    synthese.entity_source_pk_value,
    synthese.id_dataset,
    synthese.id_nomenclature_geo_object_nature,
    synthese.id_nomenclature_grp_typ,
    synthese.id_nomenclature_obs_technique,
    synthese.id_nomenclature_bio_status,
    synthese.id_nomenclature_bio_condition,
    synthese.id_nomenclature_naturalness,
    synthese.id_nomenclature_exist_proof,
    synthese.id_nomenclature_valid_status,
    synthese.id_nomenclature_diffusion_level,
    synthese.id_nomenclature_life_stage,
    synthese.id_nomenclature_sex,
    synthese.id_nomenclature_obj_count,
    synthese.id_nomenclature_type_count,
    synthese.id_nomenclature_sensitivity,
    synthese.id_nomenclature_observation_status,
    synthese.id_nomenclature_blurring,
    synthese.id_nomenclature_source_status,
    synthese.id_nomenclature_info_geo_type,
    synthese.count_min,
    synthese.count_max,
    synthese.cd_nom,
    synthese.nom_cite,
    synthese.meta_v_taxref,
    synthese.sample_number_proof,
    synthese.digital_proof,
    synthese.non_digital_proof,
    synthese.altitude_min,
    synthese.altitude_max,
    synthese.the_geom_4326,
    synthese.the_geom_point,
    synthese.the_geom_local,
    synthese.date_min,
    synthese.date_max,
    synthese.validator,
    synthese.validation_comment,
    synthese.observers,
    synthese.determiner,
    synthese.id_digitiser,
    synthese.id_nomenclature_determination_method,
    synthese.comment_context,
    synthese.comment_description,
    synthese.meta_validation_date,
    synthese.meta_create_date,
    synthese.meta_update_date,
    synthese.last_action,
    synthese.reference_biblio,
    synthese.id_area_attachment
FROM gn_synthese.synthese
WHERE (
        synthese.id_dataset IN (
            SELECT datasets.id_dataset
            FROM datasets
        )
    )
    AND NOT (
        synthese.cd_nom IN (
            SELECT atlas_excluded.cd_nom
            FROM taxonomie.atlas_excluded
        )
    );