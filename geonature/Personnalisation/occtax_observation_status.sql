CREATE OR REPLACE FUNCTION pr_occtax.fct_tri_patch_observation_status ()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $function$
BEGIN
  if  NEW.id_nomenclature_observation_status is NULL then
    NEW.id_nomenclature_observation_status = gn_synthese.get_default_nomenclature_value('STATUT_OBS'::character varying);
    end if;
  RETURN NEW;
END;
$function$;

ALTER FUNCTION pr_occtax.fct_tri_patch_observation_status () OWNER TO geonatadmin;

CREATE TRIGGER tri_patch_observation_status
  BEFORE INSERT OR UPDATE OF id_nomenclature_observation_status ON pr_occtax.t_occurrences_occtax
  FOR EACH ROW
  EXECUTE PROCEDURE pr_occtax.fct_tri_patch_observation_status ();

UPDATE
  pr_occtax.t_occurrences_occtax
  -- Très lent, à cause des multiples triggers et constraints sur la table synthese qui est également mise à jour ... mais on ne le fait qu'une fois.
SET
  id_nomenclature_observation_status = gn_synthese.get_default_nomenclature_value('STATUT_OBS'::character varying)
WHERE
  id_nomenclature_observation_status IS NULL;
