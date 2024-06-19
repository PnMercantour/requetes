# ref_geo

désactiver les départements et régions (calcul complexe)

l_areas: deux unique indexes sur id_type, area_code

lorsqu'on désactive une area, on pourrait la supprimer de cor_area_synthese

```sql
-- inspection préalable
select
	id_type,
	count (*)
from
	ref_geo.l_areas la
where
	"enable"
group by
	id_type;

-- les communes et mailles sont désactivées.
update
	ref_geo.l_areas la
set
	enable = false
where
	enable
	and id_type in (25, 27, 28, 29);

-- ajout des communes AOA
with communes as (
select
	distinct code_insee
from
	ref_geo.commune_pnm ),
comms as (
select
	id_area
from
	ref_geo.li_municipalities lm
join communes on
	code_insee = insee_com)
update
	ref_geo.l_areas
set
	"enable" = true
from
	comms
where
	l_areas.id_area = comms.id_area;

-- ajout des communes limitrophes de l'AOA
with t as (
select
	*
from
	ref_geo.l_areas la
where
	enable
	and id_type = 25)
update
	ref_geo.l_areas la
set
	enable = true
from
	t
where
	la.id_type = 25
	and st_touches(la.geom,
	t.geom)

-- ajout des mailles 1k, 5k, 10k qui intersectent les communes sélectionnées
update
	ref_geo.l_areas la
set
	enable = true
from
	(
	select
		*
	from
		ref_geo.l_areas la
	where
		enable
		and id_type = 25) t
where
	st_intersects(la.geom,
	t.geom)
	and la.id_type in (27, 28, 29);

-- suppression des mailles inutilisées
delete
from
	ref_geo.l_areas
where
	id_type in (27, 28, 29)
	and not enable;
```
