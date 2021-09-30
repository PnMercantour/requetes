-- observations de bouquetins dans geonature
SELECT
    nom_cite,
    unique_id_sinp,
    altitude_min,
    altitude_max,
    st_centroid (the_geom_local) geom,
    date_min,
    date_max,
    comment_description,
    count_min,
    count_max,
    technique_obs, -- id_nomenclature_obs_technique,
    statut_biologique, --id_nomenclature_bio_status,
    etat_biologique, --id_nomenclature_bio_condition,
    preuve_existante, -- id_nomenclature_exist_proof,
    statut_validation, -- id_nomenclature_valid_status,
    stade_vie, -- id_nomenclature_life_stage,
    sexe, --id_nomenclature_sex,
    objet_denombrement, -- id_nomenclature_obj_count,
    type_denombrement, -- id_nomenclature_type_count,
    comportement, --id_nomenclature_behaviour
    id_synthese
FROM
    gn_synthese.synthese s
    LEFT JOIN (
        SELECT
            label_default AS stade_vie,
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
            ref_nomenclatures.t_nomenclatures) statut_bio USING (id_nomenclature_bio_status)
    LEFT JOIN (
        SELECT
            label_default AS etat_biologique,
            id_nomenclature AS id_nomenclature_bio_condition
        FROM
            ref_nomenclatures.t_nomenclatures) condition_bio USING (id_nomenclature_bio_condition)
    LEFT JOIN (
        SELECT
            label_default AS preuve_existante,
            id_nomenclature AS id_nomenclature_exist_proof
        FROM
            ref_nomenclatures.t_nomenclatures) preuve USING (id_nomenclature_exist_proof)
    LEFT JOIN (
        SELECT
            label_default AS statut_validation,
            id_nomenclature AS id_nomenclature_valid_status
        FROM
            ref_nomenclatures.t_nomenclatures) valid USING (id_nomenclature_valid_status)
    LEFT JOIN (
        SELECT
            label_default AS sexe,
            id_nomenclature AS id_nomenclature_sex
        FROM
            ref_nomenclatures.t_nomenclatures) sexe USING (id_nomenclature_sex)
    LEFT JOIN (
        SELECT
            label_default AS objet_denombrement,
            id_nomenclature AS id_nomenclature_obj_count
        FROM
            ref_nomenclatures.t_nomenclatures) denombre USING (id_nomenclature_obj_count)
    LEFT JOIN (
        SELECT
            label_default AS type_denombrement,
            id_nomenclature AS id_nomenclature_type_count
        FROM
            ref_nomenclatures.t_nomenclatures) typ_count USING (id_nomenclature_type_count)
    LEFT JOIN (
        SELECT
            label_default AS comportement,
            id_nomenclature AS id_nomenclature_behaviour
        FROM
            ref_nomenclatures.t_nomenclatures) comportement USING (id_nomenclature_behaviour)
WHERE
    cd_nom = 61098
    AND id_nomenclature_info_geo_type = 126
