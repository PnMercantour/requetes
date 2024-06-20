# Taxonomie

```sql

create schema f_taxonomie;

import foreign schema taxonomie from server srv_geonature into f_taxonomie;

```

```sql

create table f_gn_synthese.cd_11 as

(select distinct cd_nom from f_gn_synthese.synthese s );


create table f_gn_synthese.cd_ref11 as (select distinct cd_ref from f_gn_synthese.synthese s join f_taxonomie.taxref using (cd_nom));


truncate taxonomie.cor_nom_liste;


-- on construit la liste des taxons observés en v11 augmentée de celle de leurs cd_ref v11

-- on réduit la liste open_cd des cd_ref uniques en v17

-- on crée des correspondances pour ces taxons

-- TODO? ajouter les taxons parents?

with tax_in as (

select

    cd_nom

from

taxonomie.taxref

join f_gn_synthese.cd_11

using (cd_nom)

union

select

    cd_nom

from

taxonomie.taxref

join f_gn_synthese.cd_ref11 on

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
