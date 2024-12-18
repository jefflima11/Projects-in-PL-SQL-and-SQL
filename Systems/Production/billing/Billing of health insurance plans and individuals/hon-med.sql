SELECT  A.CD_ATENDIMENTO ATENDIMENTO,
        P.NM_PACIENTE PACIENTE,
        PRE.NM_PRESTADOR PRESTADOR_EXEC,
        IRF.CD_REG_FAT CONTA,
        PF.CD_PRO_FAT PROCEDIMENTO,
        PF.DS_PRO_FAT DESCRICAO,
        IRF.VL_TOTAL_CONTA VALOR,
        CO.SN_PAGA_PELO_CONVENIO

FROM    DBAMV.ITREG_FAT IRF,
        DBAMV.PRO_FAT PF,
        DBAMV.ATENDIME A,
        DBAMV.REG_FAT RF,
        DBAMV.PACIENTE P,
        DBAMV.ITLAN_MED ILM,
        DBAMV.PRESTADOR PRE,
       (SELECT  DISTINCT SN_PAGA_PELO_CONVENIO,
                CD_PRESTADOR,
                CD_CONVENIO
        FROM    DBAMV.PRES_CON PC
        WHERE   CD_CONVENIO IN (3,4)
          AND   CD_MULTI_EMPRESA = 1) CO 

WHERE   IRF.CD_PRO_FAT = PF.CD_PRO_FAT
  AND   IRF.CD_REG_FAT = RF.CD_REG_FAT
  AND   RF.CD_ATENDIMENTO = A.CD_ATENDIMENTO
  AND   A.CD_PACIENTE = P.CD_PACIENTE
  AND   IRF.CD_REG_FAT = ILM.CD_REG_FAT
  AND   IRF.CD_LANCAMENTO = ILM.CD_LANCAMENTO
  AND   ILM.CD_PRESTADOR = PRE.CD_PRESTADOR
  AND   ILM.CD_PRESTADOR = CO.CD_PRESTADOR
  AND   RF.CD_CONVENIO = CO.CD_CONVENIO
  
  AND   IRF.VL_TOTAL_CONTA BETWEEN 0.01 AND 0.99
  AND   TO_CHAR(IRF.DT_LANCAMENTO,'MMYYYY') = '012024'
  AND   IRF.CD_GRU_FAT IN ('7','6')
  AND   RF.CD_CONVENIO IN (3,4)
  AND   PRE.NM_PRESTADOR LIKE '%%'
;
