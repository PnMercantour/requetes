ALTER TABLE gn_synthese.synthese
  ADD centroid_2154 geometry(point, 2154) NULL;

COMMENT ON COLUMN gn_synthese.synthese.centroid_2154 IS 'Pour les clients QGIS (custom PNM)';

CREATE OR REPLACE FUNCTION gn_synthese.fct_tri_update_centroid_2154 ()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $function$
BEGIN
  NEW.centroid_2154 = st_snaptogrid(st_centroid (NEW.the_geom_local), 1);
  RETURN new;
END;
$function$;

ALTER FUNCTION gn_synthese.fct_tri_update_centroid_2154 () OWNER TO geonatadmin;

CREATE TRIGGER tri_update_synthese_centroid_2154
  BEFORE INSERT OR UPDATE OF the_geom_local ON gn_synthese.synthese
  FOR EACH ROW
  EXECUTE PROCEDURE gn_synthese.fct_tri_update_centroid_2154 ();

UPDATE
  gn_synthese.synthese
  -- Très lent, à cause des multiples triggers et constraints sur la table synthese ... mais on ne le fait qu'une fois.
SET
  centroid_2154 = st_centroid (the_geom_local)
WHERE
  centroid_2154 IS NULL;

CREATE INDEX i_synthese_centroid_2154 ON gn_synthese.synthese USING gist (centroid_2154);
