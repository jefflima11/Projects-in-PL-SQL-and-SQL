CREATE OR REPLACE TRIGGER TRG_REPASSE_AUTOMATICO_HUMS
  AFTER INSERT ON DBAMV.LOG_REPASSE_HUMS
  FOR EACH ROW
  WHEN (NEW.DS_REPASSE = 'RPAOHUMS')
DECLARE 
    vCdRepasse NUMBER;
    vNmPrestador VARCHAR2(100);
    vCdProFat NUMBER;
    vDescricao VARCHAR2(400);
    vVlRepasse NUMBER;
    vRowNum NUMBER;
    vCdPrestador NUMBER;

    CURSOR nvRepasse IS
        SELECT DISTINCT
                PA.NM_PRESTADOR,
                'PC: ' || PF.CD_PRO_FAT || ' , PAC: ' || P.NM_PACIENTE || ' , DATA: ' || TO_CHAR(IRF.DT_LANCAMENTO, 'DD/MM/YYYY') AS DESCRICAO,
                PF.CD_PRO_FAT,
                ROWNUM AS TST,
                PA.CD_PRESTADOR
        FROM    DBAMV.REG_FAT RF
                INNER JOIN DBAMV.ITREG_FAT IRF ON RF.CD_REG_FAT = IRF.CD_REG_FAT
                INNER JOIN DBAMV.REMESSA_FATURA RE ON RF.CD_REMESSA = RE.CD_REMESSA
                INNER JOIN DBAMV.FATURA F ON RE.CD_FATURA = F.CD_FATURA
                INNER JOIN DBAMV.AVISO_CIRURGIA AC ON RF.CD_ATENDIMENTO = AC.CD_ATENDIMENTO
                INNER JOIN DBAMV.CIRURGIA_AVISO CA ON AC.CD_AVISO_CIRURGIA = CA.CD_AVISO_CIRURGIA
                INNER JOIN DBAMV.PRESTADOR_AVISO PA ON AC.CD_AVISO_CIRURGIA = PA.CD_AVISO_CIRURGIA AND CA.CD_CIRURGIA_AVISO = PA.CD_CIRURGIA_AVISO
                INNER JOIN DBAMV.ATENDIME A ON RF.CD_ATENDIMENTO = A.CD_ATENDIMENTO
                INNER JOIN DBAMV.PACIENTE P ON A.CD_PACIENTE = P.CD_PACIENTE
                INNER JOIN DBAMV.PRO_FAT PF ON IRF.CD_PRO_FAT = PF.CD_PRO_FAT
        WHERE   IRF.CD_PRO_FAT IN (99990135,99990037,99990038,99990039,99990040,99990041,99990042,99990043,99990044,99990045,99990046,99990047,99990048,99990049)
            AND PA.CD_ATI_MED = 01
            AND PA.CD_PRESTADOR = 245
            AND TO_CHAR(IRF.DT_LANCAMENTO, 'MM/YYYY') = '06/2024'
            AND CA.SN_PRINCIPAL = 'S'
        ORDER BY 4;
BEGIN
    OPEN nvRepasse;
    LOOP
        FETCH nvRepasse INTO vNmPrestador, vDescricao, vCdProFat, vRowNum, vCdPrestador;
        EXIT WHEN nvRepasse%NOTFOUND;

        vCdRepasse := SEQ_REPASSE.NEXTVAL;
        INSERT INTO DBAMV.REPASSE(
            CD_REPASSE,
            DT_COMPETENCIA,
            DT_REPASSE,
            DS_REPASSE,
            TP_REPASSE,
            CD_MULTI_EMPRESA,
            SN_CONTABILIZAR
        ) VALUES (
            vCdRepasse,
            SYSDATE,
            SYSDATE,
            vDescricao,
            'M',
            1,
            'N'
        );

        INSERT INTO DBAMV.REPASSE_PRESTADOR(
            CD_REPASSE,
            CD_PRESTADOR,
            VL_REPASSE,
            CD_PRESTADOR_REPASSE,
            CD_SETOR
        ) VALUES (
            vCdRepasse,
            vCdPrestador,
            vVlRepasse,
            vCdPrestador,
            37
        );
    END LOOP;

    CLOSE nvRepasse;    

END;
/
