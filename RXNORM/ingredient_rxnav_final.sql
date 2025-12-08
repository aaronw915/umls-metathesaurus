create or replace view rxnav_ingredient_v as with ingredient_tradename as (
    select
        1 as level_number,
        ing.rxcui as ingredient_rxcui,
        ing.tty as ingredient_tty,
        ing.str as ingredient_name,
        rel.rela as relationship,
        rel.rxcui1 as relation_rxcui,
        rxn.tty as relation_tty,
        rxn.str as relation_name
    from
        rxnconso ing
        join rxnrel rel on ing.rxcui = rel.rxcui2
        and lower(ing.sab) = 'rxnorm'
        and ing.tty = 'IN'
        and rel.rela = 'has_tradename'
        join rxnconso rxn on rxn.rxcui = rel.rxcui1
        and lower(rxn.sab) = 'rxnorm'
        and rxn.tty = 'BN'
        and rxn.suppress not in ('O', 'Y', 'E')
),
scdc as (
    select
        2 as level_number,
        ing.rxcui as ingredient_rxcui,
        ing.tty as ingredient_tty,
        ing.str as ingredient_name,
        rel.rela as relationship,
        rel.rxcui1 as relation_rxcui,
        rxn.tty as relation_tty,
        rxn.str as relation_name
    from
        rxnconso ing
        join rxnrel rel on ing.rxcui = rel.rxcui2
        and lower(ing.sab) = 'rxnorm'
        and ing.tty = 'IN'
        and rel.rela = 'ingredient_of'
        join rxnconso rxn on rxn.rxcui = rel.rxcui1
        and lower(rxn.sab) = 'rxnorm'
        and rxn.tty = 'SCDC'
        AND rxn.suppress not in ('O', 'Y', 'E')
),
sdc as (
    select
        3 as level_number,
        scdc.ingredient_rxcui,
        scdc.ingredient_tty,
        scdc.ingredient_name,
        rel2.rela,
        rel2.rxcui1,
        rxn2.tty,
        rxn2.str 
        
    from
        scdc scdc
    join rxnrel rel2 
    on rel2.rxcui2 = relation_rxcui
    and rel2.rela = 'constitutes'
    join rxnconso rxn2 
    on rxn2.rxcui = rel2.rxcui1
    and lower(rxn2.sab) = 'rxnorm'
    and rxn2.tty in ('SCD', 'GPCK')
    and rxn2.suppress not in ('O', 'Y', 'E')
)
select
    *
from
    ingredient_tradename
union all
select
    *
from
    scdc
union all
select
    *
from
    sdc
order by
    level_number,
    relation_name,
    relation_rxcui