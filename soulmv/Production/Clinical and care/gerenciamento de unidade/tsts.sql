SELECT 
        C.CD_CON_REC                            CD_CON_REC
        ,C.DS_CON_REC							DESCRICAO_CONTAS_RECEBER
        ,C.VL_PREVISTO							VALOR_CONTAS_RECEBER
        ,C.DT_EMISSAO							DATA_EMISSAO
        ,C.NM_CLIENTE							NOME_DO_CLIENTE
        ,DECODE(C.TP_CON_REC,'C','Convenio'
							,'P','Paciente'
							,'F','Funcionario'
							,'A','Administradora de cartao de credito'
							,'D','Diversos'
							,'M','Mensalidade'
							,'R','Farmacia')    TP_CONTA
        ,I.CD_ITCON_REC							COD_PARC
        ,I.NR_PARCELA							N_PARCELA
        ,I.DT_VENCIMENTO						DT_VENCIMENTO
        ,I.DT_PREVISTA_RECEBIMENTO 				DT_PREV_RECEB
        ,I.VL_DUPLICATA							VL_PARCELA
        ,I.VL_SOMA_RECEBIDO						VL_RECEBIDO
        ,(NVL(I.VL_DUPLICATA,0) - NVL(I.VL_SOMA_RECEBIDO,0)) VALOR_DEVIDO
        ,DECODE(I.TP_QUITACAO,'V','PREVISTO'
							 ,'C','COMPROMETIDO'
							 ,'P','PARCIALMENTE QUITADO'
							 ,'Q','QUITADO'
							 ,'R','PROTESTADO'
							 ,'L','CANCELADO'
							 ,'G','QUITADO COM GLOSA') TIPO_QUITACAO
		
FROM DBAMV.CON_REC      C
    ,DBAMV.ITCON_REC    I
	
WHERE I.CD_CON_REC = C.CD_CON_REC
/*  AND I.CD_CON_REC_AGRUP IS NULL*/
  /*AND C.CD_PREVISAO IS NULL*/
/*  AND (I.VL_DUPLICATA - NVL(I.VL_SOMA_RECEBIDO,0)) > 0*/
  /*AND I.TP_QUITACAO NOT IN ('Q','L','R')*/
  AND C.CD_MULTI_EMPRESA = 1
  AND C.DT_LANCAMENTO BETWEEN TO_DATE('01012024','DDMMYYYY') AND TO_DATE('31032024','DDMMYYYY')
  
ORDER BY 1
