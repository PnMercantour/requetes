# Nomenclature

```sql

create schema f_ref_nomenclatures;

import foreign schema ref_nomenclatures from server srv_geonature into f_ref_nomenclatures;


create table f_ref_nomenclatures.typesas

select ancien.id_type ancien_id_type, nouveau.id_type nouveau_id_type,  ancien.mnemonique from f_ref_nomenclatures.bib_nomenclatures_types ancien  join ref_nomenclatures.bib_nomenclatures_types nouveau using(mnemonique);


create unique index onf_ref_nomenclatures.types (ancien_id_type)


create table f_ref_nomenclatures.nomen as

select ancien.id_nomenclature ancien_id, nouveau.id_nomenclature nouveau_id from f_ref_nomenclatures.t_nomenclatures ancien join f_ref_nomenclatures.types on ancien.id_type=types.ancien_id_type join ref_nomenclatures.t_nomenclatures nouveau on nouveau.id_type=types.nouveau_id_type

where ancien.cd_nomenclature = nouveau.cd_nomenclature;


create unique index on f_ref_nomenclatures.nomen (ancien_id);


CREATE OR REPLACE FUNCTION f_ref_nomenclatures.new_id(myidnomenclature integer)

RETURNS integer

LANGUAGE plpgsql

 IMMUTABLE

AS $function$

--Function which return the new id_nomenclature from the old id_nomenclature

DECLARE theidnomenclature integer;

begin

if myidnomenclature is null then

return null;

endif;


select

into

    theidnomenclature nouveau_id

from

f_ref_nomenclatures.nomen

where

nomen.ancien_id = myidnomenclature;

if theidnomenclature is null then

raise EXCEPTION 'Error : f_ref_nomenclatures.new_id(%) not found', myidnomenclature ;

else

return theidnomenclature;

endif;

end;


$function$

;
```

ajouts dans la table nomen (id_nomenclatures disparus)

- 325 323 type de données
