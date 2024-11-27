# occtax

Ouvrir le schema original (ancien geonature) en lecture pour l'utilisateur fdw.

```sql
grant usage on schema pr_occtax to "data.mercantour-parcnational.fr";
grant select on all tables in schema pr_occtax to "data.mercantour-parcnational.fr";
```

```sql
create schema f_pr_occtax;
import foreign schema pr_occtax from server srv_geonature into f_pr_occtax;

create schema f_pr_occtax;

import foreign schema pr_occtax
from
server srv_geonature
into
	f_pr_occtax;
```

Création d'un index unique pour éviter les doublons à l'import.

```sql
CREATE UNIQUE INDEX t_releves_occtax_unique_id_sinp_grp_idx ON pr_occtax.t_releves_occtax (unique_id_sinp_grp);
```

## Relevés occtax

```sql
alter table pr_occtax.t_releves_occtax disable trigger user;

with datasets as (
select
	ftd.id_dataset fid,
	td.id_dataset id
from
	f_gn_meta.t_datasets ftd
join gn_meta.t_datasets td -- On ignore les datasets non importés
		using (unique_dataset_id)),
roles as (
select
	f_t_roles.id_role fid,
	t_roles.id_role id
from
	f_utilisateurs.t_roles f_t_roles
join utilisateurs.t_roles -- On ignore les roles non importés
		using (uuid_role))
insert
	into
	pr_occtax.t_releves_occtax(unique_id_sinp_grp,
	id_dataset,
	id_digitiser,
	id_nomenclature_tech_collect_campanule,
	id_nomenclature_grp_typ,
	date_min,
	date_max,
	hour_min,
	hour_max,
	altitude_min,
	altitude_max,
	meta_device_entry,
	comment,
	geom_local,
	geom_4326,
	precision,
	id_nomenclature_geo_object_nature,
	cd_hab,
	id_module)
select
	ftro.unique_id_sinp_grp ,
	datasets.id id_dataset,
	roles.id id_digitiser,
	f_ref_nomenclatures.new_id(ftro.id_nomenclature_tech_collect_campanule) id_nomenclature_tech_collect_campanule,
	f_ref_nomenclatures.new_id(ftro.id_nomenclature_grp_typ) id_nomenclature_grp_typ,
	ftro.date_min,
	ftro.date_max,
	ftro.hour_min,
	ftro.hour_max,
	ftro.altitude_min,
	ftro.altitude_max,
	ftro.meta_device_entry,
	ftro.comment,
	ftro.geom_local,
	ftro.geom_4326,
	ftro.precision,
	f_ref_nomenclatures.new_id(ftro.id_nomenclature_geo_object_nature) id_nomenclature_geo_object_nature,
	ftro.cd_hab,
	4 id_module
from
	f_pr_occtax.t_releves_occtax ftro
left join datasets on -- valeur nulle si le dataset n'a pas été importé
	(ftro.id_dataset = datasets.fid)
left join roles on -- valeur nulle si le role n'a pas été importé (ou s'il n'est pas spécifié dans l'original)
	(ftro.id_digitiser = roles.fid)
on conflict do nothing;

alter table pr_occtax.t_releves_occtax enable trigger user;
```

## Observateurs

table de correspondance cor_role_releves_occtax

utilité de unique_id_cor_role_releve ?

4 index :
clé primaire (id_releve_occtax, id_role)
id_role
id_releve_occtax
unique index (id_role, id_releve_occtax) Celui-ci me semble redondant.

une autre table de correspondance dans la synthese (si elle ne sert qu'à occtax, elle fait doublon avec la précédente)

agrégation dans la synthèse (tous les observateurs ne sont pas référencés par role, certains seulement par leur nom)

```sql
alter table pr_occtax.cor_role_releves_occtax disable trigger user;

with releves as (
select
	ftro.id_releve_occtax fid,
	tro.id_releve_occtax id
from
	f_pr_occtax.t_releves_occtax ftro
join pr_occtax.t_releves_occtax tro
	-- les relevés non importés sont ignorés
		using(unique_id_sinp_grp)),
		roles as (
select
	f_t_roles.id_role fid,
	t_roles.id_role id
from
	f_utilisateurs.t_roles f_t_roles
join utilisateurs.t_roles
	-- les roles non importés sont ignorés
		using (uuid_role))
insert
	into
	pr_occtax.cor_role_releves_occtax (unique_id_cor_role_releve,
	id_releve_occtax,
	id_role)
select
	unique_id_cor_role_releve,
	releves.id id_releve_occtax ,
	roles.id id_role
from
	f_pr_occtax.cor_role_releves_occtax fcrro
join releves on
	(fcrro.id_releve_occtax = releves.fid)
join roles on
	(fcrro.id_role = roles.fid)
on conflict do nothing;

alter table pr_occtax.cor_role_releves_occtax enable trigger user;
```

## Occurrences occtax

Il manque une contrainte d'unicité sur l'attribut unique_id_occurence_occtax

```sql
CREATE UNIQUE INDEX t_occurrences_occtax_unique_id_occurence_occtax_idx ON pr_occtax.t_occurrences_occtax (unique_id_occurence_occtax);
```

```sql
alter table pr_occtax.t_occurrences_occtax disable trigger user;

with releves as (
select
	ftro.id_releve_occtax fid,
	tro.id_releve_occtax id
from
	f_pr_occtax.t_releves_occtax ftro
join pr_occtax.t_releves_occtax tro -- les relevés non importés sont ignorés
		using(unique_id_sinp_grp))
insert
	into
	pr_occtax.t_occurrences_occtax (unique_id_occurence_occtax,
	id_releve_occtax,
	id_nomenclature_obs_technique,
	id_nomenclature_bio_condition ,
	id_nomenclature_bio_status,
	id_nomenclature_naturalness,
	id_nomenclature_exist_proof,
	id_nomenclature_diffusion_level,
	id_nomenclature_observation_status,
	id_nomenclature_blurring,
	id_nomenclature_source_status,
	determiner,
	id_nomenclature_determination_method,
	cd_nom,
	nom_cite,
	meta_v_taxref,
	id_nomenclature_behaviour)
select
	ftoo.unique_id_occurence_occtax,
	releves.id id_releve_occtax,
	f_ref_nomenclatures.new_id(ftoo.id_nomenclature_obs_technique) id_nomenclature_obs_technique ,
	f_ref_nomenclatures.new_id(ftoo.id_nomenclature_bio_condition) id_nomenclature_bio_condition ,
	f_ref_nomenclatures.new_id(ftoo.id_nomenclature_bio_status) id_nomenclature_bio_status ,
	f_ref_nomenclatures.new_id(ftoo.id_nomenclature_naturalness)id_nomenclature_naturalness ,
	f_ref_nomenclatures.new_id(ftoo.id_nomenclature_exist_proof) id_nomenclature_exist_proof ,
	f_ref_nomenclatures.new_id(ftoo.id_nomenclature_diffusion_level) id_nomenclature_diffusion_level ,
	f_ref_nomenclatures.new_id(ftoo.id_nomenclature_observation_status) id_nomenclature_observation_status ,
	f_ref_nomenclatures.new_id(ftoo.id_nomenclature_blurring) id_nomenclature_blurring ,
	f_ref_nomenclatures.new_id(ftoo.id_nomenclature_source_status) id_nomenclature_source_status ,
	ftoo.determiner,
	f_ref_nomenclatures.new_id(ftoo.id_nomenclature_determination_method) id_nomenclature_determination_method ,
	coalesce(taxref.cd_nom, td.cd_nom17) cd_nom,
	ftoo.nom_cite,
	case when taxref.cd_nom is not null then ftoo.meta_v_taxref else 'Taxref V11->V17' end meta_v_taxref,
	f_ref_nomenclatures.new_id(ftoo.id_nomenclature_behaviour) id_nomenclature_behaviour
from
	f_pr_occtax.t_occurrences_occtax ftoo
join releves on
	ftoo.id_releve_occtax = releves.fid
left join taxonomie.taxref using (cd_nom)
left join f_taxonomie.taxons_disparus td using(cd_nom)
on conflict do nothing;

alter table pr_occtax.t_occurrences_occtax enable trigger user;
```

TODO: import des occurrences de taxons disparus, avec table de conversion.

## Comptages occtax

```sql
alter table pr_occtax.cor_counting_occtax disable trigger user;

with occurrences as (
select
	ftoo.id_occurrence_occtax fid,
	too.id_occurrence_occtax id
from
	f_pr_occtax.t_occurrences_occtax ftoo
join pr_occtax.t_occurrences_occtax too
	-- les occurrences non importées sont ignorées
		using (unique_id_occurence_occtax)
)
insert
	into
	pr_occtax.cor_counting_occtax(unique_id_sinp_occtax,
	id_occurrence_occtax,
	id_nomenclature_life_stage,
	id_nomenclature_sex,
	id_nomenclature_obj_count,
	id_nomenclature_type_count,
	count_min,
	count_max)
select
	fcco.unique_id_sinp_occtax ,
	occurrences.id id_occurrence_occtax ,
	f_ref_nomenclatures.new_id(fcco.id_nomenclature_life_stage) id_nomenclature_life_stage ,
	f_ref_nomenclatures.new_id(fcco.id_nomenclature_sex) id_nomenclature_sex ,
	f_ref_nomenclatures.new_id(fcco.id_nomenclature_obj_count) id_nomenclature_obj_count ,
	f_ref_nomenclatures.new_id(fcco.id_nomenclature_type_count) id_nomenclature_type_count ,
	fcco.count_min ,
	fcco.count_max
from
	f_pr_occtax.cor_counting_occtax fcco
join occurrences on
	fcco.id_occurrence_occtax = occurrences.fid
on conflict do nothing;

alter table pr_occtax.cor_counting_occtax enable trigger user;

```

les stades de vie floraison (832) et végétatif (837) sont ignorés
