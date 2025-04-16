ajouter les taxons remplaçant les taxons disparus aux taxons ouverts à la saisie

contrôler que seuls les cd_ref sont ouverts à la saisie

ouvrir les nouveaux taxons à la saisie

mettre au carré le fichier de configuration occtax mobile (maps)

contrôler la mise à jour incrémentale d'occtax

importer la synthese (régénérer les enregistrements à partir d'occtax)

ajouter le module d'import

importer les imports de geonature 2.5

Les modules connaissent la synthèse.
La synthese ne connait pas les modules (seulement par des tables qui décrivent les modules)

table de correspondance role synthese : doublon de la table de correspondance role relevé (multiplié par les occurrences\*comptages du relevé)

L'information est là, sans cette table.

pour un id_synthese donné, retrouver cor_count_occtax, puis occurrence_occtax puis relevé occtax.
créer une vue qui donne le résultat pr_occtax.cor_role_synthese
ou une fonction (qui prend l'id_synthese ou l'uuid en argument)

essayer de la créer plutôt comme une vue qui réalise l'union des tables correspondantes dans les modules (en faisant l'hypothèse que d'autres modules que occtax produisent des observations).

Chaque table de correspondance (dans chaque module) pourrait intégrer la colonne id_synthese (puisqu'on n'utilise pas l'uuid comme index).
La table de correspondance releve role a un uuid qui ne sert à rien.

dynamic statement pour construire la requête à partir d'une table de modules
https://www.postgresql.org/docs/current/plpgsql-statements.html#PLPGSQL-STATEMENTS-EXECUTING-DYN

return next et return query
https://www.postgresql.org/docs/current/plpgsql-control-structures.html

Cela ne dispense pas de définir des triggers lorsque la table source est modifiée :
-insert, update, delete : recalcul de l'attribut observers de la synthese.

- après une liste d'inserts ou de update : construire la liste unique des NEW.id_synthese, recalculer observers pour ces id_synthese
- après une liste de delete : construire la liste unique des OLD.id_synthese, recalculer observers pour ces id_synthese.

Remarque : si l'attribut observers de la synthese a été surchargé, il est écrasé (l'interface utilisateur ne permet pas d'éditer la synthese, donc en principe pas de problème)
