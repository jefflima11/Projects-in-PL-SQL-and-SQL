SELECT  PACIENTES.MESANO,
		ROUND(NVL(QTDE_PACDIA,0)/DECODE(NVL(QTDE_SAIDASDIA,0),0,1,QTDE_SAIDASDIA),2) PER
FROM    (
		SELECT  TO_CHAR(ATENDIME.DT_ALTA,'mmyyyy') MESANO,
				COUNT(*) QTDE_SAIDASDIA
		FROM    DBAMV.MOV_INT
				INNER JOIN DBAMV.LEITO 
					ON MOV_INT.CD_LEITO = LEITO.CD_LEITO
				INNER JOIN DBAMV.TIP_ACOM 
					ON LEITO.CD_TIP_ACOM = TIP_ACOM.CD_TIP_ACOM
                INNER JOIN DBAMV.ATENDIME 
                    ON MOV_INT.CD_ATENDIMENTO = ATENDIME.CD_ATENDIMENTO,
                DBAMV.UNID_INT UI
        WHERE   LEITO.CD_UNID_INT = UI.CD_UNID_INT
          AND   MOV_INT.TP_MOV IN ('I','O','F') -- INTERNAÇÃO, TRANSFERÊNCIA E PACIENTES COM INFECÇÃO
          AND   TP_ACOMODACAO NOT IN ('B', 'H') -- BERÇÁRIO E HOSPITAL DIA
          AND   LEITO.SN_EXTRA = 'N'
          AND   ATENDIME.DT_ALTA >= ADD_MONTHS(TRUNC(SYSDATE,'mm'),-12)
          AND   UI.DS_UNID_INT = 'POSTO I'
        GROUP BY  TO_CHAR(ATENDIME.DT_ALTA,'mmyyyy')

       )SAIDAS
           RIGHT JOIN  (
                       SELECT  TO_CHAR(CONTADOR.DATA,'MMYYYY') MESANO,
                               COUNT(*) QTDE_PACDIA
                       FROM    DBAMV.MOV_INT
                                   INNER JOIN DBAMV.LEITO 
                                       ON MOV_INT.CD_LEITO = LEITO.CD_LEITO
                                   INNER JOIN DBAMV.TIP_ACOM 
                                       ON LEITO.CD_TIP_ACOM = TIP_ACOM.CD_TIP_ACOM
                                   INNER JOIN DBAMV.ATENDIME 
                                       ON MOV_INT.CD_ATENDIMENTO = ATENDIME.CD_ATENDIMENTO,
                               (SELECT ADD_MONTHS(TRUNC(SYSDATE,'mm'),-12) + ROWNUM -1 DATA
                                 FROM ALL_OBJECTS
                                WHERE ADD_MONTHS(TRUNC(SYSDATE,'mm'),-12) + ROWNUM -1 < SYSDATE
                               )CONTADOR,
                               DBAMV.UNID_INT UI
                        WHERE  LEITO.CD_UNID_INT = UI.CD_UNID_INT
                          AND  DATA BETWEEN  TRUNC(MOV_INT.DT_MOV_INT) 
                                        AND  NVL(DT_LIB_MOV - 1,SYSDATE) -- CONSIDERA PACIENTES ÀS 00:00 + ENTRADAS DO DIA - ALTAS DO DIA
                          AND  MOV_INT.TP_MOV IN ('I','O','F') -- INTERNAÇÃO, TRANSFERÊNCIA E PACIENTES COM INFECÇÃO
                          AND  TP_ACOMODACAO NOT IN ('B', 'H') -- BERÇÁRIO E HOSPITAL DIA
                          AND  LEITO.SN_EXTRA = 'N'
                          AND  UI.DS_UNID_INT = 'POSTO I'
                        GROUP BY TO_CHAR(CONTADOR.DATA,'MMYYYY')
                       )PACIENTES
        ON SAIDAS.MESANO = PACIENTES.MESANO
WHERE PACIENTES.MESANO LIKE ('042024')
ORDER BY PACIENTES.MESANO 
