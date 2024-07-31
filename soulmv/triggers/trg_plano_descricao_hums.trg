CREATE OR REPLACE TRIGGER trg_plano_descricao_hums
  BEFORE INSERT OR UPDATE
  ON cirurgia_aviso
  FOR EACH ROW
DECLARE
  vDsPlanoNew CON_PLA.DS_CON_PLA%TYPE;
BEGIN
  SELECT DS_CON_PLA
  INTO vDsPlanoNew
  FROM DBAMV.CON_PLA
  WHERE CD_CONVENIO = :new.cd_convenio
    AND CD_CON_PLA = :new.CD_CON_PLA;
	
  :new.DS_CON_PLA := vDsPlanoNew;
END;
/
