select 
'01' AS LEVEL,
    rel.rxcui1 as rel_rxcui1,
    rel.rxcui2 as rel_rxcui2,
    con.str as con_brand_name,
    con.rxcui as con_rxcui,
    con.tty as type,
    con1.rxcui as ingredient_rxcui,
    con1.str as ingredient_name,
    con1.code,
    con1.suppress
from
    rxnrel rel
    join rxnconso con on rel.rxcui1 = con.rxcui
    and con.tty = 'BN'
    and con.sab='RXNORM'
    join rxnconso con1 on rel.rxcui2 =  con1.rxcui
    and con1.tty in ('IN','PIN', 'MIN')
    and con1.SAB = 'ATC'
    and con1.suppress NOT IN ('E', 'O', 'Y')
where rel.rxcui1 = '1991307'
union ALL
select 
'02' AS LEVEL,
    rel.rxcui1 as rel_rxcui1,
    rel.rxcui2 as rel_rxcui2,
    con.str as con_brand_name,
    con.rxcui as con_rxcui,
    con1.tty as type,
    con1.rxcui as ingredient_rxcui,
    con1.str as ingredient_name,
    con1.code,
    con1.suppress
from
    rxnrel rel
    join rxnconso con on rel.rxcui1 = con.rxcui
    and con.tty = 'BN'
    and con.sab='RXNORM'
    join rxnconso con1 on rel.rxcui2 =  con1.rxcui
    and con1.tty in ('SBDC')
    and con1.sab='RXNORM'
and con1.suppress NOT IN ('E', 'O', 'Y')
where rel.rxcui1 = '1991307'
union ALL
select 
'03' AS LEVEL,
    rel.rxcui1 as rel_rxcui1,
    rel.rxcui2 as rel_rxcui2,
    con.str as con_brand_name,
    con.rxcui as con_rxcui,
    con1.tty as type,
    con1.rxcui as ingredient_rxcui,
    con1.str as ingredient_name,
    con1.code,
    con1.suppress
from
    rxnrel rel
    join rxnconso con on rel.rxcui1 = con.rxcui
    and con.tty = 'BN'
    and con.sab='RXNORM'
    join rxnconso con1 on rel.rxcui2 =  con1.rxcui
    and con1.tty in ('SBD', 'BPCK')
    and con1.sab='RXNORM'
    and con1.suppress NOT IN ('E', 'O', 'Y')
where rel.rxcui1 = '1991307'
order by 1,8
;