/*Alterador de dados do atendimento sem gatilhos*/

-- select * from atendime a
-- where a.cd_atendimento = 1119225
  
begin
  dbamv.pkg_mv2000.atribui_empresa(1);
end; 

-- select 'a', dbamv.pkg_mv2000.le_empresa() from  dual
--   
-- update atendime 
-- set dt_atendimento = to_Date('10/11/2021 10:33', 'DD/MM/YYYY HH24:MI:SS'),
--     hr_atendimento = to_Date('10/11/2021 10:33', 'DD/MM/YYYY HH24:MI:SS')
-- where cd_atendimento = 1068225
-- 
-- update atendime 
-- set dt_alta = to_Date('15/02/2022 10:00', 'DD/MM/YYYY HH24:MI:SS'),
--     hr_alta = to_Date('15/02/2022 10:00', 'DD/MM/YYYY HH24:MI:SS'),
--     dh_alta_lancada = to_Date('5/02/2022 10:00', 'DD/MM/YYYY HH24:MI:SS')
-- where cd_atendimento = 1121459

UPDATE ATENDIME 
SET CD_MOT_ALT = 1
WHERE  CD_ATENDIMENTO = 1367996
