-- liste des datasets dans pr_occtax correspondant aux dates et a la localisation de l'explornature
with iso as (SELECT * 
			 from ref_geo.li_municipalities mun 
			 join ref_geo.l_areas using(id_area)
			where mun.nom_com = 'Isola')
select distinct(tro.id_dataset), tda.dataset_name 
from pr_occtax.t_releves_occtax tro
join iso on st_contains(iso.geom, tro.geom_local)
join gn_meta.t_datasets tda using (id_dataset)
where date_min::date >= '2024-06-27' and  date_max::date <= '2024-06-30' 


-- liste des digitisers pour les jeux de données qui ne sont pas celui de l'explornature pour vérification
with iso as (SELECT * 
			 from ref_geo.li_municipalities mun 
			 join ref_geo.l_areas using(id_area)
			where mun.nom_com = 'Isola')
select distinct(tro.id_digitiser), troles.nom_role 
from pr_occtax.t_releves_occtax tro
join iso on st_contains(iso.geom, tro.geom_local)
join gn_meta.t_datasets tda using (id_dataset)
join utilisateurs.t_roles troles on tro.id_digitiser = troles.id_role
where date_min::date >= '2024-06-27' and  date_max::date <= '2024-06-30' 
and id_dataset !=7


-- changement de l'id_dataset pour les releves concernes 
BEGIN ;
UPDATE  pr_occtax.t_releves_occtax tro1
set id_dataset = 7
where tro1.id_releve_occtax in ( select id_releve_occtax from 
 (with iso as (SELECT * 
 			 from ref_geo.li_municipalities mun 
 			 join ref_geo.l_areas using(id_area)
 			where mun.nom_com = 'Isola')
 select tro.*
 from pr_occtax.t_releves_occtax tro
 join iso on st_contains(iso.geom, tro.geom_local)
 where date_min::date >= '2024-06-27' and  date_max::date <= '2024-06-30' 
and id_dataset !=7)  sub);
with iso as (SELECT * 
 			 from ref_geo.li_municipalities mun 
 			 join ref_geo.l_areas using(id_area)
 			where mun.nom_com = 'Isola')
select * from pr_occtax.t_releves_occtax tro
 join iso on st_contains(iso.geom, tro.geom_local)
 where date_min::date >= '2024-06-27' and  date_max::date <= '2024-06-30';
ROLLBACK;
