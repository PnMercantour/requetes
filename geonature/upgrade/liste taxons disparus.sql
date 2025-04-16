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
select *
from f_taxonomie.taxref
    join disparus using (cd_nom)
order by regne,
    group1_inpn,
    group2_inpn,
    nom_valide;