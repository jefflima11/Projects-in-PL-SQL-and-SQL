/*CREATED BY
NAME: JEFFERSON LIMA GONCALVES
CARGO: ANALISTA E DESENVOLVEDOR DE SISTEMAS JR
DATA: 01/02/2024
TITULO: RETORNO DE INTERNAÇÃO COM MESMO CID
DESCRICAO: 
FILTROS:

ÚLTIMA ATUALIZAÇÃO
RESPÓNSAVEL:
DATA:
MOTIVO:
DESCRIÇÃO:
*/

SELECT
  TOTAL,
  NM_PACIENTE,
  DS_CID,
  Decode(FONE_C,'()','SEM INFORMACAO',
                FONE_C) FONE_C,
  Decode(CELULAR_C,'()','SEM INFORMACAO',
                   CELULAR_C) CELULAR_C

FROM
  (SELECT
    Count(P.NM_PACIENTE)TOTAL,
    P.NM_PACIENTE,
    '('||P.NR_DDD_FONE||')'||P.NR_FONE FONE_C,
    '('||P.NR_DDD_CELULAR||')'||P.NR_CELULAR CELULAR_C,
    C.DS_CID

   FROM
    DBAMV.ATENDIME A,
    DBAMV.PACIENTE P,
    DBAMV.CID C,
    DBAMV.ESPECIALID E,
    DBAMV.PRO_FAT PF,
    DBAMV.SERVICO S

   WHERE
    A.CD_PACIENTE = P.CD_PACIENTE
    AND A.CD_CID = C.CD_CID
    AND A.CD_ESPECIALID = E.CD_ESPECIALID
    AND A.CD_PRO_INT = PF.CD_PRO_FAT
    AND A.CD_SERVICO = S.CD_SERVICO

    AND A.DT_ATENDIMENTO BETWEEN To_Date('01/03/2023','DD/MM/YYYY')
                            AND To_Date('30/09/2023','DD/MM/YYYY')
    AND A.TP_ATENDIMENTO = 'I'
    AND A.DT_ALTA_MEDICA IS NOT NULL
    AND C.CD_SGRU_CID IN (SELECT
                            CD_SGRU_CID

                          FROM
                            DBAMV.SGRU_CID GC

                          WHERE
                            GC.DS_SGRU_CID LIKE ('%RENAL%')
                            OR GC.DS_SGRU_CID LIKE ('%DIABETE%')
                            OR GC.DS_SGRU_CID LIKE ('%HIPERTENSAO%')
                            OR GC.DS_SGRU_CID LIKE ('%CRONICO%')
                            OR GC.DS_SGRU_CID LIKE ('%CARDIOPATIA%')
                            OR GC.DS_SGRU_CID LIKE ('%RESPIRATORIA%')
                            OR GC.DS_SGRU_CID LIKE ('%HEPATICA%')
                            OR GC.DS_SGRU_CID LIKE ('%CANCER%')
                            OR GC.DS_SGRU_CID LIKE ('%TABAGISMO%')
                            OR GC.DS_SGRU_CID LIKE ('%ALCOOLISMO%')
                            OR GC.DS_SGRU_CID LIKE ('%CIRURGIAS%')
                            OR GC.DS_SGRU_CID LIKE ('%ALERGIAS%')
                            AND GC.SN_ATIVO = 'S')

    GROUP BY
      P.NM_PACIENTE,
      C.DS_CID,
      '('||P.NR_DDD_FONE||')'||P.NR_FONE,
      '('||P.NR_DDD_CELULAR||')'||P.NR_CELULAR

    HAVING Count(P.NM_PACIENTE) <> 1

    ORDER BY TOTAL DESC
   )