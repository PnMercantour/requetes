--
--
ALTER TABLE gn_synthese.cor_area_synthese DISABLE TRIGGER tri_maj_cor_area_taxon;
--
--
insert into gn_synthese.cor_area_synthese (id_synthese, id_area) with commune as (
        select id_area,
            geom
        from ref_geo.l_areas la
        where id_type = 25
    )
select s.id_synthese,
    commune.id_area
from commune
    cross join gn_synthese.synthese s
    left join gn_synthese.cor_area_synthese vu using(id_area, id_synthese)
where vu.id_synthese is null
    and st_intersects(s.the_geom_local, commune.geom)
    and s.id_nomenclature_info_geo_type = 126;
--

--
--
--
insert into gn_synthese.cor_area_synthese (id_synthese, id_area) with attachment as (
select distinct id_area_attachment
from gn_synthese.synthese
where id_nomenclature_info_geo_type = 127
),
area as (
    select id_area_attachment,
        st_area(geom) area,
        geom
    from ref_geo.l_areas
        join attachment on id_area = id_area_attachment
),
commune as (
    select id_area,
        geom
    from ref_geo.l_areas
    where id_type = 25
),
selection as (
    select commune.id_area,
        area.id_area_attachment
    from area,
        commune
    where st_area(st_intersection(area.geom, commune.geom)) / area.area > 0.01
)
select id_synthese,
    id_area
from gn_synthese.synthese
    join selection using (id_area_attachment) on conflict do nothing;
--
ALTER TABLE gn_synthese.cor_area_synthese enable TRIGGER tri_maj_cor_area_taxon;
--
--
with commune as (
    select id_area,
        geom
    from ref_geo.l_areas
    where id_type = 25
),
maj as (
    select cd_nom,
        id_area,
        count(*) nb_obs,
        max(date_min) last_date
    from gn_synthese.cor_area_synthese c
        join commune using(id_area)
        join gn_synthese.synthese using (id_synthese)
    group by id_area,
        cd_nom
)
insert into gn_synthese.cor_area_taxon(cd_nom, id_area, nb_obs, last_date)
select *
from maj on conflict on constraint pk_cor_area_taxon do
update
set nb_obs = excluded.nb_obs,
    last_date = excluded.last_date
where cor_area_taxon.cd_nom = excluded.cd_nom
    and cor_area_taxon.id_area = excluded.id_area;