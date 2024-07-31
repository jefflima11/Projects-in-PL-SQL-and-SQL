SELECT *

FROM(
SELECT CR.CD_REG_FAT CD_CONTA,
       CR.DS_CON_REC,
       CR.CD_CON_REC,
       A.DT_ATENDIMENTO,
       CR.VL_PREVISTO,
       CR.VL_ACRESCIMO,
       ICR.VL_SOMA_RECEBIDO,
       (CR.VL_PREVISTO -
       (DECODE(ICR.VL_SOMA_RECEBIDO, NULL, 0, ICR.VL_SOMA_RECEBIDO) - DECODE(CR.VL_ACRESCIMO, NULL, 0, CR.VL_ACRESCIMO))- DECODE(CR.VL_DESCONTO, NULL, 0, CR.VL_DESCONTO)) DIF,
	   'INT' TP_CONT,
	   P.NM_PACIENTE
FROM   DBAMV.CON_REC CR, 
       DBAMV.ITCON_REC ICR,
       DBAMV.ATENDIME A,
	   DBAMV.PACIENTE P
WHERE  CR.CD_CON_REC = ICR.CD_CON_REC
  AND  CR.CD_ATENDIMENTO = A.CD_ATENDIMENTO
  AND A.CD_PACIENTE  = P.CD_PACIENTE
  AND  CR.CD_MULTI_EMPRESA = 1
  AND  CR.CD_REG_FAT IS NOT NULL
  AND  ICR.NR_PARCELA = 1
  AND  CR.TP_CON_REC = 'P'
  AND  (CR.VL_PREVISTO - (DECODE(ICR.VL_SOMA_RECEBIDO, NULL, 0, ICR.VL_SOMA_RECEBIDO) - DECODE(CR.VL_ACRESCIMO, NULL, 0, CR.VL_ACRESCIMO))- DECODE(CR.VL_DESCONTO, NULL, 0, CR.VL_DESCONTO)) != '0'

UNION 

SELECT CR.CD_REG_AMB CD_CONTA,
       CR.DS_CON_REC,
       CR.CD_CON_REC,
       CR.DT_LANCAMENTO,
       CR.VL_PREVISTO,
       CR.VL_ACRESCIMO,
       ICR.VL_SOMA_RECEBIDO,
       (CR.VL_PREVISTO -
       (DECODE(ICR.VL_SOMA_RECEBIDO, NULL, 0, ICR.VL_SOMA_RECEBIDO) - DECODE(CR.VL_ACRESCIMO, NULL, 0, CR.VL_ACRESCIMO))- DECODE(CR.VL_DESCONTO, NULL, 0, CR.VL_DESCONTO)) DIF,
	   'AMB' TP_CONT,
	   P.NM_PACIENTE
FROM DBAMV.CON_REC CR, 
       DBAMV.ITCON_REC ICR,
       DBAMV.ATENDIME A,
	   DBAMV.PACIENTE P
WHERE CR.CD_CON_REC = ICR.CD_CON_REC
  AND CR.CD_ATENDIMENTO = A.CD_ATENDIMENTO
  AND A.CD_PACIENTE  = P.CD_PACIENTE
  AND CR.CD_MULTI_EMPRESA = 1
  AND CR.CD_REG_AMB IS NOT NULL
  AND ICR.NR_PARCELA = 1
  AND CR.TP_CON_REC = 'P'
  AND  (CR.VL_PREVISTO - (DECODE(ICR.VL_SOMA_RECEBIDO, NULL, 0, ICR.VL_SOMA_RECEBIDO) - DECODE(CR.VL_ACRESCIMO, NULL, 0, CR.VL_ACRESCIMO))- DECODE(CR.VL_DESCONTO, NULL, 0, CR.VL_DESCONTO)) != '0'   )
WHERE DT_ATENDIMENTO > TO_DATE('01/01/2024','DD/MM/YYYY');
