Copie d'un schéma depuis la base geonature vers la base bd_pnm

On utilise ces commandes pour dupliquer les schémas _stables_, par exemple la taxonomie ou la nomenclature.

Méthode en plusieurs étapes

Se connecter au serveur geonature, utilisateur postgres

    ssh geonature.mercantour-parcnational.fr -l postgres

Etape optionnelle : faire un dump au format _plain_ pour voir ce qui est sauvegardé

    pg_dump --format=plain -d geonature2db --file=ref_nomenclature.sql --schema=ref_nomenclatures --no-owner

Dump au format custom

    pg_dump --format=custom -d geonature2db --file=ref_nomenclature.dump --schema=ref_nomenclatures

Se connecter à la machine qui porte le serveur cible (bd_pnm sur data.mercantour-parcnational.fr)

    ssh data.mercantour-parcnational.fr -l postgres -A
    scp postgres@geonature.mercantour-parcnational.fr:ref_nomenclature.dump .
    pg_restore --dbname=bd_pnm --no-owner ref_nomenclature.dump

Méthode rapide

Configurer le client pour qu'il ait les droits nécessaires pour dumper le schéma sur la machine serveur .

    pgdump <OPTIONS>| pg_restore  --dbname=bd_pnm --no-owner

ou utiliser ssh

    ssh geonature -l postgres pg_dump --format=custom -d geonature2db  --schema=ref_nomenclatures |pg_restore -l

Donner l'accès en lecture pour tous (si les données sont publiques)

    psql -d bd_pnm
    grant usage on schema FOO to public;
    grant select on all tables in schema FOO to public;

Références

https://postgresql.org/docs/current/app-pgdump.html

https://postgresql.org/docs/current/app-pgrestore.html
