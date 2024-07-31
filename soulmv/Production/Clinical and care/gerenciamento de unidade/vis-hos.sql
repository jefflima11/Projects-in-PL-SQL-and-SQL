SELECT	DT,
        SUM(QTD)TT,
	NM_PRESTADOR
        
FROM	(   SELECT  EXTRACT(DAY FROM DH_CRIACAO)||'/'||EXTRACT(MONTH FROM DH_CRIACAO)||'/'||EXTRACT(YEAR FROM DH_CRIACAO)DT,
                    P.NM_PRESTADOR,
                    COUNT(NM_PRESTADOR)QTD
                    
            FROM    DBAMV.PRE_MED PM,
                    DBAMV.PRESTADOR P
            WHERE   P.CD_PRESTADOR IN (147,359)
              AND   PM.CD_OBJETO = '2'
              AND   CD_UNID_INT IN (2,11)
              
              AND   PM.CD_PRESTADOR = P.CD_PRESTADOR
              AND   DT_PRE_MED BETWEEN TO_DATE('01112023','DDMMYYYY')
                                   AND TO_DATE('31122023','DDMMYYYY')
            GROUP
               BY   DH_CRIACAO,
                    CD_ATENDIMENTO,
                    P.NM_PRESTADOR
        )
GROUP
   BY   DT,
        NM_PRESTADOR
ORDER
   BY   DT
   ;

        
