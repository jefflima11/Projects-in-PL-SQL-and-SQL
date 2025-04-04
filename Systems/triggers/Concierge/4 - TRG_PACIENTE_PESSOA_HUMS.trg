-- Created by JEFFERSON LIMA

CREATE OR REPLACE TRIGGER TRG_PACIENTE_PESSOA_HUMS
AFTER INSERT OR UPDATE
ON paciente
FOR EACH ROW
DECLARE
	numeroCpf varchar2(15);
BEGIN
	IF :NEW.nr_cpf IS NULL THEN 
  	numeroCpf := :NEW.nr_cpf_tutor;

  ELSE
  	numeroCpf := :NEW.nr_cpf;
  END IF;
	
	if inserting then
		insert into dbamv.pt_pessoa (
      cd_pessoa,
      nm_nome,
      doc_ident_id,
      nr_documento,
      telefone,
      sn_utiliza_nome_social,
      sn_visitante_restrito,
			cd_paciente
  	)
  	values (
      seq_pt_pessoa.nextval, 
      upper(:new.nm_paciente),
      upper(1),
      upper(numeroCpf),
      upper(:new.nr_celular),
      upper(:new.sn_utiliza_nome_social),
      upper('N'),
			upper(:new.cd_paciente)
  	);

	elsif updating then
		update 
			dbamv.pt_pessoa
		set
			nm_nome = :new.nm_paciente,
			nr_documento = numeroCpf
		where
			cd_paciente = :new.cd_paciente;

	else
		 dbamv.sp_snake_trash_hums('TRIGGER_ERROR', SYSDATE, 'Erro inesperado no trigger');
	end if;

END;
/
