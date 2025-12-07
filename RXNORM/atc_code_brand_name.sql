WITH OZEMPIC AS (select 
distinct
'01-BRAND_NAME' AS LEVEL,
    con.str as BRAND_NAME,
    con.rxcui as BRAND_NAME_RXCUI,
    con.tty as type,
    ''  as ingredient_rxcui,
    '' as ingredient_name,
    '' AS code,
    '' as suppress
    /* 
    con1.rxcui as ingredient_rxcui,
    con1.str as ingredient_name,
    con1.code,
    con1.suppress*/
from
    rxnrel rel
    join rxnconso con on rel.rxcui1 = con.rxcui
    and con.tty = 'BN'
    and con.sab='RXNORM'
    /*join rxnconso con1 on rel.rxcui2 =  con1.rxcui
    and con1.tty in ('IN','PIN', 'MIN')
    and con1.SAB = 'ATC'
    and con1.suppress NOT IN ('E', 'O', 'Y')*/
where --ingredient_rxcui='1991302'
rel.rxcui1 in ('1991307', '2553502', '2200645')
union all
select '02-ATC_CODE' AS LEVEL,
    con.str as BRAND_NAME,
    con.rxcui as BRAND_NAME_RXCUI,
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
where --ingredient_rxcui='1991302'
rel.rxcui1 in ('1991307', '2553502', '2200645')
union ALL
select 
'03-BRANDED_DRUG_COMPONENT' AS LEVEL,
    con.str as BRAND_NAME,
    con.rxcui as BRAND_NAME_RXCUI,
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
where --ingredient_rxcui='1991302'
rel.rxcui1 in ('1991307', '2553502', '2200645')
union ALL
select 
'04-BRANDED_DRUG_OR_PACK' AS LEVEL,
    con.str as BRAND_NAME,
    con.rxcui as BRAND_NAME_RXCUI,
    con1.tty as type,
    con1.rxcui as ingredient_rxcui,
    con2.str as ingredient_name,
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
    join rxnconso con2 on rel.rxcui2 = con2.rxcui
    and con2.sab='RXNORM'
    and con2.tty='PSN'
where --ingredient_rxcui='1991302'
rel.rxcui1 in ('1991307', '2553502', '2200645')
)
SELECT S.ATV,o1.code as atc_code,O1.ingredient_name as atc_ingredient, O.BRAND_NAME, o.ingredient_name,
atc.atc_name, atc.hierarchy_level
FROM OZEMPIC O 
JOIN RXNSAT S ON O.ingredient_rxcui=S.rxcui
 AND S.ATN='NDC' AND S.SAB='RXNORM' 
JOIN OZEMPIC O1 
ON O.BRAND_NAME_RXCUI = O1.BRAND_NAME_RXCUI
and O1.Level = '02-ATC_CODE'
join atc_hierarchy_flat atc 
on atc.target_atc_code_leaf = O1.code
and atc.hierarchy_level=2
order by ingredient_name
