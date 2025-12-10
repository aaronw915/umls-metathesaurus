
create or replace table temp_ndc11 as 
with ndc11 as (SELECT
    s.atv,
    s.cui,
    length(s.atv),
    replace(s.atv,'-','') as ndc,
    length(replace(s.atv,'-','')),
    s.sab,
    ROW_NUMBER() OVER (
        PARTITION BY s.atv
        ORDER BY
            CASE
                WHEN s.sab = 'RXNORM' THEN 1
                WHEN s.sab = 'GS' THEN 2
                ELSE 99
            END ASC NULLS LAST
    ) AS rn,
FROM
    mrsat s
WHERE
    s.atn = 'NDC'
    and s.atv like '%-%'
    and length(replace(s.atv,'-',''))=11)
select ndc, sab, cui from ndc11 where rn = 1
;