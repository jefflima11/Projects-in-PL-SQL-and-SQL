select 
  sum(qt_tt_24h) qt_tt_24h, 
  sum(qt_tt_ate) as qt_tt_ate, 
  -- cálculo da taxa de retorno
  trunc(((sum(qt_tt_24h)) / sum(qt_tt_ate)) * 100, 2) as tx_ret, 
  dt 
from (
    -- contagem de pacientes que retornaram dentro de 24 horas, sem distincao do motivo
	select 
  	sum(tt) qt_tt_24h,
		0 qt_tt_ate,
		To_char(dt_atendimento,'mm/yyyy') dt
  from (
    select 
      a.dt_atendimento,
      a.cd_paciente,
      case
        when count(*) >= 2 then 1
        else 0
      end tt,
      c.cd_sgru_cid
    from dbamv.atendime a, dbamv.paciente p, dbamv.cid c
    where 
      a.cd_paciente = p.cd_paciente
    and a.cd_cid = c.cd_cid
    and a.tp_atendimento = 'U'
    and a.dt_atendimento between to_date('01/01/2024','dd/mm/yyyy') and to_date('31/07/2024','dd/mm/yyyy')
    group by nm_paciente, dt_atendimento, a.cd_paciente, c.cd_sgru_cid
		)
	where tt > 0
	group by To_char(dt_atendimento,'mm/yyyy')

    union all 
      
    -- contagem total de atendimentos
    select 
      0 as qt_tt_24h, 
      count(*) as qt_tt_ate, 
      to_char(a.dt_atendimento, 'mm/yyyy') as dt 
    from 
      dbamv.atendime a 
    where 
      tp_atendimento = 'U' 
      and dt_atendimento between to_date('01/01/2024', 'dd/mm/yyyy') 
      and to_date('31/07/2024', 'dd/mm/yyyy') 
    group by 
      to_char(a.dt_atendimento, 'mm/yyyy')
  ) 
group by dt

--order by 4;
