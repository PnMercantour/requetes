# Nomenclature

```sql

create schema f_ref_nomenclatures;

import foreign schema ref_nomenclatures fromserver srv_geonature into f_ref_nomenclatures;


createtablef_ref_nomenclatures.typesas

selectancien.id_type ancien_id_type, nouveau.id_type nouveau_id_type,  ancien.mnemoniquefromf_ref_nomenclatures.bib_nomenclatures_types ancien  joinref_nomenclatures.bib_nomenclatures_types nouveau using(mnemonique);


create unique index onf_ref_nomenclatures.types (ancien_id_type)


createtablef_ref_nomenclatures.nomenas

selectancien.id_nomenclature ancien_id, nouveau.id_nomenclature nouveau_id fromf_ref_nomenclatures.t_nomenclatures ancien joinf_ref_nomenclatures.typesonancien.id_type=types.ancien_id_typejoinref_nomenclatures.t_nomenclatures nouveau onnouveau.id_type=types.nouveau_id_type

whereancien.cd_nomenclature=nouveau.cd_nomenclature;


create unique index onf_ref_nomenclatures.nomen (ancien_id);


CREATEORREPLACEFUNCTIONf_ref_nomenclatures.new_id(myidnomenclature integer)

RETURNSinteger

LANGUAGE plpgsql

 IMMUTABLE

AS $function$

--Function which return the new id_nomenclature from the old id_nomenclature

DECLARE theidnomenclature integer;

begin

if myidnomenclature isnullthen

returnnull;

endif;


select

into

    theidnomenclature nouveau_id

from

f_ref_nomenclatures.nomen

where

nomen.ancien_id= myidnomenclature;

if theidnomenclature isnullthen

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
