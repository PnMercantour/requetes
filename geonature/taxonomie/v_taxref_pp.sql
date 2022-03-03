CREATE OR REPLACE VIEW taxonomie.v_taxref_pp AS
WITH patrimoniale AS (
  SELECT
    cor_taxon_attribut.cd_ref
  FROM
    taxonomie.cor_taxon_attribut
    JOIN taxonomie.bib_attributs ba USING (id_attribut)
  WHERE
    ba.nom_attribut::text = 'patrimonial'::text
    AND cor_taxon_attribut.valeur_attribut = 'oui'::text
),
protegee AS (
  SELECT
    cor_taxon_attribut.cd_ref
  FROM
    taxonomie.cor_taxon_attribut
    JOIN taxonomie.bib_attributs ba USING (id_attribut)
  WHERE
    ba.nom_attribut::text = 'protection_stricte'::text
    AND cor_taxon_attribut.valeur_attribut = 'oui'::text
)
SELECT
  COALESCE(patrimoniale.cd_ref IS NOT NULL, FALSE) AS patrimoniale,
  COALESCE(protegee.cd_ref IS NOT NULL, FALSE) AS protegee,
  taxref.*
FROM
  patrimoniale
  FULL JOIN protegee USING (cd_ref)
  JOIN taxonomie.taxref USING (cd_ref);
