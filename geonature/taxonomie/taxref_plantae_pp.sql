-- extrait du taxref pour les espèces de Flore (avec patrimonialité et protection)
SELECT
    patrimoniale,
    protegee,
    taxref.*
FROM
    taxonomie.vm_plantae_pp
    JOIN taxonomie.taxref USING (cd_nom);

