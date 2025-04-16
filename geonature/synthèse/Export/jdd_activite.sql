-- jeux de données pnm ordonnés par la dernière date de saisie d'observation
select id_dataset,
    min (s.meta_create_date) from_date,
    max(s.meta_create_date) to_date,
    max(s.meta_update_date) updated
from gn_meta.pnm_datasets
    join gn_synthese.synthese s using (id_dataset)
group by id_dataset;