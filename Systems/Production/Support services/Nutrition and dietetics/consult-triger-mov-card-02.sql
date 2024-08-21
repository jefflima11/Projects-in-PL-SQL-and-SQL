/*CREATED BY
NAME: ROMILSON SOARES
CARGO: COORDENADOR DE TI
DATA: 25/01/2024
TITULO: CRIAÇÃO DA TRIGGER DE INSERÇÃO
DESCRICAO: 
FILTROS:

ÚLTIMA ATUALIZAÇÃO
RESPONSÁVEL: 
CARGO: 
DATA:
MOTIVO:
DESCRIÇÃO: 
*/


CREATE OR REPLACE TRIGGER TG_TB_ITMOV_CADARPIO_UMS
   AFTER INSERT OR UPDATE 
   ON DBAMV.ITPRE_MED
   REFERENCING NEW AS NEW OLD AS OLD
BEGIN
INSERT INTO ITMOV_CARDAPIO ITMC ( ITMC.CD_ITMOV_CARDAPIO,
                                  ITMC.CD_MOV_CARDAPIO,
                                  ITMC.CD_OPCAO,
                                  ITMC.CD_PRATO,
                                  ITMC.QT_CARDAPIO,
                                  ITMC.SN_CONSUMO_EXTRA)

(SELECT SEQ_ITMOV_CARDAPIO.NEXTVAL AS ITMOV_CARDAPIO,
        MC2.CD_MOV_CARDAPIO,
        POC.CD_OPCAO,
        POC.CD_PRATO,
        1 AS QT_CADAPIO,
        'N' AS SN_CONSUMO_EXTRA

FROM
(SELECT MC.CD_ATENDIMENTO,
        MC.CD_MOV_CARDAPIO
FROM MOV_CARDAPIO MC
     LEFT JOIN
     ITMOV_CARDAPIO ITMC
     ON ITMC.CD_MOV_CARDAPIO = MC.CD_MOV_CARDAPIO
WHERE TRUNC(MC.DT_MOV_CARDAPIO) = TRUNC(SYSDATE)
    AND ITMC.CD_ITMOV_CARDAPIO IS NULL) MC2
    INNER JOIN
    (SELECT A.CD_ATENDIMENTO
    FROM ATENDIME A
    WHERE A.TP_ATENDIMENTO = 'I'
    AND A.CD_MULTI_EMPRESA = 1
    AND A.DT_ALTA IS NULL) A2
    ON MC2.CD_ATENDIMENTO = A2.CD_ATENDIMENTO
    CROSS JOIN 
    PRATO_OPCAO_CARDAPIO POC
WHERE POC.CD_OPCAO = 10);
END;