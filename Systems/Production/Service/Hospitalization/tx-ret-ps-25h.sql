select
	sum(qt_tt_24h)/2 qt_tt_24h,
	sum(qt_tt_ate) qt_tt_ate,
	((sum(qt_tt_24h)/2)/sum(qt_tt_ate))*100 tst,
	dt
from (
  select 
    count(*) qt_tt_24h,
    0 qt_tt_ate,
    to_char(a.dt_atendimento,'mm/yyyy') dt
  from dbamv.atendime a, dbamv.paciente p, dbamv.cid c
  where 
    a.cd_paciente = p.cd_paciente
  and a.cd_cid = c.cd_cid
  and a.tp_atendimento = 'U'
  and a.dt_atendimento between to_date('01/01/2024','dd/mm/yyyy') and to_date('31/07/2024','dd/mm/yyyy')
  	
  group by nm_paciente, dt_atendimento, ds_cid
  having count(nm_paciente) > 1
  				
  union all
  	
  select 
    0 qt_tt_24h,
    count(*) qt_tt_ate,
    to_char(a.dt_atendimento ,'mm/yyyy') dt
  from	
    dbamv.atendime  a
  where
    tp_atendimento = 'U' 
  and dt_atendimento between to_date('01/01/2024','dd/mm/yyyy') and to_date('31/07/2024','dd/mm/yyyy')

  group by to_char(a.dt_atendimento ,'mm/yyyy')
)

group by dt
order by 3
