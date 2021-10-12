-- Ongulés (détail espèces)
-- non listées : les observations de sous espèces ou genre ou ordre
-- voir id_statut pour filtrer les espèces sauvages/domestiques
WITH t AS (
  SELECT
    cd_ref,
    count(*)
  FROM
    gn_synthese.synthese
    JOIN taxonomie.taxref USING (cd_nom)
  WHERE
    ordre IN ('Cetartiodactyla', 'Perissodactyla')
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
  AND id_statut = 'P'
ORDER BY
  "nombre d'observations" DESC;
