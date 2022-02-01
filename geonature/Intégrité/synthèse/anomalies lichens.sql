-- Bauvet, Bertrand, Bricaud et Roux. des lichens enregistrés avec un mauvais cd_nom
-- Principalement la semaine 21-26/07/2013, mais pas que.
CREATE TABLE tmp.fix_lichens AS SELECT DISTINCT
  cd_nom,
  cd_ref,
  nom_cite,
  nom_complet
FROM
  gn_synthese.synthese
  JOIN taxonomie.taxref USING (cd_nom)
WHERE (observers ILIKE '%bricaud%'
  OR observers ILIKE '%bauvet%'
  OR observers ILIKE '%bertrand%'
  OR observers ILIKE '%roux%')
AND position(substring(nom_cite, 1, 5) IN nom_complet) = 0
AND (nom_vern IS NULL
  OR position(substring(nom_cite, 1, 5) IN nom_vern) = 0)
ORDER BY
  cd_nom;

-- Création de la colonne nouveau_cd_nom, remplie à la main (-1 si pas de changement)
-- Contrôle du résultat. Le nom complet vaut NULL si le taxon n'est pas connu (taxref à mettre à jour)
SELECT
  nom_cite,
  taxref.nom_complet nouveau_nom_complet
FROM
  tmp.fix_lichens fl
  LEFT JOIN taxonomie.taxref taxref ON (nouveau_cd_nom = taxref.cd_nom)
WHERE
  nouveau_cd_nom != - 1;

-- Observations à corriger (changer le cd_nom, attention aux cd_noms inconnus!):
SELECT
  s.*
FROM
  gn_synthese.synthese s
  JOIN tmp.fix_lichens fl USING (cd_nom, nom_cite)
WHERE
  nouveau_cd_nom != - 1;

-- backup avant modification
CREATE TABLE tmp.backup_lichens AS
SELECT
  s.*
FROM
  gn_synthese.synthese s
  JOIN tmp.fix_lichens fl USING (cd_nom, nom_cite)
WHERE
  nouveau_cd_nom != - 1;

-- mise à jour (pour les taxons connus)
UPDATE
  gn_synthese.synthese
SET
  cd_nom = nouveau_cd_nom
FROM
  tmp.fix_lichens
  JOIN taxonomie.taxref taxref ON (nouveau_cd_nom = taxref.cd_nom)
WHERE
  fix_lichens.cd_nom = synthese.cd_nom
  AND fix_lichens.nom_cite = synthese.nom_cite;

-- mise à jour pour les taxons qui ne sont pas encore dans la base (GENRE ou FAMILLE)
UPDATE
  gn_synthese.synthese
SET
  cd_nom = 198862
WHERE
  nom_cite = 'Varicellaria lactea';

UPDATE
  gn_synthese.synthese
SET
  cd_nom = 443240
WHERE
  nom_cite LIKE 'Lathagrium %'
  OR nom_cite LIKE 'Scytinium %';

-- Détection d'observations de lichens mal typées (exemple Caloplaca)
-- Saisir le nom du lichen et lister les observations qui ne sont pas dans le bon groupe inpn.
SELECT
  *
FROM
  gn_synthese.synthese s
  JOIN taxonomie.taxref USING (cd_nom)
WHERE
  nom_cite LIKE 'Caloplaca%'
  AND group2_inpn != 'Lichens';

--> remplacement du cd_nom par 58889 (Parmelia sulcata Taylor s.l.)
UPDATE
  gn_synthese.synthese
SET
  cd_nom = 58889
WHERE
  cd_nom = 2496;

--> remplacement du cd_nom par 55032 (Verrucaria nigrescens Pers., 1795)
UPDATE
  gn_synthese.synthese
SET
  cd_nom = 55032
WHERE
  cd_nom = 4097;

-- cd_nom 2763, Bauvet/Bricaud, nom_cite = Physcia aipolia (659151)
UPDATE
  gn_synthese.synthese
SET
  cd_nom = 659151
WHERE
  cd_nom = 2763;

-- cd_nom 3255, Bertrand/Roux, nom_cite = Rhizocarpon effiguratum (57527)
UPDATE
  gn_synthese.synthese
SET
  cd_nom = 57527
WHERE
  cd_nom = 3255;

UPDATE
  gn_synthese.synthese
SET
  cd_nom = 56856
WHERE
  cd_nom = 1873
  AND nom_cite LIKE 'Lecidella elaeochroma%';

UPDATE
  gn_synthese.synthese
SET
  cd_nom = 58321
WHERE
  cd_nom = 2549
  AND nom_cite LIKE 'Pertusaria albescens%';

cd_ref 1665 cd_ref 199318 cd_ref 1872 233899 1062 950 814245: cd_nom 2536 (Peltigera venosa) 1612 234163
/*
713 713 -> 660702 (Caloplaca polycarpa)
723  723   -> 59337 (Caloplaca variabilis f. paepalostoma)
905
922 cd_nom 922 -> 57660 (Cladonia ciliata)
953
982 cd_nom 982 -> 57701 (Cladonia rangiformis var. pungens)
1005  1007 -> 653231 (Clauzadea immersa)
1009 1009 -> 653233 (Clauzadea Monticola)
1027 cd_nom 1027 -> 954276 (Lathagrium auriforme)
1031
1062 1062 -> Enchylium tenax var.tenax Utiliser 844925 (Enchylium) car pas de taxon tenax (954259)
1065 -> 913237 Lathagrium undulatum (pas trouvé)
1216 -> 664309 Diplochistes albescens
1220 -> 55951 Diploschistes scruposus scruposus
1604 -> 660643 Lecanora rupicola var. bicincta
1612 -> 58522 Lecanora cenisia var. atrynea
1645 cd_nom 1645 -> 954285 (Lecanora expallens var. expallens)
1659 -> 660730 Lecanora hagenii morpho hagenii
1665 -> 659640  Lecanora intricata
1680 -> Lecanora marginata chémo. marginata
1687 -> Lecanora muralis subsp. muralis var subcartilaginea
1688
1729 -> Lecanora stenotropa morpho. grandes apothécies
1747 cd_nom 1747 -> 659596 (Lecanora varia)
1872 -> Lecidella ccarpathica chémo. carpathica
1884 -> Lecidella stigmatea chémomorpho. micacea
1955
1966 -> Scytinium pulvinatum
1972 1970 -> Scytinium plicatile

2411 cd_nom 951 -> 660601 (Cladonia furcata subsp. subrangiformis)
2486 -> Montanelia sorediata
2591 cd_nom 2593 -> 955037 (Varicellaria lactea)
2775 -> Physcia dubia morpho. dubia
2901 -> Polyblastia fuscoargillacea morpho. fuscoargillacea
3192
3199 cd_nom 3202 -> 658980 (Ramalina pollinaria)
3352 -> Rinodina immersa
3601 -> Staurothele orbicularis
3611 3618 -> Aspicilia contorta subsp. hoffmanniana morpho. hoffmanniana
3926 cd_nom 3926 -> 658460 (Umbilicaria cylindrica)
3953 -> Umbilicaria vellea
4023 -> Verrucaria hochstetteri subsp. hochstetteri var. obtecta
4064 4066 -> Verrucaria hochstetteri subsp. hochstetteri var. hochstetteri
4198 -> Polyblastia fuscoargillacea morpho. cinerea
5225 -> Carbonea intrudens
5302 -> Endococcus macrosporus
5395 -> Toninia opuntioides
5980 -> Dimelaena oreina chémo. 4
6136 -> Catillaria chalybeia éco. calcarea
6145 -> Lecanora agardhiana subsp. sapaudica var. lecidella
6167 -> Physcia dubia morpho. teretiuscula
6261 -> Lobothallia radiosa chémo. subcircinata
6383 -> Myriospora tangerina
13608 -> 13668 (polydrusus manteroi)
55463 -> Leptorhaphis parameca (A. Massal.) Körb.
56982 -> Farnoldia micropsis V. micropsis
199318 1035 -> Lathagrium cristatum var.cristatum
221374  cdnom 2313 -> 58344 (Ochrolechia turneri)
233226 888 -> Caloplaca lactea éco. orophile
233271 1150 -> Dermatocarpon complicatum
233284 1154 -> Dermatocarpon miniatum var. miniatum morpho. imbricatum
233347 cdnom 1215 -> 55928 (Diploschistes ocellatus)
233761 1499 -> Ionaspis odora
233899 1718 -> Lecanora rupicola subsp. rupicola morpho. rupicola
233902 1719 -> Lecanora rupicola subsp. subplanata
233969 944 -> Cladonia foliacea subsp. endiviifolia
242563 -> 252563 (Lachnaia italica italica) ou 241281 (Lachnaia italica)

364251 cdnom 3326 -> 658929 (Rinodina archaea)
434442 5858 -> Placopyrenium canellum morpho. petites spores
444440 318 -> Aspicilia prestensis chémo. prestensis
444440 320 -> Lobothallia farinosa chémo. farinosa
458769 1614 -> Lzcanora cenisia morpho. melacarpa
786463 5123 -> Squamarina cartilaginea chémo. pseudocrassa
806888 1461 -> Hymenelia similis

836223  cdnom 1962 -> 954984 (Scytinium gelatinosum)

827204 -> 837204 (Podisma dechambrei)
189083 -> 189082 (Amphinemura ris)
 */
