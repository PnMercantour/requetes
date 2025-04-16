insert into gn_synthese.synthese(
        unique_id_sinp,
        unique_id_sinp_grp,
        id_source,
        id_module,
        entity_source_pk_value,
        id_dataset,
        id_nomenclature_geo_object_nature,
        id_nomenclature_grp_typ,
        grp_method,
        id_nomenclature_obs_technique,
        id_nomenclature_bio_status,
        id_nomenclature_bio_condition,
        id_nomenclature_naturalness,
        id_nomenclature_exist_proof,
        id_nomenclature_valid_status,
        id_nomenclature_diffusion_level,
        id_nomenclature_life_stage,
        id_nomenclature_sex,
        id_nomenclature_obj_count,
        id_nomenclature_type_count,
        id_nomenclature_sensitivity,
        id_nomenclature_observation_status,
        id_nomenclature_blurring,
        id_nomenclature_source_status,
        id_nomenclature_info_geo_type,
        id_nomenclature_behaviour,
        id_nomenclature_biogeo_status,
        reference_biblio,
        count_min,
        count_max,
        cd_nom,
        cd_hab,
        nom_cite,
        meta_v_taxref,
        sample_number_proof,
        digital_proof,
        non_digital_proof,
        altitude_min,
        altitude_max,
        depth_min,
        depth_max,
        place_name,
        the_geom_4326,
        the_geom_point,
        the_geom_local,
        precision,
        id_area_attachment,
        date_min,
        date_max,
        validator,
        validation_comment,
        observers,
        determiner,
        id_digitiser,
        id_nomenclature_determination_method,
        comment_context,
        comment_description,
        additional_data,
        meta_validation_date,
        meta_create_date,
        meta_update_date,
        last_action
    )
select c.unique_id_sinp_occtax as unique_id_sinp,
    r.unique_id_sinp_grp,
    t_sources.id_source,
    r.id_module,
    c.id_counting_occtax as entity_source_pk_value,
    r.id_dataset,
    coalesce(
        r.id_nomenclature_geo_object_nature,
        gn_synthese.get_default_nomenclature_value('NAT_OBJ_GEO'::character varying)
    ) as id_nomenclature_geo_object_nature,
    coalesce(
        r.id_nomenclature_grp_typ,
        gn_synthese.get_default_nomenclature_value('TYP_GRP'::character varying)
    ) as id_nomenclature_grp_typ,
    r.grp_method,
    coalesce (
        o.id_nomenclature_obs_technique,
        gn_synthese.get_default_nomenclature_value('METH_OBS'::character varying)
    ) as id_nomenclature_obs_technique,
    coalesce (
        o.id_nomenclature_bio_status,
        gn_synthese.get_default_nomenclature_value('STATUT_BIO'::character varying)
    ) as id_nomenclature_bio_status,
    coalesce (
        o.id_nomenclature_bio_condition,
        gn_synthese.get_default_nomenclature_value('ETA_BIO'::character varying)
    ) as id_nomenclature_bio_condition,
    coalesce (
        o.id_nomenclature_naturalness,
        gn_synthese.get_default_nomenclature_value('NATURALITE'::character varying)
    ) as id_nomenclature_naturalness,
    coalesce (
        o.id_nomenclature_exist_proof,
        gn_synthese.get_default_nomenclature_value('PREUVE_EXIST'::character varying)
    ) as id_nomenclature_exist_proof,
    coalesce(
        null,
        gn_synthese.get_default_nomenclature_value('STATUT_VALID'::character varying)
    ) as id_nomenclature_valid_status,
    o.id_nomenclature_diffusion_level,
    coalesce(
        id_nomenclature_life_stage,
        gn_synthese.get_default_nomenclature_value('STADE_VIE'::character varying)
    ) as id_nomenclature_life_stage,
    coalesce(
        id_nomenclature_sex,
        gn_synthese.get_default_nomenclature_value('SEXE'::character varying)
    ) as id_nomenclature_sex,
    coalesce(
        id_nomenclature_obj_count,
        gn_synthese.get_default_nomenclature_value('OBJ_DENBR'::character varying)
    ) as id_nomenclature_obj_count,
    coalesce(
        id_nomenclature_type_count,
        gn_synthese.get_default_nomenclature_value('TYP_DENBR'::character varying)
    ) as id_nomenclature_type_count,
    -- id_nomenclature_sensitivity should be set
    null as id_nomenclature_sensitivity,
    coalesce(
        o.id_nomenclature_observation_status,
        gn_synthese.get_default_nomenclature_value('STATUT_OBS'::character varying)
    ) as id_nomenclature_observation_status,
    coalesce(
        o.id_nomenclature_blurring,
        gn_synthese.get_default_nomenclature_value('DEE_FLOU'::character varying)
    ) as id_nomenclature_blurring,
    coalesce(
        o.id_nomenclature_source_status,
        gn_synthese.get_default_nomenclature_value('STATUT_SOURCE'::character varying)
    ) as id_nomenclature_source_status,
    coalesce(
        null,
        gn_synthese.get_default_nomenclature_value('TYP_INF_GEO'::character varying)
    ) as id_nomenclature_info_geo_type,
    coalesce(
        o.id_nomenclature_behaviour,
        gn_synthese.get_default_nomenclature_value('OCC_COMPORTEMENT'::character varying)
    ) as id_nomenclature_behaviour,
    -- biogeo_status is not set, should it be?
    coalesce(
        null,
        gn_synthese.get_default_nomenclature_value('STAT_BIOGEO'::character varying)
    ) as id_nomenclature_biogeo_status,
    null as reference_biblio,
    c.count_min,
    c.count_max,
    o.cd_nom,
    r.cd_hab,
    o.nom_cite,
    coalesce(
        o.meta_v_taxref,
        gn_commons.get_default_parameter('taxref_version'::text)
    ) as meta_v_taxref,
    o.sample_number_proof,
    o.digital_proof,
    o.non_digital_proof,
    r.altitude_min,
    r.altitude_max,
    r.depth_min,
    r.depth_max,
    r.place_name,
    r.geom_4326 as the_geom_4326,
    ST_CENTROID(r.geom_4326) as the_geom_point,
    r.geom_local as the_geom_local,
    r.precision,
    null as id_area_attachment,
    date_trunc('day', date_min) + coalesce(hour_min, '00:00:00'::time) date_min,
    date_trunc('day', date_max) + coalesce(hour_max, '00:00:00'::time) date_max,
    null as validator,
    null as validation_comment,
    null as observers,
    o.determiner,
    r.id_digitiser,
    coalesce(
        o.id_nomenclature_determination_method,
        gn_synthese.get_default_nomenclature_value('METH_DETERMIN'::character varying)
    ) as id_nomenclature_determination_method,
    r.comment as comment_context,
    o.comment comment_description,
    coalesce(r.additional_fields, '{}'::jsonb) || coalesce(o.additional_fields, '{}'::jsonb) || coalesce(c.additional_fields, '{}'::jsonb) as additional_data,
    null as meta_validation_date,
    now() as meta_create_date,
    now() as meta_update_date,
    'I' as last_action
from pr_occtax.cor_counting_occtax c
    inner join pr_occtax.t_occurrences_occtax o on c.id_occurrence_occtax = o.id_occurrence_occtax
    join pr_occtax.t_releves_occtax r on o.id_releve_occtax = r.id_releve_occtax
    join gn_synthese.t_sources on (r.id_module = t_sources.id_module);