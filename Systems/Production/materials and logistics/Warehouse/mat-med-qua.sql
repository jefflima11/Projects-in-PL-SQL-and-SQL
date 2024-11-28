/*Create by Jefferson Lima
Report Name: Materias e medicamentos para qualidade
*/

SELECT 	P.CD_PRODUTO,
        P.DS_PRODUTO,
        E.DS_ESTOQUE,
        F.DT DT_ULT_MOV,
       (TRUNC(SYSDATE) - TRUNC(TO_TIMESTAMP(F.DT))) DIAS,
        DECODE(P.SN_PADRONIZADO, 'S', 'SIM', 'N', 'NAO') SN_PADRONIZADO
				,DECODE(P.SN_BLOQUEIO_DE_COMPRA, 'S', 'SIM', 'N', 'NAO') SN_BLOQUEIO_DE_COMPRA
				,DECODE(P.SN_PSCOTROPICO, 'S', 'SIM', 'N', 'NAO') SN_PSCOTROPICO,
				ES.DS_ESPECIE
FROM   (SELECT  DISTINCT
                P.CD_PRODUTO,
                MAX(IME.CD_MVTO_ESTOQUE)CD_MVTO_ESTOQUE,
                Max(IME.DH_MVTO_ESTOQUE)DT
        FROM    DBAMV.MVTO_ESTOQUE ME,
                DBAMV.ITMVTO_ESTOQUE IME,
                DBAMV.PRODUTO P

        WHERE	ME.CD_MVTO_ESTOQUE = IME.CD_MVTO_ESTOQUE
          AND 	IME.CD_PRODUTO = P.CD_PRODUTO
          AND   P.CD_ESPECIE IN (1,2,3)
          AND   P.SN_MOVIMENTACAO = 'S'
	GROUP
    	   BY   P.CD_PRODUTO
	ORDER
	   BY   P.CD_PRODUTO)F,
        DBAMV.PRODUTO P,
        DBAMV.MVTO_ESTOQUE ME,
        DBAMV.ESTOQUE E,
        DBAMV.EST_PRO EP,
				DBAMV.ESPECIE ES
WHERE		F.CD_PRODUTO = P.CD_PRODUTO
  AND 	F.CD_MVTO_ESTOQUE = ME.CD_MVTO_ESTOQUE
  AND   ME.CD_ESTOQUE = E.CD_ESTOQUE
  AND		E.CD_ESTOQUE = EP.CD_ESTOQUE
  AND   P.CD_PRODUTO = EP.CD_PRODUTO
	AND 	P.CD_ESPECIE = ES.CD_ESPECIE
	AND		P.SN_MESTRE = 'N'
  AND   E.DS_ESTOQUE LIKE ('%%')
  AND 	EP.QT_ESTOQUE_ATUAL = 0
	AND 	P.SN_MOVIMENTACAO = 'S'
	ORDER BY 3,1
;