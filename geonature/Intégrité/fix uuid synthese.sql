-- Il arrive que des observations soient importées sans qu'un uuid soit attribué 
-- source de données partenaires -> ne pas attribuer d'uuid
-- mauvais paramétrage de l'import de données nouvelles -> attribuer un uuid
-- voici comment identifier les sources concernées
with sources as (
    select distinct id_source
    from gn_synthese.synthese
    where unique_id_sinp is null
)
select id_source,
    count(*) filter (
        where unique_id_sinp is null
    ) "without uuid",
    count(*) filter (
        where unique_id_sinp is not null
    ) "with uuid"
from gn_synthese.synthese
    join sources using (id_source)
group by id_source
order by id_source;
-- exemple de mise à jour pour la source 242;
update gn_synthese.synthese
set unique_id_sinp = uuid_generate_v4()
where id_source = 242;