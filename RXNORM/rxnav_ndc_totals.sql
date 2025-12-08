with rxnav as (select
    distinct 'ingredient' as type ,
    n.ndc_nbr_cd,
    v.relation_rxcui as rxcui,
    v.ingredient_name as ingredient_brandname,
    v.relation_name
from
    ndcs_with_tty n
 join rxnav_ingredient_v v on n.rx_rxcui = v.relation_rxcui
 union all
 select
    distinct 'brand_name' as type ,
    n.ndc_nbr_cd,
    v.relation_rxcui as rxcui,
    v.brand_name,
    v.relation_name
from
    ndcs_with_tty n
 join rxnav_brandname_v v on n.rx_rxcui = v.relation_rxcui)
select type, ingredient_brandname, relation_name, count(*) from rxnav group by all order by count(*) desc