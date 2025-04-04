--CREATED BY JEFFERSON LIMA

SELECT
  PACIENTE,
  DATA,
  DATA_MOUTH,
  DATA_YEAR,
  IDADE,
  IDADE_YEAR,
  FONE_C,
  CELULAR_C,
  NM_CONVENIO,
  DOENCA,
  Count(PACIENTE) TOTAL

FROM
    (SELECT
      P.NM_PACIENTE PACIENTE,
      To_Char(A.DT_ATENDIMENTO, 'MM/YYYY') DATA,
      To_Char(A.DT_ATENDIMENTO, 'MM') DATA_MOUTH,
      To_Char(A.DT_ATENDIMENTO, 'YYYY') DATA_YEAR,
      FN_IDADE(p.dt_nascimento, lower('a ') || 'A, ' || lower('m ') || 'M' || ' e ' || lower('d ') || 'D',sysdate) AS IDADE,
      FN_IDADE(p.dt_nascimento, lower('a '),sysdate) AS IDADE_YEAR,
      '('||P.NR_DDD_FONE||')'||P.NR_FONE FONE_C,
      '('||P.NR_DDD_CELULAR||')'||P.NR_CELULAR CELULAR_C,
      CON.NM_CONVENIO,
      F1.DOENCA

     FROM
         DBAMV.ATENDIME A,
         DBAMV.PACIENTE P,
         DBAMV.CONVENIO CON,
         (SELECT
            CPF,
            BENEFICIARIO,
            Upper(BENEFICIARIO) BENEFICIARIO,
            Upper(DOENCA) DOENCA

          FROM
            INFOMED.HG_V_PFL_EPIDEMIOLOGICO@INFOMED HGI

          GROUP BY
            CPF,
            BENEFICIARIO,
            BENEFICIARIO,
          DOENCA
         )F1

     WHERE
            A.CD_PACIENTE = P.CD_PACIENTE
      AND   A.CD_CONVENIO = CON.CD_CONVENIO
      AND   P.NR_CPF = F1.CPF

      AND   A.TP_ATENDIMENTO = 'U'
      AND   A.CD_CONVENIO = 3
      AND   A.CD_MULTI_EMPRESA = 1
      AND   A.CD_ORI_ATE = 14
      AND   A.DT_ATENDIMENTO BETWEEN To_Date('01/09/2022','DD/MM/YYYY')
                                 AND To_Date('31/07/2023','DD/MM/YYYY')

      ORDER BY DATA
    )
    
WHERE IDADE_YEAR >= '18'

GROUP BY
  PACIENTE,
  DATA,
  IDADE,
  IDADE_YEAR,
  FONE_C,
  CELULAR_C,
  NM_CONVENIO,
  DOENCA,
  DATA_MOUTH,
  DATA_YEAR

HAVING Count(PACIENTE) >2

ORDER BY
      DATA_YEAR DESC,
      DATA_MOUTH DESC









--MARIA DE FATIMA DE ANDRADE CHAVES
--SELECT * FROM infomed.HG_V_PERFIL_EPIDEMIOLOGICO@INFOMED
;
