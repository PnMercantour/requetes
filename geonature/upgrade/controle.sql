-- organismes non reportés dans la nouvelle base.
select fbo.*
from f_utilisateurs.bib_organismes fbo
    left join utilisateurs.bib_organismes bo using (uuid_organisme)
where bo.uuid_organisme is null;
-- utilisateurs non reportés dans la nouvelle base.
select ftr.*
from f_utilisateurs.t_roles ftr
    left join utilisateurs.t_roles tr using (uuid_role)
where tr.uuid_role is null;
--
-- gn_meta
--
select * from f_gn_meta.t_acquisition_frameworks ftaf left join gn_meta.t_acquisition_frameworks taf using (unique_acquisition_framework_id)
where taf.unique_acquisition_framework_id is null;
--
select * from f_gn_meta.t_datasets ftd  left join gn_meta.t_datasets td using (unique_dataset_id);
where td.unique_dataset_id is null;
--
-- TODO: contrôler les valeurs et les tables secondaires (acteurs, etc)
-- relevés non reportés.
select ftro.*
from f_pr_occtax.t_releves_occtax ftro
    left join pr_occtax.t_releves_occtax tro using (unique_id_sinp_grp)
where tro.unique_id_sinp_grp is null;
-- différences sur la table cor_role_releves_occtax
with releves as (
    select ftro.id_releve_occtax fid,
        tro.id_releve_occtax id
    from f_pr_occtax.t_releves_occtax ftro
        left join pr_occtax.t_releves_occtax tro -- les relevés absents de l'ancienne base sont ignorés
        using(unique_id_sinp_grp)
),
roles as (
    select f_t_roles.id_role fid,
        t_roles.id_role id
    from f_utilisateurs.t_roles f_t_roles
        left join utilisateurs.t_roles -- les roles absents de l'ancienne base sont ignorés
        using (uuid_role)
),
crro as (
    select c.*
    from pr_occtax.cor_role_releves_occtax c
        join roles on c.id_role = roles.id
        join releves on c.id_releve_occtax = releves.id
) -- On ne retient que les correspondances sur les relevés et roles existants dans l'ancienne base
select fcrro.*,
    crro.*
from f_pr_occtax.cor_role_releves_occtax fcrro
    join releves on fcrro.id_releve_occtax = releves.fid
    join roles on fcrro.id_role = roles.fid
    full outer join crro on (
        releves.id = crro.id_releve_occtax
        and roles.id = crro.id_role
    )
where fcrro.unique_id_cor_role_releve is null
    or crro.unique_id_cor_role_releve is null;
-- défaut de correpondance des occurrences (seulement pour les relevés importés)
-- on devrait également regarder si les occurrences ont été modifiées.
with releves as (
    select ftro.id_releve_occtax fid,
        tro.id_releve_occtax id
    from f_pr_occtax.t_releves_occtax ftro
        join pr_occtax.t_releves_occtax tro -- les relevés non importés sont ignorés
        using(unique_id_sinp_grp)
),
ftoo as (
    select o.*
    from f_pr_occtax.t_occurrences_occtax o
        join releves on (o.id_releve_occtax = releves.fid)
),
too as (
    select o.*
    from pr_occtax.t_occurrences_occtax o
        join releves on (o.id_releve_occtax = releves.id)
)
select *
from ftoo
    full outer join too using(unique_id_occurence_occtax)
where ftoo.unique_id_occurence_occtax is null
    or too.unique_id_occurence_occtax is null;
-- défaut de correspondance comptages
with occurrences as (
    select ftoo.id_occurrence_occtax fid,
        too.id_occurrence_occtax id
    from f_pr_occtax.t_occurrences_occtax ftoo
        join pr_occtax.t_occurrences_occtax too -- les occurrences non importées sont ignorées
        using (unique_id_occurence_occtax)
),
fcco as (
    select c.*
    from f_pr_occtax.cor_counting_occtax c
        join occurrences on id_occurrence_occtax = occurrences.fid
),
cco as (
    select c.*
    from pr_occtax.cor_counting_occtax c
        join occurrences on id_occurrence_occtax = occurrences.id
)
select fcco.*,
    cco.*
from fcco
    full outer join cco using(unique_id_sinp_occtax)
where fcco.unique_id_sinp_occtax is null
    or cco.unique_id_sinp_occtax is null;