    create or replace view brand_name_v as 
    with brand_name as (
    select
        1 as level_number,
        'Brand Name (BN)' as term_type_level,
        rxn_bn.rxcui as bn_rxcui,
        rxn_bn.tty as bn_tty,
        rxn_bn.str as brand_name,
        rel.rela,
        rxn_in.rxcui as relation_rxcui,
        rxn_in.str as relation_name,
        rxn_in.tty as relation_tty
    from
        rxnconso rxn_bn
        join rxnrel rel on rxn_bn.rxcui = rel.rxcui2
        and rxn_bn.sab = 'RXNORM'
        and rxn_bn.tty = 'BN'
        and rxn_bn.lat = 'ENG'
        and rxn_bn.suppress not in ('O', 'Y', 'E')
        join rxnconso rxn_in on rxn_in.rxcui = rel.rxcui1
        and rxn_in.sab = 'RXNORM'
        and rxn_in.tty = 'IN'
    
),
sbdc as (
    select
        2 as level_number,
        'Branded Drug Component (SBDC)' as term_type_level,
        rxn_bn.rxcui as rxcui,
        rxn_bn.tty as tty,
        rxn_bn.str as brand_name,
        rel.rela,
        rxn_in.rxcui as relation_rxcui,
        rxn_in.str as relation_name,
        rxn_in.tty as relation_tty
    from
        rxnconso rxn_bn
        join rxnrel rel on rxn_bn.rxcui = rel.rxcui2
        and rxn_bn.sab = 'RXNORM'
        and rxn_bn.tty = 'BN'
        and rxn_bn.lat = 'ENG'
        and rxn_bn.suppress not in ('O', 'Y', 'E')
        join rxnconso rxn_in on rxn_in.rxcui = rel.rxcui1
        and rxn_in.sab = 'RXNORM'
        and rxn_in.tty = 'SBDC'
    
),
sbd_bpck as (
    select
        3 as level_number,
        'Branded Drug or Pack (SBD/BPCK)' as term_type_level,
        rxn_bn.rxcui as rxcui,
        rxn_bn.tty as tty,
        rxn_bn.str as brand_name,
        rel.rela,
        rxn_name.rxcui as relation_rxcui,
        rxn_name.str as relation_name,
        rxn_in.tty as relation_tty
    from
        rxnconso rxn_bn
        join rxnrel rel on rxn_bn.rxcui = rel.rxcui2
        and rxn_bn.sab = 'RXNORM'
        and rxn_bn.tty = 'BN'
        and rxn_bn.lat = 'ENG'
        and rxn_bn.suppress not in ('O', 'Y', 'E')
        join rxnconso rxn_in on rxn_in.rxcui = rel.rxcui1
        and rxn_in.sab = 'RXNORM'
        and rxn_in.tty in ('SBD', 'BPCK')
        and rxn_in.suppress not in ('O', 'Y', 'E')
        join rxnconso rxn_name on rxn_name.rxcui = rel.rxcui1
        and rxn_name.sab = 'RXNORM'
        and rxn_name.tty = 'PSN'
        and rxn_name.suppress not in ('O', 'Y', 'E')
    
)
select
    *
from
    brand_name
union all
select
    *
from
    sbdc
union all
select
    *
from
    sbd_bpck
