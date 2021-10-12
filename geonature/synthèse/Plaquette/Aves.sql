-- Aves, avec nombre d'observation par espèce
WITH t AS (
  SELECT
    cd_ref cd_nom,
    count(*) "nbre obs",
    min(date_min) "première obs",
    max(date_max) "dernière obs"
  FROM
    gn_synthese.synthese
    JOIN taxonomie.taxref USING (cd_nom)
  WHERE
    classe = 'Aves'
    AND id_statut = 'P'
    AND id_rang = 'ES'
  GROUP BY
    cd_ref
)
SELECT
  *
FROM
  t
  JOIN taxonomie.taxref tr USING (cd_nom)
ORDER BY
  "nbre obs" DESC;
