CREATE MATERIALIZED VIEW taxonomie.vm_plantae_pp AS
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
)
SELECT
    taxref.cd_nom,
    COALESCE(patrimoniale.cd_ref IS NOT NULL, FALSE) AS patrimoniale,
    COALESCE(protegee.cd_ref IS NOT NULL, FALSE) AS protegee
FROM
    patrimoniale
    FULL JOIN protegee USING (cd_ref)
    JOIN taxonomie.taxref USING (cd_ref)
WHERE
    taxref.regne::text = 'Plantae'::text WITH DATA;

-- View indexes:
CREATE UNIQUE INDEX vm_plantae_pp_cd_nom_idx ON taxonomie.vm_plantae_pp USING btree (cd_nom);

