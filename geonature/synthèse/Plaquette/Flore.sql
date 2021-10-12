-- flore (synthèse)
WITH t AS (
  SELECT
    cd_ref,
    count(*)
  FROM
    gn_synthese.synthese
    JOIN taxonomie.taxref USING (cd_nom)
  WHERE
    regne = 'Plantae'
  GROUP BY
    cd_ref
)
SELECT
  group2_inpn,
  count(*) "nombre d'espèces"
FROM
  t
  JOIN taxonomie.taxref ON (t.cd_ref = taxref.cd_nom)
WHERE
  id_rang IN ('ES', 'SSES')
  AND id_statut = 'P'
GROUP BY
  group2_inpn
ORDER BY
  group2_inpn;
