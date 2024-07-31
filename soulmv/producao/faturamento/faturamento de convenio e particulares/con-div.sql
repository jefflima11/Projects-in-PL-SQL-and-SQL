/*CREATED BY
NAME: JEFFERSON LIMA GONCALVES
CARGO: ANALISTA E DESENVOLVEDOR DE SISTEMAS JR
DATA: 01/04/2024
TITULO: STATUS ATUAL DA CONTA
DESCRICAO:
FILTROS:

ULTIMA ATUALIZAÇÃO
RESPONSAVEL: JEFFERSON LIMA     
DATA: 30/04/2024
MOTIVO:
DESCRIÇÃO:
*/
SELECT *

FROM(
        SELECT  A.CD_ATENDIMENTO ATENDIMENTO,
                RF.CD_REG_FAT CONTA,
                C.NM_CONVENIO CONVENIO,
                DECODE(A.TP_ATENDIMENTO,'I','INTERNACAO',
                                        'U','URGENCIA',
                                        'A','AMBULATORIAL',
                                        'E','EXTERNO') TP_ATENDIMENTO,
                CR.DT_EMISSAO,
                CASE
                  WHEN  RF.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'C'
                    THEN 'CONTA RECEBIDA  - QUITACAO COMPROMETIDA'
                  WHEN  RF.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'V'
                    THEN 'CONTA RECEBIDA  - QUITACAO PREVISTA'
                  WHEN  RF.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'P'
                    THEN 'CONTA RECEBIDA  - QUITACAO PARCIAL'    
                  WHEN  RF.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'Q'
                    THEN 'CONTA RECEBIDA  - QUITACAO TOTAL'
                  WHEN  RF.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'L'
                    THEN 'CONTA RECEBIDA  - QUITACAO CANCELADA'
                  WHEN  RF.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'R'
                    THEN 'CONTA RECEBIDA  - QUITACAO PROTESTADA'
                  WHEN  RF.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'G'
                    THEN 'CONTA RECEBIDA  - QUITACAO COM GLOSA'                    
                  WHEN  RF.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL
                    THEN  'CONTA RECEBIDA'
                  WHEN  RF.SN_FECHADA = 'S'
                    THEN  'CONTA FECHADA'
                  WHEN  RF.SN_FECHADA = 'N'
                    THEN  'CONTA ABERTA'
                  ELSE 'TST'
                END STATUS,
                ((DECODE(SUM(RF.VL_TOTAL_CONTA),NULL,0
                                              ,RF.VL_TOTAL_CONTA)-
                 (DECODE(SUM(ICR.VL_SOMA_RECEBIDO),NULL,0
                                                 ,ICR.VL_SOMA_RECEBIDO))-
                 (DECODE(SUM(CR.VL_DESCONTO),NULL,0
                                            ,CR.VL_DESCONTO)))+
                 (DECODE(SUM(CR.VL_ACRESCIMO),NULL,0
                                             ,CR.VL_ACRESCIMO)))VL_INA
                
        FROM    DBAMV.ATENDIME A,
                DBAMV.REG_FAT RF,
                DBAMV.CONVENIO C,
                DBAMV.REMESSA_FATURA RFA,
                DBAMV.FATURA F,
                DBAMV.CON_REC CR,
                DBAMV.ITCON_REC ICR,
                DBAMV.RECCON_REC RCR
                
        WHERE   A.CD_ATENDIMENTO = RF.CD_ATENDIMENTO
          AND   RF.CD_CONVENIO = C.CD_CONVENIO
          AND   RF.CD_REMESSA = RFA.CD_REMESSA(+)
          AND   RFA.CD_FATURA = F.CD_FATURA(+)
          AND   RF.CD_REG_FAT = CR.CD_REG_FAT(+)
          AND   CR.CD_CON_REC = ICR.CD_CON_REC(+)
          AND   ICR.CD_ITCON_REC = RCR.CD_ITCON_REC(+)

          AND   TO_CHAR(RF.DT_INICIO,'MMYYYY') LIKE '%{vData}%'
          AND   A.CD_MULTI_EMPRESA = 1

        GROUP BY  A.CD_ATENDIMENTO,
                RF.CD_REG_FAT,
                C.NM_CONVENIO,
                CASE
                  WHEN  RF.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'C'
                    THEN 'CONTA RECEBIDA  - QUITACAO COMPROMETIDA'
                  WHEN  RF.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'V'
                    THEN 'CONTA RECEBIDA  - QUITACAO PREVISTA'
                  WHEN  RF.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'P'
                    THEN 'CONTA RECEBIDA  - QUITACAO PARCIAL'    
                  WHEN  RF.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'Q'
                    THEN 'CONTA RECEBIDA  - QUITACAO TOTAL'
                  WHEN  RF.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'L'
                    THEN 'CONTA RECEBIDA  - QUITACAO CANCELADA'
                  WHEN  RF.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'R'
                    THEN 'CONTA RECEBIDA  - QUITACAO PROTESTADA'
                  WHEN  RF.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'G'
                    THEN 'CONTA RECEBIDA  - QUITACAO COM GLOSA'                    
                  WHEN  RF.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL
                    THEN  'CONTA RECEBIDA'
                  WHEN  RF.SN_FECHADA = 'S'
                    THEN  'CONTA FECHADA'
                  WHEN  RF.SN_FECHADA = 'N'
                    THEN  'CONTA ABERTA'
                  ELSE 'TST'
                END,
                ICR.VL_SOMA_RECEBIDO,
                CR.VL_DESCONTO,
                RF.VL_TOTAL_CONTA,
                CR.VL_ACRESCIMO,
                A.TP_ATENDIMENTO,
                CR.DT_EMISSAO                
        UNION ALL
        
        SELECT  DISTINCT
        A.CD_ATENDIMENTO ATENDIMENTO,
        RA.CD_REG_AMB CONTA,
        C.NM_CONVENIO CONVENIO,
        DECODE(A.TP_ATENDIMENTO,'I','INTERNACAO',
                                'U','URGENCIA',
                                'E','EMERGENCIA',
                                'A','AMBULATORIAL') TP_ATENDIMENTO,
        CR.DT_EMISSAO,                                
        CASE
          WHEN  IRA.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'C'
            THEN 'CONTA RECEBIDA  - QUITACAO COMPROMETIDA'
          WHEN  IRA.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'V'
            THEN 'CONTA RECEBIDA  - QUITACAO PREVISTA'
          WHEN  IRA.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'P'
            THEN 'CONTA RECEBIDA  - QUITACAO PARCIAL'    
          WHEN  IRA.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'Q'
            THEN 'CONTA RECEBIDA  - QUITACAO TOTAL'
          WHEN  IRA.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'L'
            THEN 'CONTA RECEBIDA  - QUITACAO CANCELADA'
          WHEN  IRA.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'R'
            THEN 'CONTA RECEBIDA  - QUITACAO PROTESTADA'
          WHEN  IRA.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'G'
            THEN 'CONTA RECEBIDA  - QUITACAO COM GLOSA'                    
          WHEN  IRA.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL
            THEN  'CONTA RECEBIDA'
          WHEN  IRA.SN_FECHADA = 'S'
            THEN  'CONTA FECHADA'
          WHEN  IRA.SN_FECHADA = 'N'
            THEN  'CONTA ABERTA'
          ELSE 'TST'
        END STATUS,
        ((DECODE(SUM(RA.VL_TOTAL_CONTA),NULL,0
                                      ,RA.VL_TOTAL_CONTA)-
         (DECODE(SUM(ICR.VL_SOMA_RECEBIDO),NULL,0
                                         ,ICR.VL_SOMA_RECEBIDO))-
         (DECODE(SUM(CR.VL_DESCONTO),NULL,0
                                    ,CR.VL_DESCONTO)))+
         (DECODE(SUM(CR.VL_ACRESCIMO),NULL,0
                                     ,CR.VL_ACRESCIMO)))VL_INA
        

FROM    DBAMV.REG_AMB RA,
        DBAMV.ITREG_AMB IRA,
        DBAMV.ATENDIME A,
        DBAMV.CONVENIO C,
        DBAMV.CON_REC CR,
        DBAMV.ITCON_REC ICR

WHERE   RA.CD_REG_AMB = IRA.CD_REG_AMB
  AND   IRA.CD_ATENDIMENTO = A.CD_ATENDIMENTO
  AND   RA.CD_CONVENIO = C.CD_CONVENIO
  AND   IRA.CD_REG_AMB = CR.CD_REG_AMB(+)
  AND   CR.CD_CON_REC = ICR.CD_CON_REC(+)
  
  AND   TO_CHAR(RA.DT_LANCAMENTO,'MMYYYY') LIKE '%{vData}%'
  AND   A.CD_MULTI_EMPRESA = 1

GROUP BY A.CD_ATENDIMENTO,
        RA.CD_REG_AMB,
        C.NM_CONVENIO,
        A.TP_ATENDIMENTO,
        RA.VL_TOTAL_CONTA,
        ICR.VL_SOMA_RECEBIDO,
        CR.VL_DESCONTO,
        CR.VL_ACRESCIMO,
        CASE
          WHEN  IRA.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'C'
            THEN 'CONTA RECEBIDA  - QUITACAO COMPROMETIDA'
          WHEN  IRA.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'V'
            THEN 'CONTA RECEBIDA  - QUITACAO PREVISTA'
          WHEN  IRA.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'P'
            THEN 'CONTA RECEBIDA  - QUITACAO PARCIAL'    
          WHEN  IRA.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'Q'
            THEN 'CONTA RECEBIDA  - QUITACAO TOTAL'
          WHEN  IRA.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'L'
            THEN 'CONTA RECEBIDA  - QUITACAO CANCELADA'
          WHEN  IRA.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'R'
            THEN 'CONTA RECEBIDA  - QUITACAO PROTESTADA'
          WHEN  IRA.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL AND ICR.TP_QUITACAO = 'G'
            THEN 'CONTA RECEBIDA  - QUITACAO COM GLOSA'                    
          WHEN  IRA.SN_FECHADA = 'S' AND CR.DT_EMISSAO IS NOT NULL
            THEN  'CONTA RECEBIDA'
          WHEN  IRA.SN_FECHADA = 'S'
            THEN  'CONTA FECHADA'
          WHEN  IRA.SN_FECHADA = 'N'
            THEN  'CONTA ABERTA'
          ELSE 'TST'
        END,
        CR.DT_EMISSAO
        )
WHERE  CONVENIO LIKE ('%{vConvenio}%')
  AND  STATUS LIKE ('%{vstatus}%')
  AND  {vfull}                
