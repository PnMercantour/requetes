with communes as (
    select id_area,
        area_name commune
    from ref_geo.l_areas
        join ref_geo.bib_areas_types using (id_type)
    where bib_areas_types.type_code::text = 'COM'::text
),
t_datasets as (
    select *
    from gn_meta.t_datasets
    where ref_nomenclatures.get_cd_nomenclature (id_nomenclature_data_origin) = 'Pu'
        and id_acquisition_framework not in (7, 90, 91, 92, 93, 95)
)
select id_synthese,
    s.centroid_2154,
    s.unique_id_sinp,
    t_datasets.dataset_name,
    t_datasets.unique_dataset_id,
    s.nom_cite,
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
    ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_geo_object_nature) as nat_obj_geo,
    ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_grp_typ) as typ_grp,
    ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_obs_technique) as meth_obs,
    ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_bio_status) as statut_bio,
    ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_bio_condition) as eta_bio,
    ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_naturalness) as naturalite,
    ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_exist_proof) as preuve_exist,
    ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_valid_status) as statut_valid,
    ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_diffusion_level) as niv_precis,
    ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_life_stage) as stade_vie,
    ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_sex) as sexe,
    ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_obj_count) as obj_denbr,
    ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_type_count) as typ_denbr,
    ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_sensitivity) as sensibilite,
    ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_observation_status) as statut_obs,
    ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_blurring) as dee_flou,
    ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_source_status) as statut_source,
    ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_info_geo_type) as type_inf_geo,
    ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_determination_method) as meth_determin,
    ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_behaviour) as occ_comportement,
    ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_biogeo_status) as stat_biogeo
from gn_synthese.synthese s
    join gn_synthese.cor_area_synthese using (id_synthese)
    join communes using (id_area)
    join t_datasets using (id_dataset)
    join taxonomie.taxref using (cd_nom)
where commune in ('SAINT-MARTIN-VESUBIE', 'BELVEDERE')
    and ref_nomenclatures.get_cd_nomenclature (s.id_nomenclature_info_geo_type) = '1'
    and taxref.regne = 'Plantae'