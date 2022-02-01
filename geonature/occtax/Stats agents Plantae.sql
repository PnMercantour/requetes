WITH params AS (
  SELECT
    bib_organismes.id_organisme,
    t_modules.id_module
  FROM
    gn_commons.t_modules,
    utilisateurs.bib_organismes
  WHERE
    module_code = 'OCCTAX'
    AND bib_organismes.nom_organisme = 'Parc National du Mercantour'
),
users AS (
  SELECT
    id_role,
    nom_role,
    prenom_role,
    ccau.id_unite,
    from_date,
    to_date
  FROM
    utilisateurs.t_roles
    JOIN params USING (id_organisme)
    LEFT JOIN utilisateurs.custom_cor_agent_unite ccau USING (id_role)
),
obs AS (
  SELECT
    id_synthese,
    cd_nom,
    extract(year FROM date_min) annee,
  id_role,
  users.nom_role,
  users.prenom_role,
  users.id_unite
FROM
  gn_synthese.synthese
  JOIN gn_commons.t_modules USING (id_module)
  JOIN gn_synthese.cor_observer_synthese USING (id_synthese)
  JOIN users USING (id_role)
  WHERE
    extract(year FROM date_min) IN (2019, 2020, 2021)
    AND (users.from_date IS NULL
      OR users.from_date <= date_min)
    AND (users.to_date IS NULL
      OR users.to_date >= date_min))
SELECT
  nom_unite,
  concat_ws(' ', nom_role, prenom_role) agent,
  count(*) observations
FROM
  obs
  JOIN taxonomie.taxref USING (cd_nom)
  JOIN utilisateurs.bib_unites USING (id_unite)
WHERE
  regne = 'Plantae'
GROUP BY
  nom_unite,
  agent
ORDER BY
  nom_unite,
  observations DESC;
