WITH params AS (
  SELECT
    ref_nomenclatures.get_id_nomenclature ('STATUT_OBS'::character varying,
      'Pr'::character varying) AS present,
    ref_nomenclatures.get_id_nomenclature ('TYP_INF_GEO'::character varying,
      '1'::character varying) AS georef
),
s AS (
  SELECT
    cd_nom,
    date_min::date
  FROM
    gn_synthese.synthese s
    JOIN tmp.parts ON (st_within (s.the_geom_local, parts.geom)),
    params
  WHERE
    s.id_nomenclature_observation_status = params.present
    AND s.id_nomenclature_info_geo_type = params.georef
  UNION
  SELECT
    cd_nom,
    date_min::date
  FROM
    gn_synthese.synthese s,
    params
  WHERE
    s.id_nomenclature_observation_status = params.present
    AND s.id_nomenclature_info_geo_type != params.georef
),
tous AS (
  SELECT
    cd_nom,
    min(s.date_min)
  FROM
    s
  GROUP BY
    cd_nom
),
recents AS (
  SELECT
    cd_nom,
    min(date_min)
  FROM
    s
  WHERE
    date_min >= '1900-01-01'
  GROUP BY
    cd_nom
)
SELECT
  cd_nom,
  tous.min premiere_observation,
  recents.min premiere_observation_depuis_1900
FROM
  tous
  LEFT JOIN recents USING (cd_nom)
ORDER BY
  premiere_observation_depuis_1900 DESC nulls LAST,
  premiere_observation DESC
