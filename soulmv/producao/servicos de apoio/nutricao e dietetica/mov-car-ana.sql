/*CREATED BY
NAME: ROMILSON SOARES
CARGO: ANALISTA E DESENVOLVEDOR DE SISTEMAS SENIOR
DATA: 18/03/2024
TITULO: MOVIMENTAÇÃO DE CARDAPIO ANALITICO
DESCRICAO: 
FILTROS:

ÚLTIMA ATUALIZAÇÃO
RESPÓNSAVEL:
DATA:
MOTIVO:
DESCRIÇÃO:
*/

SELECT  NM_FUNC,
        CD_FUNC,
        SUM(DESJEJUM) DESJEJUM,
        SUM(ALMOCO) ALMOCO,
        SUM(LANCHE) LANCHE,
        SUM(JANTAR) JANTAR,
        SUM(CEIA) CEIA
FROM   (SELECT  *
        FROM   (SELECT  FU4.NM_FUNC,
                        FU4.CD_FUNC,
                        ITM.CD_PRATO,
                        ITM.QT_CARDAPIO
                 FROM   MOV_CARDAPIO MC
                        INNER JOIN ITMOV_CARDAPIO ITM
                            ON ITM.CD_MOV_CARDAPIO = MC.CD_MOV_CARDAPIO
                        INNER JOIN OPCAO_CARDAPIO OPC
                            ON OPC.CD_OPCAO = ITM.CD_OPCAO
                        INNER JOIN PRATO P
                            ON P.CD_PRATO = ITM.CD_PRATO
                        INNER JOIN OCORRENCIA_DIETA OD
                            ON OD.CD_MOV_CARDAPIO = MC.CD_MOV_CARDAPIO
                        INNER JOIN (SELECT  FU2.NM_FUNC,
                                            FU2.CD_FUNC
                                    FROM FUNCIONARIO FU2
                                    WHERE FU2.SN_ATIVO = 'S'
                                    AND FU2.NM_FUNC IN (SELECT   US.NM_USUARIO
                                                        FROM    PRESTADOR PR
                                                                INNER JOIN DBASGU.USUARIOS US
                                                                    ON US.CD_PRESTADOR = PR.CD_PRESTADOR
                                                        WHERE   PR.CD_TIP_PRESTA = 8)
                                   ) FU4
                            ON FU4.CD_FUNC = MC.CD_FUNC
                WHERE   TRUNC(MC.DT_MOV_CARDAPIO) BETWEEN TO_DATE('01/01/2024','DD/MM/YYYY') AND TO_DATE('31/01/2024','DD/MM/YYYY')
                  AND   FU4.CD_FUNC IN ({V_MED_AUX})
                  AND   {V_FULL}
			   ) REFEICAO

               PIVOT
               (SUM(QT_CARDAPIO)
               FOR CD_PRATO IN ('96' DESJEJUM,
                                '93' ALMOCO,
                                '95' LANCHE,
                                '94' JANTAR,
                                '97' CEIA
                                )
               )
       ) Y
GROUP BY	NM_FUNC,
            CD_FUNC

ORDER BY    1 ASC
;