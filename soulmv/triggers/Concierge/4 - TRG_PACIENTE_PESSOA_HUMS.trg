-- Created by JEFFERSON LIMA

CREATE OR REPLACE TRIGGER TRG_PACIENTE_PESSOA_HUMS
AFTER INSERT
ON paciente
FOR EACH ROW
BEGIN
  INSERT INTO DBAMV.PT_PESSOA (
    CD_PESSOA,
    NM_NOME,
    DOC_IDENT_ID,
    NR_DOCUMENTO,
    TELEFONE,
    NM_SOCIAL,
    SN_UTILIZA_NOME_SOCIAL,
    SN_VISITANTE_RESTRITO
  )
  VALUES (
    SEQ_PT_PESSOA.NEXTVAL, -- Obtém o próximo valor da sequência SEQ_PT_PESSOA
    UPPER(:NEW.NM_PACIENTE), -- Nome do paciente recém-inserido
    UPPER(1), -- ID do documento de identificação (valor fixo)
    UPPER(:NEW.NR_CPF), -- CPF do paciente recém-inserido
    UPPER(:NEW.NR_CELULAR), -- Celular do paciente recém-inserido
    UPPER(:NEW.NM_SOCIAL_PACIENTE), -- Nome social do paciente recém-inserido
    UPPER(:NEW.SN_UTILIZA_NOME_SOCIAL), -- Indicação se o paciente usa nome social
    UPPER('N') -- Indicador de visitante restrito (valor fixo)
  );
END;
/
