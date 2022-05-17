-- observations dont le statut est 'Présent'
select * from gn_synthese.synthese s
where s.id_nomenclature_observation_status = ref_nomenclatures.get_id_nomenclature('STATUT_OBS', 'Pr');