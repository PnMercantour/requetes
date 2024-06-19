# Taxonomie

```sql

create schema f_taxonomie;

import foreign schema taxonomie fromserver srv_geonature into f_taxonomie;

```

```sql

createtablef_gn_synthese.cd_11as

(select distinct cd_nom fromf_gn_synthese.synthese s );


createtablef_gn_synthese.cd_ref11as (select distinct cd_ref fromf_gn_synthese.synthese s joinf_taxonomie.taxrefusing (cd_nom));


truncatetaxonomie.cor_nom_liste;


-- on construit la liste des taxons observés en v11 augmentée de celle de leurs cd_ref v11

-- on réduit la liste open_cd des cd_ref uniques en v17

-- on crée des correspondances pour ces taxons

-- TODO? ajouter les taxons parents?

with tax_in as (

select

    cd_nom

from

taxonomie.taxref

joinf_gn_synthese.cd_11

using (cd_nom)

union

select

    cd_nom

from

taxonomie.taxref

joinf_gn_synthese.cd_ref11on

    (taxref.cd_nom=cd_ref11.cd_ref)),

open_cd as (

select

distinct cd_ref cd_nom

from

taxonomie.taxref

join tax_in

using (cd_nom))

insert

into

taxonomie.cor_nom_liste (id_liste,

    id_nom)

select

100 id_liste,

    id_nom

from

taxonomie.bib_noms bn

join open_cd

using(cd_nom);

```
