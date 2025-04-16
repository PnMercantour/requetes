# Personnalisation de l'instance geonature atlas du PNM

Geonature atlas est un client de la base de données geonature.
L'interface entre les deux applications repose sur des foreign data wrappers (dans atlas, pointant sur des tables et vues geonature).

Contrôle des observations et taxons diffusés par geonature vers atlas.

## Visibilité des taxons

Par défaut, tous les taxons sont visibles dans l'atlas. Il est possible d'exclure des taxons en les ajoutant à la table `taxonomie.atlas_excluded` (dans geonature)

## Visibilité des observations

Les observations visibles dans l'atlas sont sélectionnées dans la vue `gn_synthese.synthese4atlas` (dans geonature).  
La sélection porte sur le jeu de données, qui doit être associé à l'organisme PNM avec un role `ROLE_ACTEUR` de valeur '2' à '8' (le role 1 - contact principal est exclus) et sur le taxon qui doit être visible.

```sql
with all_dataset as (
    select id_dataset, count(*) all_count from gn_synthese.cor_area_synthese cas join gn_synthese.synthese sa using(id_synthese) where id_area = 5139
  group by id_dataset),
  atlas_dataset as (
    select id_dataset, count(*) atlas_count from gn_synthese.cor_area_synthese cas join gn_synthese.synthese4atlas sa using(id_synthese) where id_area = 5139
  group by id_dataset)
  select * from all_dataset left join atlas_dataset using (id_dataset) join gn_meta.t_datasets using (id_dataset)  where atlas_count is null or all_count > atlas_count;
```

TODO: simplifier la requête de filtrage : on laisse passer tous les datasets, si PNM est organisme participant, on valide (et on laisse tel quel le niveau de diffusion de l'observation), si PNM n'est pas participant, on valide mais on change le niveau de diffusion : commune.

## niveau de diffusion des observations

Les observations sont associées individuellement à un niveau de précision de la diffusion id_nomenclature_diffusion_level de type `NIV_PRECIS`. Le cd_nomenclature prend une valeur '0' à '5'.

https://github.com/PnX-SI/GeoNature-atlas/blob/1.5.1/data/gn2/atlas_synthese.sql#L22-L36

Mise à jour des données occtax

```sql
select id_dataset, id_nomenclature_diffusion_level, count(*) from gn_synthese.synthese where id_source = 8
group by id_dataset, id_nomenclature_diffusion_level;

update gn_synthese.synthese set id_nomenclature_diffusion_level = ref_nomenclatures.get_id_nomenclature('NIV_PRECIS', '5') where id_source = 8 and id_nomenclature_diffusion_level is null;
```

## Floutage

Les observations ont un attribut de floutage id_nomenclature_blurring de type DEE_FLOU  
Localement, il vaut NON ou n'est pas défini.  
Certains utilisateurs occtax le définissent, d'autres pas.
