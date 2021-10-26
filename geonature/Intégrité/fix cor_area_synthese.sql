-- Pour corriger la table de correspondance cor_area_synthese, ici pour area 5145
INSERT INTO gn_synthese.cor_area_synthese (id_synthese, id_area)
SELECT
  s.id_synthese,
  la.id_area
FROM
  gn_synthese.synthese s,
  ref_geo.l_areas la
WHERE
  --s.id_nomenclature_info_geo_type = 126 and
  la.id_area = 5145
  AND st_intersects (s.the_geom_local, la.geom)
  AND NOT st_touches (s.the_geom_local, la.geom)
ON CONFLICT
  DO NOTHING
