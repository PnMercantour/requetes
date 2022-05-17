-- taxons présents (cd_ref)) avec le nombre d'observations, la date de première et de dernière observation sur le territoire (dans la base de données)
select cd_ref, count(*) "nombre_obs", min(date_min) "premiere_obs", max(date_max) "derniere_obs" from gn_synthese.synthese join taxonomie.taxref using (cd_nom)
where synthese.id_nomenclature_observation_status = ref_nomenclatures.get_id_nomenclature('STATUT_OBS', 'Pr')
group by cd_ref
order by "derniere_obs" desc;