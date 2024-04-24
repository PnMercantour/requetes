-- gn_meta.pnm_acquisition_frameworks source
CREATE OR REPLACE VIEW gn_meta.pnm_acquisition_frameworks AS
SELECT DISTINCT ON (taf.id_acquisition_framework) taf.id_acquisition_framework,
    taf.unique_acquisition_framework_id,
    taf.acquisition_framework_name,
    taf.acquisition_framework_desc,
    taf.id_nomenclature_territorial_level,
    taf.territory_desc,
    taf.keywords,
    taf.id_nomenclature_financing_type,
    taf.target_description,
    taf.ecologic_or_geologic_target,
    taf.acquisition_framework_parent_id,
    taf.is_parent,
    taf.acquisition_framework_start_date,
    taf.acquisition_framework_end_date,
    taf.meta_create_date,
    taf.meta_update_date,
    taf.id_digitizer
FROM gn_meta.t_acquisition_frameworks taf
    JOIN gn_meta.pnm_datasets pd USING (id_acquisition_framework);
COMMENT ON VIEW gn_meta.pnm_acquisition_frameworks IS 'Cadres d''acquisition PNM';
-- Permissions
ALTER TABLE gn_meta.pnm_acquisition_frameworks OWNER TO postgres;
GRANT ALL ON TABLE gn_meta.pnm_acquisition_frameworks TO postgres;
GRANT SELECT ON TABLE gn_meta.pnm_acquisition_frameworks TO public;