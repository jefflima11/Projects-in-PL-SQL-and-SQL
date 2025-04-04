SELECT 
		distinct
    a.cd_atendimento,
    p.nm_paciente,
    a.dt_atendimento,
    a.dt_alta,
    ipd.dt_realizacao,
    ipd.dt_recebimento,
    CASE
        WHEN ipd.cd_reg_fat IS NOT NULL THEN rf.cd_reg_fat
        WHEN ipd.cd_reg_amb IS NOT NULL THEN ra.cd_reg_amb
        ELSE NULL
    END AS cd_conta,
    DECODE(a.tp_atendimento, 'U', 'URGENCIA', 'I', 'INTERNACAO') AS tp_atendimento,
    CASE
        WHEN ipd.cd_reg_fat IS NOT NULL THEN rf.dt_fechamento
        WHEN ipd.cd_reg_amb IS NOT NULL THEN ra.dt_fechamento
        ELSE NULL
    END AS dt_fechamento,
    CASE
        WHEN ipd.cd_reg_fat IS NOT NULL THEN rf.vl_total_conta
        WHEN ipd.cd_reg_amb IS NOT NULL THEN ra.vl_total_conta
        ELSE NULL
    END AS vl_total,
    CASE
        WHEN ipd.cd_reg_fat IS NOT NULL THEN rf.nm_usuario_fechou
        WHEN ipd.cd_reg_amb IS NOT NULL THEN ra.nm_usuario_fechou
        ELSE NULL
    END AS nm_fechamento,
		ipd.dt_recebimento,
		rf.dt_fechamento,
		ra.dt_fechamento,
		ceil(ipd.DT_RECEBIMENTO - NVL(
    CASE
        WHEN ipd.cd_reg_fat IS NOT NULL THEN rf.dt_fechamento
        WHEN ipd.cd_reg_amb IS NOT NULL THEN ra.dt_fechamento
        ELSE NULL
    END, ipd.dt_realizacao)) AS qt_dias
FROM dbamv.atendime a
    INNER JOIN dbamv.paciente p ON a.cd_paciente = p.cd_paciente
    INNER JOIN dbamv.it_protocolo_doc ipd ON a.cd_atendimento = ipd.cd_atendimento
    LEFT JOIN dbamv.reg_fat rf ON ipd.cd_reg_fat = rf.cd_reg_fat
    LEFT JOIN (
        SELECT DISTINCT 
            ra.cd_reg_amb, 
            ia.dt_fechamento, 
            ra.vl_total_conta, 
            ia.nm_usuario_fechou
        FROM dbamv.reg_amb ra
        INNER JOIN dbamv.itreg_amb ia ON ra.cd_reg_amb = ia.cd_reg_amb
		where nm_usuario_fechou is not null
    ) ra ON ipd.cd_reg_amb = ra.cd_reg_amb
WHERE 
    a.dt_atendimento BETWEEN TO_DATE('01/07/2024','dd/mm/yyyy') AND TO_DATE('31/07/2024','dd/mm/yyyy')
