# Métadonnées

```sql


-- metadata

create schema f_gn_meta;

import foreign schema gn_meta fromserver srv_geonature into f_gn_meta;

select*fromf_gn_meta.t_acquisition_frameworks;


altertablegn_meta.t_acquisition_frameworksdisable trigger user;


insertintogn_meta.t_acquisition_frameworks (unique_acquisition_framework_id, acquisition_framework_name, acquisition_framework_desc, id_nomenclature_territorial_level, territory_desc, keywords,

id_nomenclature_financing_type, acquisition_framework_start_date, acquisition_framework_end_date, meta_create_date, meta_update_date, id_digitizer)

select unique_acquisition_framework_id, acquisition_framework_name, acquisition_framework_desc,

territ.nouveau_id,

territory_desc, keywords,

finance.nouveau_id ,

acquisition_framework_start_date, acquisition_framework_end_date, meta_create_date, meta_update_date,

nouveau_roles.id_role

fromf_gn_meta.t_acquisition_frameworks

left joinf_ref_nomenclatures.nomen territ on id_nomenclature_territorial_level =territ.ancien_id

left joinf_ref_nomenclatures.nomen finance on id_nomenclature_financing_type =finance.ancien_id

left joinf_utilisateurs.t_roles ancien_roles on id_digitizer =ancien_roles.id_role

left joinutilisateurs.t_roles nouveau_roles onnouveau_roles.uuid_role=ancien_roles.uuid_role

on conflict do nothing;


altertablegn_meta.t_acquisition_frameworksenable trigger user;


insert

into

gn_meta.cor_acquisition_framework_actor (id_acquisition_framework,

    id_organism,

    id_nomenclature_actor_role)

select

taf.id_acquisition_framework,

org.nouveau_id id_organism,

f_ref_nomenclatures.new_id(f_cafa.id_nomenclature_actor_role) id_nomenclature_actor_role

from

f_gn_meta.cor_acquisition_framework_actor f_cafa

left joinf_utilisateurs.org org on

    (f_cafa.id_organism=org.ancien_id)

left joinf_gn_meta.t_acquisition_frameworks f_taf on

    (f_cafa.id_acquisition_framework=f_taf.id_acquisition_framework)

left joingn_meta.t_acquisition_frameworks taf

using (unique_acquisition_framework_id);


insert

into

gn_meta.cor_acquisition_framework_objectif (id_acquisition_framework,

    id_nomenclature_objectif)

select

taf.id_acquisition_framework,

f_ref_nomenclatures.new_id(f_cafo.id_nomenclature_objectif) id_nomenclature_objectif

from

f_gn_meta.cor_acquisition_framework_objectif f_cafo

left joinf_gn_meta.t_acquisition_frameworks f_taf on

    (f_cafo.id_acquisition_framework=f_taf.id_acquisition_framework)

left joingn_meta.t_acquisition_frameworks taf

using (unique_acquisition_framework_id);


insert

into

gn_meta.cor_acquisition_framework_voletsinp (id_acquisition_framework,

    id_nomenclature_voletsinp)

select

taf.id_acquisition_framework,

f_ref_nomenclatures.new_id(f_cafo.id_nomenclature_voletsinp) id_nomenclature_voletsinp

from

f_gn_meta.cor_acquisition_framework_voletsinp f_cafo

left joinf_gn_meta.t_acquisition_frameworks f_taf on

    (f_cafo.id_acquisition_framework=f_taf.id_acquisition_framework)

left joingn_meta.t_acquisition_frameworks taf

using (unique_acquisition_framework_id);


```

Correspondance entre jeux de donnés

```sql

selectftd.id_dataset fid, td.id_dataset id fromf_gn_meta.t_datasets ftd left joingn_meta.t_datasets td using (unique_dataset_id) ;

```

Table des jeux de données

```sql

altertablegn_meta.t_datasetsdisable trigger user;

insert

into

gn_meta.t_datasets(unique_dataset_id,

    id_acquisition_framework,

    dataset_name,

    dataset_shortname,

    dataset_desc,

    id_nomenclature_data_type,

    keywords,

    marine_domain,

    terrestrial_domain,

    id_nomenclature_dataset_objectif,

    bbox_west,

    bbox_east,

    bbox_south,

    bbox_north,

    id_nomenclature_collecting_method,

    id_nomenclature_data_origin,

    id_nomenclature_source_status,

    id_nomenclature_resource_type,

    active,

    meta_create_date,

    meta_update_date,

    validable,

    id_digitizer)

select

    unique_dataset_id ,

taf.id_acquisition_framework,

f_td.dataset_name,

f_td.dataset_shortname,

f_td.dataset_desc,

f_ref_nomenclatures.new_id(id_nomenclature_data_type) id_nomenclature_data_type,

f_td.keywords,

f_td.marine_domain,

f_td.terrestrial_domain,

f_ref_nomenclatures.new_id(f_td.id_nomenclature_dataset_objectif) id_nomenclature_dataset_objectif,

f_td.bbox_west ,

f_td.bbox_east ,

f_td.bbox_south ,

f_td.bbox_north ,

f_ref_nomenclatures.new_id(f_td.id_nomenclature_collecting_method) id_nomenclature_collecting_method,

f_ref_nomenclatures.new_id(f_td.id_nomenclature_data_origin) id_nomenclature_data_origin,

f_ref_nomenclatures.new_id(f_td.id_nomenclature_source_status) id_nomenclature_source_status,

f_ref_nomenclatures.new_id(f_td.id_nomenclature_resource_type) id_nomenclature_resource_type,

f_td.active,

f_td.meta_create_date,

f_td.meta_update_date ,

f_td.validable ,

t_roles.id_role id_digitizer

from

f_gn_meta.t_datasets f_td

joinf_gn_meta.t_acquisition_frameworks f_taf

using (id_acquisition_framework)

joingn_meta.t_acquisition_frameworks taf

using (acquisition_framework_name)

left joinf_utilisateurs.t_roles f_roles on

    (f_td.id_digitizer=f_roles.id_role)

left joinutilisateurs.t_roles

using (uuid_role)

on conflict do nothing;


altertablegn_meta.t_datasetsenable trigger user;


insert

into

gn_meta.cor_dataset_actor (id_dataset,

    id_role,

    id_organism,

    id_nomenclature_actor_role)

select

td.id_dataset,

t_roles.id_role id_role,

org.nouveau_id id_organism,

f_ref_nomenclatures.new_id(f_cda.id_nomenclature_actor_role) id_nomenclature_actor_role

from

f_gn_meta.cor_dataset_actor f_cda

left joinf_utilisateurs.t_roles f_roles on

    (f_cda.id_role=f_roles.id_role)

left joinutilisateurs.t_roles

using (uuid_role)

left joinf_utilisateurs.org org on

    (f_cda.id_organism=org.ancien_id)

left joinf_gn_meta.t_datasets f_td on

    (f_cda.id_dataset=f_td.id_dataset)

left joingn_meta.t_datasets td

using (unique_dataset_id);


```
