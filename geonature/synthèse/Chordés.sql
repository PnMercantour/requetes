-- identification des espèces (incohérence possible au niveau cd_nom): cd_nom -> cd_ref puis filtrage id_rang = 'ES'
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
    group1_inpn = 'Chordés'
  GROUP BY
    cd_ref
)
SELECT
  *
FROM
  t
  JOIN taxonomie.taxref tr USING (cd_nom)
WHERE
  id_rang = 'ES'
ORDER BY
  "nbre obs" DESC;
