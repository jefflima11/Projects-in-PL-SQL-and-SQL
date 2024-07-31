/*CREATED BY
NAME: JEFFERSON LIMA GONCALVES
CARGO: ANALISTA E DESENVOLVEDOR DE SISTEMAS JR
DATA: 17/11/2023
TITULO: MIVIMENTAÇÃO DE CARDAPIO PARA PACIENTE
DESCRICAO: MOVIMENTAÇÃO DE CARDAPIO PARA FUNCIONARIOS POR SETOR, POR TIPO DE REFEIÇÕES E POR DIA.
FILTROS:

#TIPO DE CARDAPIO = (A)ACOMPANHANTE
#INTERVALO DE DATAS = MÊS E ANO ATUAL  

ÚLTIMA ATUALIZAÇÃO
RESPONSÁVEL: JEFFERSON LIMA GONÇALVES
CARGO: ANALISTA E DESENVOLVEDOR DE SISTEMAS JR
DATA: 07/02/2024
MOTIVO: MELHORIA DE DESEMPENHO
DESCRIÇÃO: TENTATIVA DE MELHORAR O DESEMPENHO DE RETORNO DE INFORMAÇÕES
*/
 
SELECT  S.CD_SETOR,
        TP_CARDAPIO,
        OC.CD_OPCAO,
		P.CD_PRATO,
        SUM(IMC.QT_CARDAPIO)QTD,
        CASE
          WHEN  S.CD_SETOR = '345'
            THEN  'MOTORISTA'
          WHEN  S.CD_SETOR IS NOT NULL
            THEN  S.NM_SETOR
        END  NM_SETOR,
        TO_CHAR(DT_MOV_CARDAPIO,'DD') DT_MOV,
        CASE
          WHEN P.DS_PRATO = 'DESJEJUM'
            THEN '01 - DESJEJUM'
          WHEN P.DS_PRATO = 'ALMOCO'
            THEN '02 - ALMOCO'  
          WHEN P.DS_PRATO = 'ALMOCO' AND OC.CD_OPCAO = 171
            THEN '03 - ALMOCO SOPA'
          WHEN P.DS_PRATO = 'LANCHE'
            THEN '04 - LANCHE'  
          WHEN P.DS_PRATO = 'JANTAR' 
            THEN '05 - JANTAR'
          WHEN P.DS_PRATO = 'JANTAR' AND OC.CD_OPCAO = 171
            THEN '06 - JANTAR SOPA' 
          WHEN P.DS_PRATO = 'CEIA' 
            THEN '07 - CEIA'  
          WHEN P.DS_PRATO IS NOT NULL 
            THEN P.DS_PRATO    
          END DS_PRATO,
		 (MC.DT_MOV_CARDAPIO,'MM/YYYY') 
FROM   (SELECT  CD_MOV_CARDAPIO,
                DT_MOV_CARDAPIO,
                CD_SETOR,
                CD_TIPO_REFEICAO,
                TP_CARDAPIO,
                CD_FUNC
        FROM    DBAMV.MOV_CARDAPIO MC
        WHERE   DT_MOV_CARDAPIO BETWEEN TO_DATE('072023','MMYYYY')
                                    AND TO_DATE(SYSDATE+1)
          AND   TP_CARDAPIO IN ('A','P','S','F')
          AND   CD_TIPO_REFEICAO = '11'
          AND   CD_MULTI_EMPRESA = '1'
       ) MC,
       (SELECT  CD_PRATO,
                DS_PRATO
        FROM    DBAMV.PRATO
        WHERE   CD_PRATO IN (93,94,95,96,97,98,99,100,101,102)
       )P ,
        DBAMV.TIPO_REFEICAO TR,
        DBAMV.SETOR S,
        DBAMV.ITMOV_CARDAPIO IMC,        
        DBAMV.OPCAO_CARDAPIO OC,
				DBAMV.OCORRENCIA_DIETA OD
WHERE   MC.CD_SETOR = S.CD_SETOR
  AND   MC.CD_TIPO_REFEICAO = TR.CD_TIPO_REFEICAO
  AND   MC.CD_MOV_CARDAPIO = IMC.CD_MOV_CARDAPIO
  AND   IMC.CD_OPCAO = OC.CD_OPCAO
  AND   IMC.CD_PRATO = P.CD_PRATO
  AND 	IMC.CD_MOV_CARDAPIO = OD.CD_MOV_CARDAPIO
  AND     MC.DT_MOV_CARDAPIO > TO_DATE('2024-01-01','YYYY-MM-DD')
  AND   TO_CHAR(MC.DT_MOV_CARDAPIO,'MMYYYY') = '032024' 
--   AND   P.CD_PRATO = 102
--   AND   S.CD_SETOR=58
--   AND   TO_CHAR(DT_MOV_CARDAPIO,'DD') = 14 
GROUP
   BY   S.NM_SETOR,
        S.CD_SETOR,
        TO_CHAR(DT_MOV_CARDAPIO,'DD'),
        P.DS_PRATO,
        TP_CARDAPIO,
        IMC.CD_OPCAO,
		P.CD_PRATO;
