-- recalcul du cache pour une area donnée, ici 5139
-- au préalable, mettre à jour cor_area_synthese
--
-- on efface les lignes relatives à l'area
delete from gn_synthese.cor_area_taxon
where id_area = 5139;
-- on recrée ces lignes à partir de la table cor_area_synthese à jour
insert into gn_synthese.cor_area_taxon(cd_nom, id_area, nb_obs, last_date)
select cd_nom,
    id_area,
    count(*) nb_obs,
    max(date_min) last_date
from gn_synthese.cor_area_synthese cas
    join gn_synthese.synthese using (id_synthese)
where id_area = 5139
group by cd_nom,
    id_area;