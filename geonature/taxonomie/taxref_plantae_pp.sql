-- extrait du taxref pour les espèces de Flore (avec patrimonialité et protection)
SELECT
  patrimoniale,
  protegee,
  taxref.*
FROM
  taxonomie.taxref
  JOIN taxonomie.vm_plantae_pp USING (cd_nom);
