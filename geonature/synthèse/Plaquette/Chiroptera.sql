-- chiroptères (détail espèces)
-- non listées : les observations de sous espèces ou genre ou ordre
WITH t AS (
  SELECT
    cd_ref,
    count(*)
  FROM
    gn_synthese.synthese
    JOIN taxonomie.taxref USING (cd_nom)
  WHERE
    ordre = 'Chiroptera'
  GROUP BY
    cd_ref
)
SELECT
  count "nombre d'observations",
  taxref.*
FROM
  t
  JOIN taxonomie.taxref ON (t.cd_ref = taxref.cd_nom)
WHERE
  id_rang = 'ES'
ORDER BY
  "nombre d'observations" DESC;
