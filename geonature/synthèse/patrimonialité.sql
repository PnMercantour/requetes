with taxon as (Select distinct
  cd_ref
FROM
  gn_synthese.synthese s
  JOIN taxonomie.taxref USING (cd_nom)
  LEFT JOIN (
    SELECT
      cta.cd_ref
    FROM
      taxonomie.cor_taxon_attribut cta
      JOIN taxonomie.bib_attributs ba USING (id_attribut)
    WHERE
      ba.nom_attribut::text = 'patrimonial'::text
      AND cta.valeur_attribut = 'oui'::text) patrimoniale USING (cd_ref)) 
select taxref.*, true as patrimonial from taxonomie.taxref
JOIN taxon on (taxref.cd_nom=taxon.cd_ref)
;