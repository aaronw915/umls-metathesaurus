WITH BASE AS (
    -- your Level 01-03 Wegovy structure results
    select 
    '01' AS LEVEL,
        rel.rxcui1 as rel_rxcui1,
        rel.rxcui2 as rel_rxcui2,
        rel.rxaui1 as rel_rxaui1,
        rel.rxaui2 as rel_rxaui2,
        con.str as con_brand_name,
        con.rxcui as con_rxcui,
        con.rxaui as con_rxaui,
        con.tty as type,
        con1.rxaui as ingredient_rxaui,
        con1.rxcui as ingredient_rxcui,
        con1.str as ingredient_name,
        con1.code,
        con1.suppress
    from rxnrel rel
    join rxnconso con   on rel.rxcui1 = con.rxcui and con.tty='BN' and con.sab='RXNORM'
    join rxnconso con1  on rel.rxcui2 = con1.rxcui and con1.tty in ('IN','PIN','MIN') 
                                   and con1.sab='ATC' and con1.suppress NOT IN ('E','O','Y')
    where rel.rxcui1 = '2553502'
    
    UNION ALL
    
    select '02',
        rel.rxcui1, rel.rxcui2, rel.rxaui1, rel.rxaui2,
        con.str, con.rxcui, con.rxaui, con.tty,
        con1.rxaui, con1.rxcui, con1.str, con1.code, con1.suppress
    from rxnrel rel
    join rxnconso con   on rel.rxcui1 = con.rxcui and con.tty='BN' and con.sab='RXNORM'
    join rxnconso con1  on rel.rxcui2 = con1.rxcui and con1.tty='SBDC' 
                                    and con1.sab='RXNORM' and con1.suppress NOT IN ('E','O','Y')
    where rel.rxcui1 = '2553502'
    
    UNION ALL
    
    select '03',
        rel.rxcui1, rel.rxcui2, rel.rxaui1, rel.rxaui2,
        con.str, con.rxcui, con.rxaui, con.tty,
        con1.rxaui, con1.rxcui, con2.str, con1.code, con1.suppress
    from rxnrel rel
    join rxnconso con   on rel.rxcui1 = con.rxcui and con.tty='BN' and con.sab='RXNORM'
    join rxnconso con1  on rel.rxcui2 = con1.rxcui and con1.tty in ('SBD','BPCK')
                                    and con1.sab='RXNORM' and con1.suppress NOT IN ('E','O','Y')
    join rxnconso con2  on rel.rxcui2=con2.rxcui and con2.tty='PSN' and con2.sab='RXNORM'
    where rel.rxcui1='2553502'
)

SELECT
    B.LEVEL,
    B.CON_BRAND_NAME,
    B.INGREDIENT_NAME,
    B.INGREDIENT_RXCUI,
    B.REL_RXCUI2 AS PRODUCT_RXCUI,
    S.ATV AS NDC
FROM BASE B
JOIN RXNSAT S 
      ON (S.RXCUI = B.REL_RXCUI2 OR S.RXAUI = B.INGREDIENT_RXAUI)  -- critical for NDC
     AND S.ATN='NDC'      -- only pull NDC values
     AND S.SUPPRESS NOT IN ('E','O','Y')
ORDER BY LEVEL, PRODUCT_RXCUI;
