/*CREATED BY
NAME: ROMILSON SOARES
CARGO: ANALISTA DE SISTEMAS SENIOR
DATA: ??/??/????
TITULO: MAPA CIRURGICO
DESCRICAO: MAPA DAS CIRURGIAS
FILTROS: PERIODO - TODAY
   
ÚLTIMA ATUALIZAÇÃO
RESPONSÁVEL: JEFFERSON LIMA GONÇALVES
CARGO: ANALISTA E DESENVOLVEDOR DE SISTEMAS JR
DATA: 01/03/2024
MOTIVO: MELHORIA E CORREÇÕES
DESCRIÇÃO: 
*/

select  distinct 
        leito.ds_enfermaria,
        leito.ds_resumo Quarto,
        Aviso_cirurgia.cd_aviso_cirurgia Aviso_Cirurgia,
        to_char(age_cir.dt_inicio_age_cir, 'dd/mm/yyyy') Data_cirurgia,
        to_char(age_cir.dt_inicio_age_cir, 'hh24:mi') Hora_cirurgia,
        Sal_cir.Ds_Resumida Sala_Cirurgia,
        aviso_cirurgia.nm_paciente Paciente,
        decode(ca.cd_convenio, '3','UNIMED IMPERATRIZ','4','UNIMED INTERCAMBIO','5','PARTICULAR','6','SUS MUNICIPIO LIMINAR','7','HOSPITAL SÃO RAFAEL','8','SUS ESTADO LIMINAR',
        '9','CONVENIO IMETAME','13','CONVENIO COBRA UTI','15','CONVENIO UTI STI','16','GEAP AUTOGESTÃO EM SAÚDE','17','GEAP','19','CORTESIA','20','SECRETARIA DE ESTADO DA SAUDE',
        '21','CPS - PARTICULAR','22','MEDICINA DO TRABALHO') Convenio,
        c.ds_cirurgia Cirurgia,
        Dbamv.FNC_Fscc_Outras_Cirurgias_Av(Aviso_cirurgia.cd_aviso_cirurgia) Outras_Cirurgias,
        p.nm_prestador,
        decode (Aviso_cirurgia.tp_situacao, 'A' , 'EM AVISO' , 'R' , 'REALIZADA' , 'C' , 'CANCELADA' , 'G' , 'AGENDADA' , 'T' , 'Controle de Checagem' , 'P' , 'Pre Agendamento') Situacao,
        Aviso_cirurgia.ds_obs_aviso Observacao

FROM    DBAMV.AGE_CIR AGE_CIR,
        DBAMV.SAL_CIR SAL_CIR,
        DBAMV.CEN_CIR CEN_CIR, 
        DBAMV.AVISO_CIRURGIA AVISO_CIRURGIA, 
        DBAMV.cirurgia_aviso ca,
        DBAMV.cirurgia c,
        DBAMV.ATENDIME ATENDIME, 
        DBAMV.PACIENTE PACIENTE, 
        DBAMV.CONVENIO CONVENIO, 
        DBAMV.LEITO LEITO, 
        DBAMV.UNID_INT UNID_INT,
        DBAMV.prestador_aviso pa,
        DBAMV.prestador p
 
WHERE   AGE_CIR.CD_SAL_CIR = SAL_CIR.CD_SAL_CIR 
  AND   AGE_CIR.CD_AVISO_CIRURGIA = AVISO_CIRURGIA.CD_AVISO_CIRURGIA
  AND   ATENDIME.CD_ATENDIMENTO (+) = AVISO_CIRURGIA.CD_ATENDIMENTO
  AND   DBAMV.AVISO_CIRURGIA.CD_AVISO_CIRURGIA=ca.cd_aviso_cirurgia
  AND   ca.cd_cirurgia = c.cd_cirurgia
  AND   ATENDIME.CD_PACIENTE = PACIENTE.CD_PACIENTE (+)
  AND   ATENDIME.CD_CONVENIO = CONVENIO.CD_CONVENIO (+) 
  AND   ATENDIME.CD_LEITO = LEITO.CD_LEITO (+) 
  AND   UNID_INT.CD_UNID_INT (+) = AVISO_CIRURGIA.CD_UNID_INT
  and   DBAMV.AVISO_CIRURGIA.CD_AVISO_CIRURGIA=pa.cd_aviso_cirurgia
  AND   CEN_CIR.CD_CEN_CIR = SAL_CIR.CD_CEN_CIR 
  and   p.cd_prestador=pa.cd_prestador

  AND   TO_CHAR(AGE_CIR.DT_INICIO_AGE_CIR , 'DD/MM/YYYY' ) = trunc(sysdate) 
  and   pa.sn_principal = 'S'
  and   ca.sn_principal= 'S'
  AND   p.cd_conselho in ('1','5')

ORDER 
   BY 3 ASC 
;
 
