# Utilisateurs

```sql
create schema f_utilisateurs;

import foreign schema utilisateurs from server srv_geonature into f_utilisateurs;

-- grant temporaire sur le schema utilisateurs du serveur geonature. Commandes à exécuter dans la base ancienne geonature.
-- grant usage on schema utilisateurs to "data.mercantour-parcnational.fr";
-- GRANT SELECT ON all TABLEs in schema utilisateurs TO "data.mercantour-parcnational.fr";

select * from f_utilisateurs.bib_organismes bo ;

insert into utilisateurs.bib_organismes(uuid_organisme, nom_organisme, adresse_organisme, cp_organisme, ville_organisme, tel_organisme, fax_organisme,email_organisme, url_organisme)
select uuid_organisme, nom_organisme, adresse_organisme, cp_organisme, ville_organisme, tel_organisme, fax_organisme,email_organisme, url_organisme from f_utilisateurs.bib_organismes;

-- + suppression des doublons (PNM, ALL, other)

select * from f_utilisateurs.t_roles;

select groupe, uuid_role, identifiant , nom_role , prenom_role , desc_role , pass, pass_plus , email , id_organisme , remarques , pn, active, date_insert , date_update  from f_utilisateurs.t_roles;

create table f_utilisateurs.org as
select ancien.id_organisme ancien_id, nouveau.id_organisme nouveau_id, ancien.uuid_organisme from f_utilisateurs.bib_organismes ancien join utilisateurs.bib_organismes nouveau using (nom_organisme);
create unique index on f_utilisateurs.org(ancien_id);
-- ajouter la correspondance 1 - 1 (problème de majuscule dans le nom)
-- fix
update utilisateurs.t_roles nouveau
set id_organisme = 1 from f_utilisateurs.t_roles ancien where nouveau.uuid_role = ancien.uuid_role and ancien.id_organisme = 1;

select id_organisme, count(*) from f_utilisateurs.t_roles group by id_organisme ;

alter table utilisateurs.t_roles disable trigger user;

insert into utilisateurs.t_roles (groupe, uuid_role, identifiant , nom_role , prenom_role , desc_role , pass, pass_plus , email , id_organisme , remarques ,  active, date_insert , date_update)
select groupe, uuid_role, identifiant , nom_role , prenom_role , desc_role , pass, pass_plus , email , org.nouveau_id as id_organisme , remarques ,  active, date_insert , date_update  from f_utilisateurs.t_roles left join f_utilisateurs.org on t_roles.id_organisme = org.ancien_id;

alter table utilisateurs.t_roles enable trigger user;
```
