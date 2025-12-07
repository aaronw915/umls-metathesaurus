with bleh as (select n.ndc, r.rxcui, r.tty, r.str as description,
dense_rank() over (partition by n.rx_rxcui
        order by
            case
                when r.tty = 'PSN' then 1
                when r.tty = 'SCD' then 1.5
                when r.tty = 'SBD' then 2
                when r.tty = 'SY' then 3
                when r.tty= 'TMSY' then 4
                else 99
            end asc nulls last
    ) as row_num
from ndcs_with_tty n 
left join rxnconso r  
on r.rxcui = n.rx_rxcui 
and r.sab='RXNORM')
select ndc, rxcui, description from bleh where row_num = 1 ;