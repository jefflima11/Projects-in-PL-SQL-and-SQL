-- Created by JEFFERSON LIMA

CREATE SEQUENCE SEQ_LOG_REPASSE_HUMS START WITH 1 INCREMENT BY 1;

CREATE TABLE LOG_REPASSE_HUMS (
    ID_LOG_REPASSE NUMBER PRIMARY KEY,
    CD_REPASSE NUMBER NOT NULL,
		DT_COMPETENCIA DATE NOT NULL,
		DT_REPASSE DATE NOT NULL,
		DS_REPASSE VARCHAR2(100),
		TP_REPASSE VARCHAR2(1) NOT NULL,
		CD_MULTI_EMPRESA NUMBER(4) NOT NULL,
		SN_CONTABILIZAR VARCHAR(1) NOT NULL,
		DS_OBSERVACAO VARCHAR(100),
		CD_PRESTADOR NUMBER
);

COMMENT ON TABLE LOG_REPASSE_HUMS IS 'TABELA DE LOG DOS REGISTROS DA TABELA REPASSE';

-- DROP TABLE LOG_REPASSE_HUMS;


-- DROP TRIGGER TRG_TESTE_LOG_REPASSE_HUMS;