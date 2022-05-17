-- taxons présents (cd_nom) avec le nombre d'observations, la date de première et de dernière observation sur le territoire (dans la base de données)
select cd_nom, count(*) "nombre", min(date_min) "premiere_obs", max(date_max) "derniere_obs" from gn_synthese.synthese
where synthese.id_nomenclature_observation_status = ref_nomenclatures.get_id_nomenclature('STATUT_OBS', 'Pr')
group by cd_nom
order by "derniere_obs" desc;