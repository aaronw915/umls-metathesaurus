create or replace view  ndcs_with_tty as 
with ndcs as (
    select
        sat.atv as ndc,
        sat.suppress as ndc_suppress,
        sat.stype as ndc_stype,
        rxc.rxcui as rx_rxcui,
        rxc.str as ndc_description,
        rxc.tty as rxc_tty
    from
        rxnsat sat
        LEFT join rxnconso rxc on sat.rxcui = rxc.rxcui
        and rxc.sab = 'RXNORM'
        and rxc.tty in ('BN', 'SBDC', 'SBD', 'SCD', 'IN')
    where
        sat.atn = 'NDC'
        and sat.sab = 'RXNORM' --and rxc.rxcui = '2679323'
    order by
        1,
        4
)
select
    v.ndc_nbr_cd,
    s.*
from
    unique_ndc_rx_claims v
    left join ndcs s on v.ndc_nbr_cd = s.ndc;