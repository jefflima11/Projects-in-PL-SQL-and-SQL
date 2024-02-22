/*CREATED BY
NAME: JEFFERSON LIMA GONCALVES
CARGO: ANALISTA E DESENVOLVEDOR DE SISTEMAS JR
DATA: 01/02/2024
TITULO: TAXA DE OCUPAÇÃO RETROATIVA
DESCRICAO: 
FILTROS:

ÚLTIMA ATUALIZAÇÃO
RESPÓNSAVEL:
DATA:
MOTIVO:
DESCRIÇÃO:
*/

SELECT MesAno
     , Item
     , Valor
  FROM (
SELECT To_Char(Leitos.Data,'mm/yyyy') MesAno
    , 'TX Ocupa��o' Item
     , Round(Sum(Nvl(Qtde_PacDia,0))/Decode(Sum(Qtde_LeitoDia),0,1,Sum(Qtde_LeitoDia))*100,2) Valor
  FROM (
       SELECT Contador.Data
            , Count(*) Qtde_LeitoDia
         FROM dbamv.unid_int
        INNER JOIN dbamv.leito ON leito.cd_unid_int = unid_int.cd_unid_int
        INNER JOIN dbamv.setor ON unid_int.cd_setor = setor.cd_setor
        INNER JOIN dbamv.tip_acom ON leito.cd_tip_acom = tip_acom.cd_tip_acom
            , (SELECT TO_DATE('2023-01-01', 'yyyy-mm-dd') + ROWNUM - 1 AS data
                 FROM DUAL
                CONNECT BY TO_DATE('2023-01-01', 'yyyy-mm-dd') + ROWNUM - 1 < TO_DATE('2023-07-31', 'yyyy-mm-dd')
              ) contador
        WHERE contador.data BETWEEN leito.dt_ativacao AND nvl(leito.dt_desativacao,SYSDATE)
          AND unid_int.cd_unid_int   IN (2,11,26)
          AND tp_acomodacao NOT IN ('B', 'H')
          AND leito.sn_extra = 'N'
           --N�o considerar os leitos fora de opera��o no momento do censo
          AND NOT EXISTS (SELECT 'X'
                            FROM dbamv.mov_int
                           WHERE tp_mov IN ('A','M','C','T') --A - Acompanhante, M - Manuten��o, C - Interditado por infec��o, T - interditado por isolamento
                             AND mov_int.cd_leito = leito.cd_leito
                             AND contador.data BETWEEN To_Date(To_Char(DT_MOV_INT,'dd/mm/yyyy')||To_Char(HR_MOV_INT,'hh24:mi'),'dd/mm/yyyy hh24:mi')
                                                   AND Nvl(To_Date(To_Char(DT_LIB_MOV,'dd/mm/yyyy')||To_Char(HR_LIB_MOV,'hh24:mi'),'dd/mm/yyyy hh24:mi'), SYSDATE)
                         )
        GROUP BY contador.Data
       ) Leitos
  LEFT JOIN
       (
       SELECT contador.Data
            , Count(*) Qtde_PacDia
         FROM dbamv.mov_int
        INNER JOIN dbamv.leito ON mov_int.cd_leito = leito.cd_leito
        INNER JOIN dbamv.tip_acom ON leito.cd_tip_acom = tip_acom.cd_tip_acom
        INNER JOIN dbamv.atendime ON mov_int.cd_atendimento = atendime.cd_atendimento
            , (SELECT TO_DATE('2023-01-01', 'yyyy-mm-dd') + ROWNUM - 1 AS data
                 FROM DUAL
                CONNECT BY TO_DATE('2023-01-01', 'yyyy-mm-dd') + ROWNUM - 1 < TO_DATE('2023-07-31', 'yyyy-mm-dd')
              ) contador
        WHERE DATA BETWEEN Trunc(mov_int.dt_mov_int) AND Nvl(dt_lib_mov - 1, TO_DATE('2023-07-31', 'yyyy-mm-dd'))
          AND mov_int.tp_mov IN ('I','O','F') -- Interna��o, Transfer�ncia e Pacientes com Infec��o
          AND tp_acomodacao NOT IN ('B', 'H') -- Ber��rio e Hospital Dia
          AND leito.sn_extra = 'N'
          AND leito.cd_unid_int IN (2,11,26)
        GROUP BY contador.data
       ) Pacientes
    ON Leitos.data = Pacientes.data
 GROUP BY To_Char(Leitos.Data,'mm/yyyy'))
;