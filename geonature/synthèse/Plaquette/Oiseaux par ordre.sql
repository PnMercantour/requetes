-- Oiseaux par ordre
SELECT
  ordre "Ordre",
  count(DISTINCT cd_ref) "Nombre d'espèces"
FROM
  gn_synthese.synthese
  JOIN taxonomie.taxref USING (cd_nom)
WHERE
  classe = 'Aves'
  AND id_statut = 'P'
  AND id_rang = 'ES'
GROUP BY
  ordre
ORDER BY
  "Nombre d'espèces" DESC;
