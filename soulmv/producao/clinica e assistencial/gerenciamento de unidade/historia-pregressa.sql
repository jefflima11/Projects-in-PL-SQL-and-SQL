/*CREATED BY
NAME: JEFFERSON LIMA GONCALVES
CARGO: ANALISTA E DESENVOLVEDOR DE SISTEMAS JR
DATA: 01/02/2024
TITULO: HISTORIA PREGRESSA
DESCRICAO: 
FILTROS:

ÚLTIMA ATUALIZAÇÃO
RESPÓNSAVEL:
DATA:
MOTIVO:
DESCRIÇÃO:
*/

SELECT
  DESCRICAO,
  NM_PACIENTE,
  DS_UNID_INT,
  DS_LEITO,
  Decode(CELULAR_C,'()','NAO INFORMADO',
                    CELULAR_C)NR_CELULAR,
  Decode(FONE_C,'()','NAO INFORMADO',
                 FONE_C)NR_FONE

FROM
  ( --CASE DE FILTRAGEM APENAS "SIM"
    SELECT
      ERC.CD_REGISTRO,
      ERC.CD_CAMPO,
      Decode(EC.DS_IDENTIFICADOR,'osm_radio_31','HIPERTENSAO',
                                 'osm_radio_32','DIABETES',
                                 'osm_radio_37','RENAL CRONICO',
                                 'osm_radio_36','CARDIOPATIA',
                                 'osm_radio_34','DOENCA RESPIRATORIA CRONICA',
                                 'osm_radio_35','DOENCA HEPATICA CRONICA',
                                 'osm_radio_33','CANCER',
                                 'osm_radio_38','TABAGISMO',
                                 'osm_radio_31','ALCOOLISMO',
                                 'osm_radio_41','CIRURGIAS',
                                 'osm_radio_40','ALERGIAS') DESCRICAO,
      DBMS_LOB.SUBSTR(LO_VALOR, 100, 1)TST,
      NM_PACIENTE,
      EC.DS_CAMPO,
      U.DS_UNID_INT,
      L.DS_LEITO,
      '('||P.NR_DDD_FONE||')'||P.NR_FONE FONE_C,
      '('||P.NR_DDD_CELULAR||')'||P.NR_CELULAR CELULAR_C

    FROM
      DBAMV.EDITOR_REGISTRO_CAMPO ERC,
      DBAMV.EDITOR_CAMPO EC,
      DBAMV.PW_EDITOR_CLINICO PEC,
      DBAMV.PW_DOCUMENTO_CLINICO PDC,
      DBAMV.ATENDIME A,
      DBAMV.PACIENTE P,
      DBAMV.LEITO L,
      DBAMV.UNID_INT U,

      -- SUB-SELECT DIRECIONADO APENAS AO ULTIMO CODIGO DE REGISTRO(CD_EDITOR_REGISTRO)
      (
        --CASE DO DIRECIONAMENTO
        SELECT *

        FROM
        --SUB-SELECT DE APONTAMENTO DE DIRECIONAMENTO
        (
          SELECT
            PDC2.CD_DOCUMENTO_CLINICO,
            To_Char(PDC2.DH_REFERENCIA,'DD/MM/YYYY')DT_REFERENCIA,
            Row_Number() OVER (PARTITION BY PDC2.CD_ATENDIMENTO ORDER BY PDC2.CD_DOCUMENTO_CLINICO DESC ) N,
            CD_ATENDIMENTO,
            CD_TIPO_DOCUMENTO,
            CD_DOCUMENTO,
            CD_EDITOR_REGISTRO

          FROM
            DBAMV.PW_DOCUMENTO_CLINICO PDC2,
            DBAMV.PW_EDITOR_CLINICO PEC2

          WHERE
                PDC2.CD_DOCUMENTO_CLINICO = PEC2.CD_DOCUMENTO_CLINICO
            AND PEC2.CD_DOCUMENTO IN (309,230,187)

          ORDER BY N
        )E1
        --FIM DO SUB-SELECT DE APONTAMENTO DE DIRECIONAMENTO
        WHERE E1.N=1
        --FIM DA CASE DE DIRECIONAMENTO
      )F1
      --FIM DO SUB-SELECT DE DIRECIONAMENTO APENAS AO ULTIMO CODIGO DE REGISTRO(CD_EDITOR_REGISTRO)

    WHERE
          EC.CD_TIPO_ITEM = 8
      AND EC.CD_TIPO_VISUALIZACAO = 7
      AND EC.DS_IDENTIFICADOR IN ('osm_radio_31',
                                  'osm_radio_32',
                                  'osm_radio_37',
                                  'osm_radio_36',
                                  'osm_radio_34',
                                  'osm_radio_35',
                                  'osm_radio_33',
                                  'osm_radio_38',
                                  'osm_radio_31',
                                  'osm_radio_41',
                                  'osm_radio_40')

      AND PDC.CD_TIPO_DOCUMENTO = 28
      AND U.CD_UNID_INT IN (26,11,2,4,5)
      AND A.TP_ATENDIMENTO = 'I'
      AND A.DT_ALTA_MEDICA IS  NULL

--SELECT * FROM DBAMV.UNID_INT

      AND PDC.CD_ATENDIMENTO = A.CD_ATENDIMENTO
      AND ERC.CD_CAMPO = EC.CD_CAMPO
      AND ERC.CD_REGISTRO = PEC.CD_EDITOR_REGISTRO
      AND PEC.CD_DOCUMENTO_CLINICO = PDC.CD_DOCUMENTO_CLINICO
      AND ERC.CD_REGISTRO = F1.CD_EDITOR_REGISTRO
      AND F1.CD_ATENDIMENTO = PDC.CD_ATENDIMENTO
      AND F1.CD_TIPO_DOCUMENTO = PDC.CD_TIPO_DOCUMENTO
      AND F1.CD_DOCUMENTO = PEC.CD_DOCUMENTO
      AND A.CD_PACIENTE = P.CD_PACIENTE
      AND A.CD_LEITO = L.CD_LEITO
      AND L.CD_UNID_INT = U.CD_UNID_INT

    )A1

    WHERE
      TST = 'true'
    --FIM DA CASE DE FILTRAGEM APENAS "SIM"


-- #IDENTIFICADOR
-- "osm_radio_31"
-- "osm_radio_32"
-- "osm_radio_37"
-- "osm_radio_36"
-- "osm_radio_34"
-- "osm_radio_35"
-- "osm_radio_33"
-- "osm_radio_38"
-- "osm_radio_31"
-- "osm_radio_39"
-- "osm_radio_31"
-- "osm_radio_41"
-- "osm_radio_40"

