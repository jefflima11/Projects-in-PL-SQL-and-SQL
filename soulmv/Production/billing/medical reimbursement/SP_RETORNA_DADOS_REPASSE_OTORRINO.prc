CREATE OR REPLACE PROCEDURE sp_retorna_dados_repasse_otorrino(
    pCdPrestador IN NUMBER,
    pDataLancamento IN DATE,
    pFormattedDtLancamento IN VARCHAR2,

    pDadosCursorRepasse OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN pDadosCursorRepasse FOR
        SELECT DISTINCT
            pa.nm_prestador,
            'PC: ' || pf.cd_pro_fat || ', PAC: ' || p.nm_paciente || ', DATA: ' || TO_CHAR(irf.dt_lancamento, 'DD/MM/YYYY' )||' - TESTE' AS descricao,
            CASE
                WHEN pf.cd_pro_fat = 99990037 THEN 514.71
                WHEN pf.cd_pro_fat = 99990038 THEN 369.16
                WHEN pf.cd_pro_fat = 99990039 THEN 736.82
                WHEN pf.cd_pro_fat = 99990040 THEN 148.33
                WHEN pf.cd_pro_fat = 99990041 THEN 29.20
                WHEN pf.cd_pro_fat = 99990042 THEN 351.34
                WHEN pf.cd_pro_fat = 99990043 THEN 216.40
                WHEN pf.cd_pro_fat = 99990044 THEN 284.09
                WHEN pf.cd_pro_fat = 99990045 THEN 348.79
                WHEN pf.cd_pro_fat = 99990046 THEN 271.80
                WHEN pf.cd_pro_fat = 99990047 THEN 53.31
                WHEN pf.cd_pro_fat = 99990048 THEN 37.85
                WHEN pf.cd_pro_fat = 99990049 THEN 177.39
                WHEN pf.cd_pro_fat = 99990135 THEN 1105.98
                ELSE 0
            END AS vl_repasse
        FROM dbamv.reg_fat rf
        INNER JOIN dbamv.itreg_fat irf ON rf.cd_reg_fat = irf.cd_reg_fat
        INNER JOIN dbamv.remessa_fatura re ON rf.cd_remessa = re.cd_remessa
        INNER JOIN dbamv.fatura f ON re.cd_fatura = f.cd_fatura
        INNER JOIN dbamv.aviso_cirurgia ac ON rf.cd_atendimento = ac.cd_atendimento
        INNER JOIN dbamv.cirurgia_aviso ca ON ac.cd_aviso_cirurgia = ca.cd_aviso_cirurgia
        INNER JOIN dbamv.prestador_aviso pa ON ac.cd_aviso_cirurgia = pa.cd_aviso_cirurgia
        AND ca.cd_cirurgia_aviso = pa.cd_cirurgia_aviso
        INNER JOIN dbamv.atendime a ON rf.cd_atendimento = a.cd_atendimento
        INNER JOIN dbamv.paciente p ON a.cd_paciente = p.cd_paciente
        INNER JOIN dbamv.pro_fat pf ON irf.cd_pro_fat = pf.cd_pro_fat
        WHERE irf.cd_pro_fat IN (99990135, 99990037, 99990038, 99990039, 99990040, 99990041, 99990042, 99990043, 99990044, 99990045, 99990046, 99990047, 99990048, 99990049)
        AND pa.cd_ati_med = 01
        AND pa.cd_prestador = pCdPrestador
        AND TO_CHAR(irf.dt_lancamento, 'MM/YYYY') = pFormattedDtLancamento
        AND ca.sn_principal = 'S';
END sp_retorna_dados_repasse_otorrino;
/
