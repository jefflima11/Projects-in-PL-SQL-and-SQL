-- Created by JEFFERSON LIMA

CREATE OR REPLACE TRIGGER TRG_MOV_INT_PT_PAC_HUMS
	AFTER INSERT OR UPDATE ON MOV_INT
	FOR EACH ROW
DECLARE
	VCD_SETOR            NUMBER;
	VCD_PESSOA           NUMBER;
	VCD_MULTI_EMPRESA    NUMBER;
	VERIF_PT_MVTO_PAC_EXIST NUMBER;
BEGIN 
	IF (UPDATING OR INSERTING) AND (:NEW.TP_MOV = 'I' OR :NEW.TP_MOV = 'O') THEN
		/*Insercao do registro caso seja do tipo (atualizacao ou insercao) e (movimentacao 'I' = Internacao ou movimento 'O' = Transferencia de leito)*/
		INSERT INTO DBAMV.LOG_MOV_INT_HUMS(
		ID_LOG_MOV_INT,
		CD_ATENDIMENTO,
		CD_MOV_INT,
		CD_CONVENIO,
		CD_PRESTADOR,
		CD_LEITO,
		DT_MOV_INT,	
		HR_MOV_INT,
		DS_MOTIVO,
		SN_RESERVA,
		CD_LEITO_ANTERIOR,
		CD_TIP_ACOM,
		TP_MOV,
		NM_USUARIO,
		DT_LIV_MOV,
		HR_LIB_MOV,
		CD_MOTIVO_TRANSF_LEITO,
		CD_MOV_INT_INTEGRA,
		CD_SEQ_INTEGRA,
		DS_LOCAL,
		NR_NUMERACAO_ACESSO,
		USUARIO_LOGADO
	) 
	VALUES (
		SEQ_LOG_MOV_INT_HUMS.NEXTVAL,
		:NEW.CD_ATENDIMENTO,
		:NEW.CD_MOV_INT,
		:NEW.CD_CONVENIO,
		:NEW.CD_PRESTADOR,
		:NEW.CD_LEITO,
		:NEW.DT_MOV_INT,
		:NEW.HR_MOV_INT,
		:NEW.DS_MOTIVO,
		:NEW.SN_RESERVA,
		:NEW.CD_LEITO_ANTERIOR,
		:NEW.CD_TIP_ACOM,
		:NEW.TP_MOV,
		:NEW.NM_USUARIO,
		:NEW.DT_LIB_MOV,
		:NEW.HR_LIB_MOV,
		:NEW.CD_MOTIVO_TRANSF_LEITO,
		:NEW.CD_MOV_INT_INTEGRA,
		:NEW.CD_SEQ_INTEGRA,
		:NEW.DS_LOCAL,
		:NEW.NR_NUMERACAO_ACESSO,
		'INSERCAO, INTERNACAO'
	);		

		/*Recuperacao de dados baseados no atendimento*/
    SELECT	PP.CD_PESSOA,
            A.CD_MULTI_EMPRESA
      INTO	VCD_PESSOA,
            VCD_MULTI_EMPRESA
      FROM	DBAMV.ATENDIME A
              INNER JOIN DBAMV.PACIENTE P
                ON A.CD_PACIENTE = P.CD_PACIENTE
                  INNER JOIN DBAMV.PT_PESSOA PP
                    ON P.NR_CPF = PP.NR_DOCUMENTO
      WHERE	A.CD_ATENDIMENTO = :NEW.CD_ATENDIMENTO
        AND	PP.DOC_IDENT_ID = 1;
  	
    /*Resgata os dados do setor do paciente baseado no leito atual*/
    SELECT 	S.CD_SETOR
      INTO	VCD_SETOR
      FROM	DBAMV.LEITO L
              INNER JOIN DBAMV.UNID_INT UI
                ON L.CD_UNID_INT = UI.CD_UNID_INT
                  INNER JOIN DBAMV.SETOR S
                    ON UI.CD_SETOR = S.CD_SETOR
      WHERE	CD_LEITO = :NEW.CD_LEITO;

    /*Verifica se o paciente ja tem movimentacao na tabela PT_MVTO_PACIENTE*/ 	
    SELECT 	COUNT(*) CONT
      INTO		VERIF_PT_MVTO_PAC_EXIST
      FROM	DBAMV.PT_MVTO_PACIENTE
      WHERE	CD_ATENDIMENTO = :NEW.CD_ATENDIMENTO;

    /*Condicionante caso o paciente no atendimento atual nao tenha movimentacao cadastrada em PT_MVTO_PACIENTE e inserido um novo registro, caso ele ja tenha registro o mesmo e atualizado*/
    IF VERIF_PT_MVTO_PAC_EXIST = 0 THEN
        INSERT INTO PT_MVTO_PACIENTE(
          CD_ID_PACIENTE,
					CD_CARTAO_CRACHA,
					DT_ENTRADA,
          CD_USUARIO_ENTRADA,
          CD_SETOR,
          CD_MULTI_EMPRESA,
          CD_ATENDIMENTO,
					DS_OBSERVACOES
        ) VALUES(
          VCD_PESSOA,
					VCD_PESSOA,
					SYSDATE,
          :NEW.NM_USUARIO,
          VCD_SETOR,
          VCD_MULTI_EMPRESA,
          :NEW.CD_ATENDIMENTO,
					'AINDA NAO HAVIA REGISTRO E FOI INSERIDO'
        ); 
    ELSE
      UPDATE 	DBAMV.PT_MVTO_PACIENTE
        SET		DS_OBSERVACOES =  'ALTERACAO DE SETOR',
							CD_SETOR = VCD_SETOR
      WHERE		CD_ATENDIMENTO = :NEW.CD_ATENDIMENTO;
    END IF;
	
	/*Caso seja uma insercao e do tipo 'L' = Limpeza é inserido os dados na tabela temporaria de auditoria*/
	ELSIF INSERTING AND :NEW.TP_MOV = 'L' THEN
		INSERT INTO DBAMV.LOG_MOV_INT_HUMS(
		ID_LOG_MOV_INT,
		CD_ATENDIMENTO,
		CD_MOV_INT,
		CD_CONVENIO,
		CD_PRESTADOR,
		CD_LEITO,
		DT_MOV_INT,	
		HR_MOV_INT,
		DS_MOTIVO,
		SN_RESERVA,
		CD_LEITO_ANTERIOR,
		CD_TIP_ACOM,
		TP_MOV,
		NM_USUARIO,
		DT_LIV_MOV,
		HR_LIB_MOV,
		CD_MOTIVO_TRANSF_LEITO,
		CD_MOV_INT_INTEGRA,
		CD_SEQ_INTEGRA,
		DS_LOCAL,
		NR_NUMERACAO_ACESSO,
		USUARIO_LOGADO
	) 
	VALUES (
		SEQ_LOG_MOV_INT_HUMS.NEXTVAL,
		:NEW.CD_ATENDIMENTO,
		:NEW.CD_MOV_INT,
		:NEW.CD_CONVENIO,
		:NEW.CD_PRESTADOR,
		:NEW.CD_LEITO,
		:NEW.DT_MOV_INT,
		:NEW.HR_MOV_INT,
		:NEW.DS_MOTIVO,
		:NEW.SN_RESERVA,
		:NEW.CD_LEITO_ANTERIOR,
		:NEW.CD_TIP_ACOM,
		:NEW.TP_MOV,
		:NEW.NM_USUARIO,
		:NEW.DT_LIB_MOV,
		:NEW.HR_LIB_MOV,
		:NEW.CD_MOTIVO_TRANSF_LEITO,
		:NEW.CD_MOV_INT_INTEGRA,
		:NEW.CD_SEQ_INTEGRA,
		:NEW.DS_LOCAL,
		:NEW.NR_NUMERACAO_ACESSO,
		'INSERCAO, LIMPEZA DE LEITO'
	);
	END IF;
END;
/