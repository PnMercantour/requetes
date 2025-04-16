with cd as (
    select distinct cd_nom
    from f_gn_synthese.synthese s
),
disparus as (
    select cd_nom
    from cd
        left join taxonomie.taxref using (cd_nom)
    where taxref.cd_nom is null
)
select td.dataset_name,
    cd_nom,
    nom_cite,
    the_geom_local,
    date_min,
    observers
from f_gn_synthese.synthese
    join disparus using (cd_nom)
    left join f_gn_meta.t_datasets td using (id_dataset)
order by dataset_name,
    cd_nom,
    date_min;