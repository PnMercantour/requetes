CREATE OR REPLACE VIEW gn_synthese.v_synthese_pp AS
SELECT
  vm.id_synthese,
  vm.geom,
  s.nom_cite,
  v_taxref_pp.nom_complet,
  v_taxref_pp.nom_valide,
  v_taxref_pp.patrimoniale,
  v_taxref_pp.protegee,
  v_taxref_pp.regne,
  v_taxref_pp.id_rang,
  v_taxref_pp.group1_inpn,
  v_taxref_pp.group2_inpn,
  s.observers,
  s.date_min,
  s.count_min,
  ref_nomenclatures.get_nomenclature_label (s.id_nomenclature_valid_status) AS validation_status,
  s.id_dataset
FROM
  gn_synthese.vm_synthese_pp vm
  JOIN gn_synthese.synthese s USING (id_synthese)
  JOIN taxonomie.v_taxref_pp USING (cd_nom);
