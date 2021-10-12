-- Abeilles par famille
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
    ordre = 'Hymenoptera'
    AND famille IN ('Halictidae', 'Apidae', 'Megachilidae', 'Andrenidae', 'Colletidae', 'Melittidae')
  GROUP BY
    cd_ref
)
SELECT
  famille,
  count(*)
FROM
  t
  JOIN taxonomie.taxref ON (t.cd_ref = taxref.cd_nom)
WHERE
  id_statut = 'P'
  AND id_rang = 'ES'
GROUP BY
  famille
ORDER BY
  count DESC;
