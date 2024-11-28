CREATE OR REPLACE PROCEDURE SP_GERA_REP_HUMS(
    PCD_PRESTADOR IN NUMBER,
    PDT_COMPETENCIA IN VARCHAR2
) IS
    vCdRepasse NUMBER;
    vNmPrestador VARCHAR2(100);
    vDescricao VARCHAR2(400);
    vCdProFat NUMBER;
    vRowNum NUMBER;
    vVlRepasse NUMBER;
    vCdPrestadorOrig NUMBER := PCD_PRESTADOR;
    vDtCompetencia VARCHAR2(5) := PDT_COMPETENCIA;

    CURSOR nvRepasse IS
        SELECT DISTINCT
            PA.NM_PRESTADOR,
            'PC: ' || PF.CD_PRO_FAT || ' , PAC: ' || P.NM_PACIENTE || ' , DATA: ' || TO_CHAR(IRF.DT_LANCAMENTO, 'DD/MM/YYYY') DESCRICAO,
            PF.CD_PRO_FAT,
            ROWNUM TST,
            PA.CD_PRESTADOR
        FROM DBAMV.REG_FAT RF
            INNER JOIN DBAMV.ITREG_FAT IRF ON RF.CD_REG_FAT = IRF.CD_REG_FAT
            INNER JOIN DBAMV.REMESSA_FATURA RE ON RF.CD_REMESSA = RE.CD_REMESSA
            INNER JOIN DBAMV.FATURA F ON RE.CD_FATURA = F.CD_FATURA
            INNER JOIN DBAMV.AVISO_CIRURGIA AC ON RF.CD_ATENDIMENTO = AC.CD_ATENDIMENTO
            INNER JOIN DBAMV.CIRURGIA_AVISO CA ON AC.CD_AVISO_CIRURGIA = CA.CD_AVISO_CIRURGIA
            INNER JOIN DBAMV.PRESTADOR_AVISO PA ON AC.CD_AVISO_CIRURGIA = PA.CD_AVISO_CIRURGIA
                AND CA.CD_CIRURGIA_AVISO = PA.CD_CIRURGIA_AVISO
            INNER JOIN DBAMV.ATENDIME A ON RF.CD_ATENDIMENTO = A.CD_ATENDIMENTO
            INNER JOIN DBAMV.PACIENTE P ON A.CD_PACIENTE = P.CD_PACIENTE
            INNER JOIN DBAMV.PRO_FAT PF ON IRF.CD_PRO_FAT = PF.CD_PRO_FAT
        WHERE IRF.CD_PRO_FAT IN (99990135,99990037,99990038,99990039,99990040,99990041,99990042,99990043,99990044,99990045,99990046,99990047,99990048,99990049)
          AND PA.CD_ATI_MED = 01
          AND PA.CD_PRESTADOR = vCdPrestadorOrig
          AND TO_CHAR(IRF.DT_LANCAMENTO, 'MM/YY') = vDtCompetencia
          AND CA.SN_PRINCIPAL = 'S';

BEGIN
    IF vCdPrestadorOrig IN (245, 388) THEN
        OPEN nvRepasse;
        LOOP
            FETCH nvRepasse INTO vNmPrestador, vDescricao, vCdProFat, vRowNum, vCdPrestadorOrig;
            EXIT WHEN nvRepasse%NOTFOUND;

            vVlRepasse := CASE
                WHEN vCdProFat = 99990037 THEN 514.71
                WHEN vCdProFat = 99990038 THEN 369.16
                WHEN vCdProFat = 99990039 THEN 736.82
                WHEN vCdProFat = 99990040 THEN 148.33
                WHEN vCdProFat = 99990041 THEN 29.20
                WHEN vCdProFat = 99990042 THEN 351.34
                WHEN vCdProFat = 99990043 THEN 216.40
                WHEN vCdProFat = 99990044 THEN 284.09
                WHEN vCdProFat = 99990045 THEN 348.79
                WHEN vCdProFat = 99990046 THEN 271.80
                WHEN vCdProFat = 99990047 THEN 53.31
                WHEN vCdProFat = 99990048 THEN 37.85
                WHEN vCdProFat = 99990049 THEN 177.39
                WHEN vCdProFat = 99990135 THEN 1105.98
                ELSE 0
            END;

            INSERT INTO DBAMV.REPASSE(
                CD_REPASSE,
                DT_COMPETENCIA,
                DT_REPASSE,
                DS_REPASSE,
                TP_REPASSE,
                CD_MULTI_EMPRESA,
                SN_CONTABILIZAR
            ) VALUES(
                SEQ_REPASSE.NEXTVAL,
                TO_DATE('01/07/2024', 'DD/MM/YYYY'),
                TO_DATE('10/07/2024', 'DD/MM/YYYY'),
                vDescricao,
                'M',
                1,
                'N'
            );

            vCdRepasse := SEQ_REPASSE.CURRVAL;

            INSERT INTO DBAMV.REPASSE_PRESTADOR(
                CD_REPASSE,
                CD_PRESTADOR,
                VL_REPASSE,
                CD_PRESTADOR_REPASSE,
                CD_SETOR
            ) VALUES (
                vCdRepasse,
                vCdPrestadorOrig,
                vVlRepasse,
                vCdPrestadorOrig,
                37
            );

            COMMIT;
        END LOOP;
        CLOSE nvRepasse;

        /*DELETE DBAMV.REPASSE
        WHERE CD_REPASSE = vCdRepasse;*/
    END IF;

END SP_GERA_REP_HUMS;
/
