--
-- observations explornature (date et périmètre correspondant à l'explornature) à contrôler 
-- car potentiellement associées par erreur 
-- à un dataset qui n'est pas dans le CA explornature
select synthese.*
from gn_synthese.synthese
    join gn_synthese.cor_area_synthese cas using (id_synthese)
    join ref_geo.l_areas on cas.id_area = l_areas.id_area
    join gn_meta.t_datasets using (id_dataset)
    join gn_meta.t_acquisition_frameworks using (id_acquisition_framework)
where area_name = 'VALDEBLORE'
    and unique_acquisition_framework_id != '948880b0-7e46-4941-bbd9-ded1635bf716'::uuid
    and date_min >= '2022-06-30'
    and date_max < '2022-07-04';
-- observations geonature associées par erreur au cadre d'acquisition explornature Valdeblore.
-- la date d'observation ou la localisation géographique ne correspondent pas.
select cas.*,
    s.*
from gn_synthese.synthese s
    join gn_meta.t_datasets using (id_dataset)
    join gn_meta.t_acquisition_frameworks using (id_acquisition_framework)
    left join gn_synthese.cor_area_synthese cas on (
        s.id_synthese = cas.id_synthese
        and cas.id_area = 5363
    )
where unique_acquisition_framework_id = '948880b0-7e46-4941-bbd9-ded1635bf716'::uuid
    and (
        date_max < '2022-06-30'
        or date_min >= '2022-07-04'
        or cas.id_area = 0
    );
-- correction des relevés occtax qui auraient dû être associés au jeu de données occtax explornature
with releves as(
    select *
    from pr_occtax.t_releves_occtax tro
        join ref_geo.l_areas la on st_within(geom_local, geom)
    where date_min >= '2022-06-30'
        and date_max < '2022-07-04'
        and id_dataset = 100
        and area_name = 'VALDEBLORE'
)
update pr_occtax.t_releves_occtax t
set id_dataset = 181
from releves
where t.id_releve_occtax = releves.id_releve_occtax;
--
--
-- Pour les relevés hors période, on s'efforce de corriger le dataset (si saisie occtax).
-- Par contre, c'est compliqué à faire pour les imports, on laisse le dataset d'origine mais on filtre le résultat
-- avant de l'exploiter.