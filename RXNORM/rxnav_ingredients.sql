SELECT DISTINCT
  1 AS level_number,
  'Ingredient' AS term_type_level,
  rxn.rxcui,
  rxn.tty,
  rxn.str AS name,
  rel.rela,
  rel.rxcui1,
  rxn2.str AS relation_name,
  rxn2.tty AS relation_tty
FROM
  rxnconso rxn
  JOIN rxnrel rel ON rxn.rxcui = rxcui2
  JOIN rxnconso rxn2 ON rel.rxcui1 = rxn2.rxcui
WHERE
  rxn.sab = 'RXNORM'
  AND rel.rela = 'has_tradename'
  AND rxn2.sab = 'RXNORM'
  AND rxn.rxcui = '1991302'
UNION ALL
SELECT
  2 AS level_number,
  'Clinical Drug Component (SCDC)' AS term_type_level,
  rxn.rxcui,
  rxn.tty,
  rxn.str AS name,
  rel.rela,
  rel.rxcui1,
  rxn2.str AS relation_name,
  rxn2.tty AS relation_tty
FROM
  rxnconso rxn
  JOIN rxnrel rel ON rxn.rxcui = rxcui2
  JOIN rxnconso rxn2 ON rel.rxcui1 = rxn2.rxcui
WHERE
  rxn.sab = 'RXNORM'
  AND rel.rela = 'ingredient_of'
  AND rxn2.tty IN ('SCDC')
  AND rxn.rxcui = '1991302'
ORDER BY
  1,
  relation_name