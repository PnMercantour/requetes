with taxon_pat as (select * from taxonomie.v_taxref_pp 
                   where patrimoniale and cd_nom=cd_ref),
obs as (select distinct cd_ref from gn_synthese.synthese 
        join taxonomie.taxref using(cd_nom))
select taxon_pat.* 
from taxon_pat 
join obs using (cd_ref); 
