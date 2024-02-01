/*CREATED BY
NAME: JEFFERSON LIMA GONCALVES
CARGO: ANALISTA E DESENVOLVEDOR DE SISTEMAS JR
DATA: 01/02/2024
TITULO: VISITAS HOSPITALARES
DESCRICAO: 
FILTROS:

ÚLTIMA ATUALIZAÇÃO
RESPÓNSAVEL:
DATA:
MOTIVO:
DESCRIÇÃO:
*/

SELECT TOTAL_RETORNO
       ,DATA
       ,TOTAL_ATEND
       ,Trunc(TOTAL,2)TAXA

FROM    (SELECT  A1.TOTAL_RETORNO
                ,A1.DATA
                ,A2.TOTAL_ATEND
                ,((A1.TOTAL_RETORNO/A2.TOTAL_ATEND)*100)TOTAL

        FROM
                (SELECT  Count(TOTAL) TOTAL_RETORNO
                        ,To_Char(DT_ATENDIMENTO,'MM/YYYY') DATA
                        ,Count('') TOTAL_ATEND

                FROM (SELECT
                                P.NM_PACIENTE
                                ,Count(NM_PACIENTE) TOTAL
                                ,A.DT_ATENDIMENTO
                                ,C.DS_CID

                        FROM DBAMV.ATENDIME A
                                ,DBAMV.PACIENTE P
                                ,DBAMV.CID C

                        WHERE   A.CD_PACIENTE = P.CD_PACIENTE
                            AND   A.CD_CID = C.CD_CID

                            AND   A.TP_ATENDIMENTO = 'U'
                            AND   A.CD_ORI_ATE = '14'
                            AND   A.DT_ATENDIMENTO BETWEEN To_Date('01/01/2023','DD/MM/YYYY')
                                                    AND To_Date('31/07/2023','DD/MM/YYYY')

                        GROUP BY NM_PACIENTE,DT_ATENDIMENTO,DS_CID

                        HAVING Count(NM_PACIENTE)>1

                        ORDER BY TOTAL
                        )


                    GROUP BY To_Char(DT_ATENDIMENTO,'MM/YYYY')
                    ORDER BY DATA
                    )A1
            ,
                (SELECT  '' TOTAL_RETORNO
                        ,To_Char(DT_ATENDIMENTO,'MM/YYYY') DATA
                        ,Count(*) TOTAL_ATEND

                FROM    DBAMV.ATENDIME A

                WHERE   A.TP_ATENDIMENTO = 'U'
                  AND   A.CD_ORI_ATE = 14
                AND   A.DT_ATENDIMENTO BETWEEN To_Date('01/01/2023','DD/MM/YYYY')
                AND To_Date('31/07/2023','DD/MM/YYYY')

                GROUP BY To_Char(DT_ATENDIMENTO,'MM/YYYY')

                ORDER BY To_Char(DT_ATENDIMENTO,'MM/YYYY')
                )A2


        WHERE A1.DATA = A2.DATA

    )