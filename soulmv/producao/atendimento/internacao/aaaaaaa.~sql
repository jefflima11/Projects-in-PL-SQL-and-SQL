SELECT    SUM(QTD_CIR)QTD_CIR_DIA,
          DIA_SEMAN,
		  SUM(TT_CIR)TOT_CIR_SEM,
		  ROUND((SUM(QTD_CIR)*100)/SUM(TT_CIR),2) PERC
FROM (

SELECT    0 QTD_CIR,
          F2.DIA_SEMANA DIA_SEMAN,
          F1.TT_CIR

FROM     (SELECT  0 QTD_CIR,
                  SUM(COUNT(CD_CIR))TT_CIR
                  
            FROM      (SELECT    C.DS_CIRURGIA CIR,
                                 C.CD_CIRURGIA CD_CIR,
                                 DECODE(TO_CHAR(TO_DATE(DT_REALIZACAO,'DD/MM/YY'),'D'),1,'DOMINGO'
                                                                                       ,2,'SEGUNDA'
                                                                                       ,3,'TERCA'
                                                                                       ,4,'QUARTA'
                                                                                       ,5,'QUINTA'
                                                                                       ,6,'SEXTA'
                                                                                       ,7,'SABADO'
                                                                                        )DIA_SEMANA
                        FROM      DBAMV.AVISO_CIRURGIA AC,
                              DBAMV.CIRURGIA_AVISO CA,
                              DBAMV.CIRURGIA C

                        WHERE     AC.CD_AVISO_CIRURGIA = CA.CD_AVISO_CIRURGIA
                          AND     CA.CD_CIRURGIA = C.CD_CIRURGIA
                          AND     TO_CHAR(AC.DT_REALIZACAO,'MMYYYY') = ('022024')

                        ORDER BY  TO_DATE(DT_REALIZACAO,'DD/MM/YY')  
                       )

            GROUP BY  DIA_SEMANA)F1,
            
           (SELECT CASE
               WHEN LEVEL = 1 THEN 'DOMINGO'
               WHEN LEVEL = 2 THEN 'SEGUNDA'
               WHEN LEVEL = 3 THEN 'TERCA'
               WHEN LEVEL = 4 THEN 'QUARTA'
               WHEN LEVEL = 5 THEN 'QUINTA'
               WHEN LEVEL = 6 THEN 'SEXTA'
               WHEN LEVEL = 7 THEN 'SABADO'
               ELSE NULL
             END AS DIA_SEMANA,
             0 QTD_CIR
            FROM DUAL
            CONNECT BY LEVEL <= 7
		   )F2
		   
WHERE    F1.QTD_CIR = F2.QTD_CIR        

UNION

SELECT    COUNT(CD_CIR) QTD_CIR,
          DIA_SEMAN,
          0 TT_CIR
		  
FROM      (
SELECT    C.DS_CIRURGIA CIR,
          C.CD_CIRURGIA CD_CIR,
		  DECODE(TO_CHAR(TO_DATE(DT_REALIZACAO,'DD/MM/YY'),'D'),1,'DOMINGO'
		                                                       ,2,'SEGUNDA'
															   ,3,'TERCA'
															   ,4,'QUARTA'
															   ,5,'QUINTA'
															   ,6,'SEXTA'
															   ,7,'SABADO'
		                                                        )DIA_SEMAN
FROM      DBAMV.AVISO_CIRURGIA AC,
          DBAMV.CIRURGIA_AVISO CA,
		  DBAMV.CIRURGIA C

WHERE     AC.CD_AVISO_CIRURGIA = CA.CD_AVISO_CIRURGIA
  AND     CA.CD_CIRURGIA = C.CD_CIRURGIA
  AND     TO_CHAR(AC.DT_REALIZACAO,'MMYYYY') = ('022024')

ORDER BY  TO_DATE(DT_REALIZACAO,'DD/MM/YY')  )

GROUP BY  DIA_SEMAN)

GROUP BY DIA_SEMAN
