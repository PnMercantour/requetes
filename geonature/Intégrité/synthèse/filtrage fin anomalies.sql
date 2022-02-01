WITH l1 AS (
  SELECT
    cd_ref,
    count(*) bad
  FROM
    gn_synthese.synthese s
    JOIN taxonomie.taxref USING (cd_nom)
  WHERE
    position(nom_cite IN nom_complet) = 0
  GROUP BY
    cd_ref
),
l2 AS (
  SELECT
    cd_ref,
    count(*) good
  FROM
    gn_synthese.synthese s
    JOIN taxonomie.taxref USING (cd_nom)
  WHERE
    position(nom_cite IN nom_complet) = 1
  GROUP BY
    cd_ref
),
l3 as (select cd_ref from
  l1 left 
  JOIN l2
  USING (cd_ref)
  where good is null and bad < 6)
  select cd_ref, cd_nom, nom_cite, nom_complet, * from gn_synthese.synthese s2 join taxonomie.taxref using(cd_nom) join l3 using (cd_ref)
order by cd_ref, id_synthese 