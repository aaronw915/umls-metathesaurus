select distinct
1 as level_number,
'Ingredient' as term_type_level,
    rxn.rxcui,
    rxn.tty,
    rxn.str as name,
    rel.rela,
    rel.rxcui1,
    rxn2.str as relation_name,
    rxn2.tty as relation_tty
from
    rxnconso rxn
    join rxnrel rel 
    on rxn.rxcui = rxcui2
    join rxnconso rxn2 on rel.rxcui1 = rxn2.rxcui
where
    rxn.sab = 'RXNORM'
    and rel.rela = 'has_tradename'
    and rxn2.sab = 'RXNORM'
    and rxn.rxcui = '1991302'
UNION ALL
select
2 as level_number,
'Clinical Drug Component (SCDC)' as term_type_level,
    rxn.rxcui,
    rxn.tty,
    rxn.str as name,
    rel.rela,
    rel.rxcui1,
    rxn2.str as relation_name,
    rxn2.tty as relation_tty
from
    rxnconso rxn
    join rxnrel rel 
    on rxn.rxcui = rxcui2
    join rxnconso rxn2 on rel.rxcui1 = rxn2.rxcui
where
    rxn.sab = 'RXNORM'
    and rel.rela = 'ingredient_of'
    AND rxn2.tty in ('SCDC')
    and rxn.rxcui = '1991302'

order by 1, relation_name