CREATE OR REPLACE TRIGGER TRG_MOV_INT_PT_PAC_HUMS
	AFTER INSERT OR UPDATE ON MOV_INT
	FOR EACH ROW
DECLARE
	VCD_SETOR            UNID_INT.CD_SETOR%TYPE;
	VCD_UNID_INT         UNID_INT.CD_UNID_INT%TYPE;
	VCD_LEITO            LEITO.CD_LEITO%TYPE;
	VCD_ATENDIMENTO      ATENDIME.CD_ATENDIMENTO%TYPE;
	VCD_PACIENTE         PACIENTE.CD_PACIENTE%TYPE;
	VNM_PACIENTE         PACIENTE.NM_PACIENTE%TYPE;
	VCD_PESSOA           PT_PESSOA.CD_PESSOA%TYPE;
	VDT_ENTRADA          MOV_INT.HR_MOV_INT%TYPE;
	VHR_ENTRADA          MOV_INT.HR_MOV_INT%TYPE;
	VCD_CARTAO_CRACHA    PT_PESSOA.CD_PESSOA%TYPE;
	VNM_USUARIO          MOV_INT.NM_USUARIO%TYPE;
	VCD_PORTARIA_ENTRADA NUMBER := 4;
	VCD_MULTI_EMPRESA    ATENDIME.CD_MULTI_EMPRESA%TYPE;
	VTP_MOV              MOV_INT.TP_MOV%TYPE;
	VCOUNT               NUMBER;
BEGIN
	VCD_LEITO       := :NEW.CD_LEITO;
	VCD_ATENDIMENTO := :NEW.CD_ATENDIMENTO;
	VDT_ENTRADA     := :NEW.HR_MOV_INT;
	VHR_ENTRADA     := :NEW.HR_MOV_INT;
	VNM_USUARIO     := :NEW.NM_USUARIO;
	VTP_MOV         := :NEW.TP_MOV;

	SELECT CD_UNID_INT
	  INTO VCD_UNID_INT
	  FROM DBAMV.LEITO
	 WHERE LEITO.CD_LEITO = VCD_LEITO;

	SELECT CD_SETOR
	  INTO VCD_SETOR
	  FROM DBAMV.UNID_INT
	 WHERE UNID_INT.CD_UNID_INT = VCD_UNID_INT;

	SELECT CD_PACIENTE, CD_MULTI_EMPRESA
	  INTO VCD_PACIENTE, VCD_MULTI_EMPRESA
	  FROM DBAMV.ATENDIME
	 WHERE CD_ATENDIMENTO = VCD_ATENDIMENTO;

	SELECT NM_PACIENTE
	  INTO VNM_PACIENTE
	  FROM DBAMV.PACIENTE
	 WHERE CD_PACIENTE = VCD_PACIENTE;

	SELECT CD_PESSOA, CD_PESSOA
	  INTO VCD_PESSOA, VCD_CARTAO_CRACHA
	  FROM DBAMV.PT_PESSOA
	 WHERE NM_NOME = VNM_PACIENTE
	   AND NR_DOCUMENTO IS NOT NULL;

	IF (VTP_MOV = 'O') THEN
		UPDATE PT_MVTO_PACIENTE
		   SET CD_SETOR = VCD_SETOR
		 WHERE CD_ID_PACIENTE = VCD_PESSOA
		   AND CD_ATENDIMENTO = VCD_ATENDIMENTO;
	ELSIF (VTP_MOV = 'I') THEN
		SELECT COUNT(*)
		  INTO VCOUNT
		  FROM PT_MVTO_PACIENTE
		 WHERE CD_ID_PACIENTE = VCD_PESSOA
		   AND CD_ATENDIMENTO = VCD_ATENDIMENTO;
	
		IF VCOUNT = 0 THEN
			INSERT INTO PT_MVTO_PACIENTE
				(CD_ID_PACIENTE,
				 CD_CARTAO_CRACHA,
				 DT_ENTRADA,
				 HR_ENTRADA,
				 CD_USUARIO_ENTRADA,
				 CD_SETOR,
				 CD_PORTARIA_ENTRADA,
				 CD_MULTI_EMPRESA,
				 CD_ATENDIMENTO)
			VALUES
				(VCD_PESSOA,
				 VCD_CARTAO_CRACHA,
				 VDT_ENTRADA,
				 VHR_ENTRADA,
				 VNM_USUARIO,
				 VCD_SETOR,
				 VCD_PORTARIA_ENTRADA,
				 VCD_MULTI_EMPRESA,
				 VCD_ATENDIMENTO);
		END IF;
	END IF;

END;
/
