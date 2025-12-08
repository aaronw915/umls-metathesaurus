create or replace view rxnav_brandname_v as with brandname as (
    select
        1 as level_number,
        ing.rxcui as brand_name_rxcui,
        ing.tty as brand_name_tty,
        ing.str as brand_name,
        rel.rela as relationship,
        rel.rxcui1 as relation_rxcui,
        rxn.tty as relation_tty,
        rxn.str as relation_name
    from
        rxnconso ing
        join rxnrel rel on ing.rxcui = rel.rxcui2
        and lower(ing.sab) = 'rxnorm'
        and ing.tty = 'BN'
        and rel.rela = 'tradename_of'
        join rxnconso rxn on rxn.rxcui = rel.rxcui1
        and lower(rxn.sab) = 'rxnorm'
        and rxn.tty = 'IN'
        and rxn.suppress not in ('O', 'Y', 'E')
),
scdc as (
    select
        2 as level_number,
        ing.rxcui as brand_name_rxcui,
        ing.tty as brand_name_tty,
        ing.str as brand_name,
        rel.rela as relationship,
        rel.rxcui1 as relation_rxcui,
        rxn.tty as relation_tty,
        rxn.str as relation_name
    from
        rxnconso ing
        join rxnrel rel on ing.rxcui = rel.rxcui2
        and lower(ing.sab) = 'rxnorm'
        and ing.tty = 'BN'
        and rel.rela = 'ingredient_of'
        join rxnconso rxn on rxn.rxcui = rel.rxcui1
        and lower(rxn.sab) = 'rxnorm'
        and rxn.tty = 'SBDC'
        AND rxn.suppress not in ('O', 'Y', 'E')
),
sdc as (
    select
        3 as level_number,
        scdc.brand_name_rxcui,
        scdc.brand_name_tty,
        scdc.brand_name,
        rel2.rela,
        rel2.rxcui1,
        rxn2.tty,
        rxn3.str 
    from
        scdc scdc
    join rxnrel rel2 
    on rel2.rxcui2 = relation_rxcui
    and rel2.rela = 'constitutes'
    join rxnconso rxn2 
    on rxn2.rxcui = rel2.rxcui1
    and lower(rxn2.sab) = 'rxnorm'
    and rxn2.tty in ('SBD', 'BPCK')
    and rxn2.suppress not in ('O', 'Y', 'E')
    join rxnconso rxn3 on 
    rxn2.rxcui = rxn3.rxcui 
    and lower(rxn3.sab) = 'rxnorm'
    and rxn3.tty = 'PSN'
)
select
    *
from
    brandname
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