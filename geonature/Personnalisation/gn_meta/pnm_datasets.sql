-- gn_meta.pnm_datasets source
CREATE OR REPLACE VIEW gn_meta.pnm_datasets AS WITH pnm AS (
        SELECT bib_organismes.id_organisme AS id_organism
        FROM utilisateurs.bib_organismes
        WHERE bib_organismes.nom_organisme::text = 'Parc National du Mercantour'::text
    ),
    pnm_datasets AS (
        SELECT DISTINCT cda.id_dataset
        FROM gn_meta.cor_dataset_actor cda
            JOIN pnm USING (id_organism)
    )
SELECT t_datasets.id_dataset,
    t_datasets.unique_dataset_id,
    t_datasets.id_acquisition_framework,
    t_datasets.dataset_name,
    t_datasets.dataset_shortname,
    t_datasets.dataset_desc,
    t_datasets.id_nomenclature_data_type,
    t_datasets.keywords,
    t_datasets.marine_domain,
    t_datasets.terrestrial_domain,
    t_datasets.id_nomenclature_dataset_objectif,
    t_datasets.bbox_west,
    t_datasets.bbox_east,
    t_datasets.bbox_south,
    t_datasets.bbox_north,
    t_datasets.id_nomenclature_collecting_method,
    t_datasets.id_nomenclature_data_origin,
    t_datasets.id_nomenclature_source_status,
    t_datasets.id_nomenclature_resource_type,
    t_datasets.active,
    t_datasets.meta_create_date,
    t_datasets.meta_update_date,
    t_datasets.validable,
    t_datasets.id_digitizer
FROM gn_meta.t_datasets
    JOIN pnm_datasets USING (id_dataset);
COMMENT ON VIEW gn_meta.pnm_datasets IS 'jeux de données dont le PNM est acteur';
-- Permissions
ALTER TABLE gn_meta.pnm_datasets OWNER TO postgres;
GRANT ALL ON TABLE gn_meta.pnm_datasets TO postgres;
GRANT SELECT ON TABLE gn_meta.pnm_datasets TO public;