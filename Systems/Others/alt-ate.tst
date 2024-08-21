PL/SQL Developer Test script 3.0
29
-- Created on 31/07/2024 by JEFFERSONLIMA 
/*Alterador de dados do atendimento sem gatilhos*/  


begin
  /* Selecionar empresa */
  dbamv.pkg_mv2000.atribui_empresa(/*Codigo da empresa*/);
  
end; 

-- Atualização de data e hora de  atendimento
-- update atendime 
-- set dt_atendimento = to_Date('10/11/2021 10:33', 'DD/MM/YYYY HH24:MI:SS'),
--     hr_atendimento = to_Date('10/11/2021 10:33', 'DD/MM/YYYY HH24:MI:SS')
-- where cd_atendimento = 1068225


/* Atualização de data e hora da alta*/
-- update atendime 
-- set dt_alta = to_Date('15/02/2022 10:00', 'DD/MM/YYYY HH24:MI:SS'),
--     hr_alta = to_Date('15/02/2022 10:00', 'DD/MM/YYYY HH24:MI:SS'),
--     dh_alta_lancada = to_Date('5/02/2022 10:00', 'DD/MM/YYYY HH24:MI:SS')
-- where cd_atendimento = 1121459


/* Alteração do motivo de alta*/
UPDATE ATENDIME 
SET CD_MOT_ALT = 1
WHERE  CD_ATENDIMENTO = /*Atendimento*/
0
0
