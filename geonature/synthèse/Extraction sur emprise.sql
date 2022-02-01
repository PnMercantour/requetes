-- Extraction d'espèces patrimoniales ou protégées
WITH patrimoniale AS (
  SELECT
    cor_taxon_attribut.cd_ref
  FROM
    taxonomie.cor_taxon_attribut
  WHERE
    cor_taxon_attribut.id_attribut = 1
    AND cor_taxon_attribut.valeur_attribut = 'oui'::text
),
protegee AS (
  SELECT
    cor_taxon_attribut.cd_ref
  FROM
    taxonomie.cor_taxon_attribut
  WHERE
    cor_taxon_attribut.id_attribut = 2
    AND cor_taxon_attribut.valeur_attribut = 'oui'::text
),
taxref AS (
  SELECT
    taxref.*,
    COALESCE(patrimoniale.cd_ref IS NOT NULL, FALSE) AS patrimoniale,
    COALESCE(protegee.cd_ref IS NOT NULL, FALSE) AS protegee
FROM
  patrimoniale
  FULL JOIN protegee USING (cd_ref)
  JOIN taxonomie.taxref USING (cd_ref))
SELECT
  s.*,
  taxref.*
FROM
  gn_synthese.synthese s
  JOIN gn_synthese.cor_area_synthese cas ON (s.id_synthese = cas.id_synthese)
  JOIN taxref USING (cd_nom)
WHERE
  cas.id_area = 5145
