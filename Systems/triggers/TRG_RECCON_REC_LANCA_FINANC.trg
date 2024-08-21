CREATE OR REPLACE TRIGGER TRG_RECCON_REC_LANCA_FINANC
  BEFORE INSERT OR DELETE
  ON RECCON_REC 
  FOR EACH ROW
BEGIN

   DECLARE

      CURSOR CUR_MES_ANO_FECH_CONT (

         P_CD_MULTI_EMPRESA   IN   DBAMV.CONFIG_FCCT.CD_MULTI_EMPRESA%TYPE,

         P_DT_REFERENCIA      IN   DBAMV.RECCON_REC.DT_RECEBIMENTO%TYPE

      )

      IS

         SELECT DECODE(DBAMV.FNC_RETORNA_COMP_FECHADA(P_CD_MULTI_EMPRESA, P_DT_REFERENCIA, USER, 'CREC'), 'ABERTO', 'A', 'FECHADO', 'F') TP_SITUACAO_MES,

                M.SN_LANCA_RECCON_REC

           FROM DBAMV.MES_ANO_FECH_FINANC M

          WHERE M.CD_MULTI_EMPRESA = P_CD_MULTI_EMPRESA

            AND M.DT_ANO = TRUNC (P_DT_REFERENCIA, 'YYYY')

            AND M.DT_MES = TO_NUMBER (TO_CHAR (P_DT_REFERENCIA, 'MM'));

      CURSOR CUR_MULTI_EMPRESA (P_CD_ITCON_REC IN DBAMV.ITCON_REC.CD_ITCON_REC%TYPE)

      IS

         SELECT C.CD_MULTI_EMPRESA

           FROM DBAMV.CON_REC C, DBAMV.ITCON_REC I

          WHERE C.CD_CON_REC = I.CD_CON_REC AND I.CD_ITCON_REC = P_CD_ITCON_REC;

      V_CD_MULTI_EMPRESA      DBAMV.CONFIG_FCCT.CD_MULTI_EMPRESA%TYPE;

      V_DT_REFERENCIA         DBAMV.PAGCON_PAG.DT_PAGAMENTO%TYPE;

      V_SN_LANCA_RECCON_REC   DBAMV.MES_ANO_FECH_FINANC.SN_LANCA_RECCON_REC%TYPE;

      V_TP_SITUACAO_MES       DBAMV.MES_ANO_FECH_FINANC.TP_SITUACAO_MES%TYPE;

      V_CD_ITCON_REC          DBAMV.ITCON_REC.CD_ITCON_REC%TYPE;

   BEGIN

      IF DELETING

      THEN

         V_CD_ITCON_REC := :OLD.CD_ITCON_REC;

      ELSE

         V_CD_ITCON_REC := :NEW.CD_ITCON_REC;

      END IF;

      OPEN CUR_MULTI_EMPRESA (V_CD_ITCON_REC);

      FETCH CUR_MULTI_EMPRESA

       INTO V_CD_MULTI_EMPRESA;

      CLOSE CUR_MULTI_EMPRESA;

      FOR I IN 1 .. 2 LOOP

         IF DELETING

         THEN

            IF I = 1

            THEN

               V_DT_REFERENCIA := :OLD.DT_RECEBIMENTO;

            ELSE

               V_DT_REFERENCIA := :OLD.DT_ESTORNO;

            END IF;

         ELSE

            IF I = 1

            THEN

               V_DT_REFERENCIA := :NEW.DT_RECEBIMENTO;

            ELSE

               V_DT_REFERENCIA := :NEW.DT_ESTORNO;

            END IF;

         END IF;



         OPEN CUR_MES_ANO_FECH_CONT (V_CD_MULTI_EMPRESA, V_DT_REFERENCIA);

         FETCH CUR_MES_ANO_FECH_CONT

          INTO V_TP_SITUACAO_MES,

               V_SN_LANCA_RECCON_REC;

         CLOSE CUR_MES_ANO_FECH_CONT;

         IF (NVL (V_TP_SITUACAO_MES, 'X') = 'X') THEN

            RAISE_APPLICATION_ERROR

               (-20012,

                PKG_RMI_TRADUCAO.EXTRAIR_PKG_MSG

                        ('MSG_4',

                         'TRG_RECCON_REC_LANCA_FINANC',

                            '[REC] %s Motivo: Não existe mês finenceiro cadastrado no período %s %s Ação: Efetuar cadastro do Mês do Financeiro. %s Local: FNFI / Exercício / Abertura',

                         ARG_LIST (CHR (10),TO_CHAR (V_DT_REFERENCIA, 'DD/MM/YYYY'),CHR (10),CHR (10))

                        )

               );

         ELSIF     V_TP_SITUACAO_MES = 'F' AND NVL(NVL (:NEW.TP_LANCAMENTO, :OLD.TP_LANCAMENTO), 'X') <> 'T' THEN --22299

            IF V_SN_LANCA_RECCON_REC = 'S'

            THEN
               IF INSERTING

               THEN

                  RAISE_APPLICATION_ERROR

                     (-20012,

                      PKG_RMI_TRADUCAO.EXTRAIR_PKG_MSG

                               ('MSG_1',

                                'TRG_RECCON_REC_LANCA_FINANC',

                                   '[REC] %s Motivo: [01] Inclusão inválida, mês do financeiro fechado.004 %s Ação: Efetuar abertura do Mês do Financeiro fechado. %s Local: FNFI / Exercício / Fechamento',ARG_LIST(CHR(10),CHR(10),CHR(10)))

                     );

               ELSIF (    NOT UPDATING ('DT_ESTORNO')

                      AND NOT UPDATING ('VL_ESTORNO')

                      AND NOT UPDATING ('NM_USUARIO')

                      AND NOT UPDATING ('CD_MOTIVO_CANC')

                      AND NOT UPDATING ('DS_ESTORNO')

                      AND NOT UPDATING ('CD_PROCESSO_SEC')

                      AND NOT UPDATING ('NM_RESPONSAVEL')

                      AND NOT UPDATING ('NR_ID_RESPONSAVEL')

                      AND NOT UPDATING ('CD_EXP_CONTAB_ESTORNO_BAIXA')

                      AND NOT UPDATING ('CD_EXP_CONTABILIDADE')

                      AND I = 1

                     )

               THEN

                  RAISE_APPLICATION_ERROR

                     (-20010,

                      PKG_RMI_TRADUCAO.EXTRAIR_PKG_MSG

                              ('MSG_2',

                               'TRG_RECCON_REC_LANCA_FINANC',

                                  '[REC] %s Motivo: Alteração inválida, mês do financeiro fechado. %s Ação: Efetuar abertura do Mês do Financeiro fechado. %s Local: FNFI / Exercício / Fechamento',ARG_LIST(CHR(10),CHR(10),CHR(10)))

                     );

               ELSIF (    NOT UPDATING ('CD_EXP_CONTAB_ESTORNO_BAIXA')

                      AND NOT UPDATING ('CD_EXP_CONTABILIDADE')

                      AND V_DT_REFERENCIA IS NOT NULL
                      AND NOT UPDATING ('NM_RESPONSAVEL')
                      AND NOT UPDATING ('NR_ID_RESPONSAVEL')

                      AND I = 2

                     )

               THEN

                  RAISE_APPLICATION_ERROR

                     (-20010,

                      PKG_RMI_TRADUCAO.EXTRAIR_PKG_MSG

                              ('MSG_2',

                               'TRG_RECCON_REC_LANCA_FINANC',

                                  '[REC] %s Motivo: Alteração inválida, mês do financeiro fechado. %s Ação: Efetuar abertura do Mês do Financeiro fechado. %s Local: FNFI / Exercício / Fechamento',ARG_LIST(CHR(10),CHR(10),CHR(10)))

                     );

               ELSIF DELETING

               THEN

                  RAISE_APPLICATION_ERROR

                     (-20010,

                      PKG_RMI_TRADUCAO.EXTRAIR_PKG_MSG

                               ('MSG_3',

                                'TRG_RECCON_REC_LANCA_FINANC',

                                   '[REC]  %s Motivo: Exclusão inválida, mês do financeiro fechado. %s Ação: Efetuar abertura do Mês do Financeiro fechado. %s Local: FNFI / Exercício / Fechamento',ARG_LIST(CHR(10),CHR(10),CHR(10)))

                     );

               END IF;

            END IF;

         END IF;

      END LOOP;

   END;

END TRG_RECCON_REC_LANCA_FINANC;
ALTER TRIGGER "DBAMV"."TRG_RECCON_REC_LANCA_FINANC" ENABLE
/
