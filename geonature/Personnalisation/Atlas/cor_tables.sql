create table gn_synthese.tmp as with atlas as (
    select geom
    from ref_geo.l_areas la
    where id_area = 5498
)
select s.id_synthese
from gn_synthese.synthese s
    left join (
        select *
        from gn_synthese.cor_area_synthese
        where id_area = 5498
    ) vu using (id_synthese),
    atlas
where vu.id_synthese is null
    and st_intersects(s.the_geom_local, atlas.geom)
    and s.id_nomenclature_info_geo_type = 126;
--
--
ALTER TABLE gn_synthese.cor_area_synthese DISABLE TRIGGER tri_maj_cor_area_taxon;
--
--
insert into gn_synthese.cor_area_synthese (id_synthese, id_area)
select id_synthese,
    5498 id_area
from gn_synthese.tmp on conflict do nothing --
--
ALTER TABLE gn_synthese.cor_area_synthese enable TRIGGER tri_maj_cor_area_taxon;
--
--
with attachment as (
    select distinct id_area_attachment
    from gn_synthese.synthese
    where id_nomenclature_info_geo_type = 127
),
b as (
    select geom
    from ref_geo.l_areas
    where id_area = 5498
),
areas as (
    select id_area,
        st_area(a.geom) area,
        st_area(st_intersection(a.geom, b.geom)) intersection
    from ref_geo.l_areas a
        join attachment on id_area = id_area_attachment,
        b
)
select id_area
from areas
where intersection / area > 0.01;
--
--
--
insert into gn_synthese.cor_area_synthese(id_synthese, id_area)
with attachment as (
    select distinct id_area_attachment
    from gn_synthese.synthese
    where id_nomenclature_info_geo_type = 127
),
b as (
    select geom
    from ref_geo.l_areas
    where id_area = 5498
),
areas as (
    select id_area,
        st_area(a.geom) area,
        st_area(st_intersection(a.geom, b.geom)) intersection
    from ref_geo.l_areas a
        join attachment on id_area = id_area_attachment,
        b
),
selection as (
    select id_area id_area_attachment
    from areas
    where intersection / area > 0.01
),
obs as (
    select id_synthese
    from gn_synthese.synthese
        join selection using (id_area_attachment)
)
select id_synthese,
    5498 id_area
from obs on conflict do nothing;
--
--
--
update gn_synthese.cor_area_taxon 
set nb_obs = c.nb_obs,
    last_date = c.last_date
from (
        select cd_nom,
            count(*) nb_obs,
            max(date_min) last_date
        from gn_synthese.cor_area_synthese cas
            join gn_synthese.synthese s using (id_synthese)
        where cas.id_area = 5498
        group by cd_nom
    ) c
where cor_area_taxon.id_area = 5498
    and c.cd_nom = cor_area_taxon.cd_nom;