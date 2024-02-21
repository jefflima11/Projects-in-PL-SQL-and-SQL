/*CREATED BY
NAME: JEFFERSON LIMA GONCALVES
CARGO: ANALISTA E DESENVOLVEDOR DE SISTEMAS JR
DATA: 01/02/2024
TITULO: HISTORICO DE MOVIMENTACAO DE LEITO
DESCRICAO: 
FILTROS:

ÚLTIMA ATUALIZAÇÃO
RESPÓNSAVEL:
DATA:
MOTIVO:
DESCRIÇÃO:
*/

SELECT
  U.DS_UNID_INT,
  L.DS_LEITO,
  Decode(M.TP_MOV,'O','TRANSFERENCIA'
                 ,'I','INTERNACAO'
                 ,'A','ACOMPANHANTE'
                 ,'F','INFECCAO'
                 ,'L','LIMPEZA'
                 ,'M','MANUTENCAO'
                 ,'T','INTERDIDATO POR ISOLAMENTO'
                 ,M.TP_MOV)TIPO_MOV,
  To_Char(DT_MOV_INT,'DD/MM/YYYY')DATA_MOV,
  To_Char(HR_MOV_INT,'HH24:MI')HORA_MOV


FROM
  DBAMV.MOV_INT M,
  DBAMV.LEITO L,
  DBAMV.UNID_INT U

WHERE
      M.DT_MOV_INT BETWEEN SYSDATE-1 AND SYSDATE+1
  AND U.CD_UNID_INT IN (26,11,2)
  AND M.CD_LEITO = L.CD_LEITO
  AND L.CD_UNID_INT = U.CD_UNID_INT

ORDER BY
  To_Char(DT_MOV_INT,'DD/MM/YYYY'),
  To_Char(HR_MOV_INT,'HH24:MI')