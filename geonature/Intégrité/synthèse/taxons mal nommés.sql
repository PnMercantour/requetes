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
)
SELECT
  *
FROM
  l1
  JOIN l2 USING (cd_ref);
