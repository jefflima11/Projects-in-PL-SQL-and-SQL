/*CREATED BY
NAME: JEFFERSON LIMA GONCALVES
CARGO: ANALISTA E DESENVOLVEDOR DE SISTEMAS JR
DATA: 25/01/2024
TITULO: AVALIAÇÃO E PARECER X FATURAMENTO (INTERNAÇÃO)
DESCRICAO: 
FILTROS:

ULTIMA ATUALIZAÇÃO
RESPONSAVEL:
DATA:
MOTIVO:
DESCRIÇÃO:
*/

SELECT  Count(*)TOTAL
       ,DATA

FROM (SELECT  P.NM_PRESTADOR
       ,To_Char(A.DT_ATENDIMENTO,'MM/YYYY') DATA

FROM    DBAMV.ATENDIME A
       ,DBAMV.PRESTADOR P

WHERE   A.CD_PRESTADOR = P.CD_PRESTADOR

  AND   A.DT_ATENDIMENTO BETWEEN To_Date('01012023','DDMMYYYY')
                             AND To_Date('31072023','DDMMYYYY')
  AND   A.TP_ATENDIMENTO = 'U'
  AND   A.CD_ORI_ATE = 14

GROUP BY P.NM_PRESTADOR,To_Char(A.DT_ATENDIMENTO,'MM/YYYY')
)F1

GROUP BY DATA
ORDER BY DATA