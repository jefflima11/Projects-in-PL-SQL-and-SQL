begin
  dbamv.pkg_mv2000.atribui_empresa(1);
end; 

UPDATE
  DBAMV.PRODUTO
SET SN_MOVIMENTACAO = 'N'

WHERE PRODUTO.CD_PRODUTO IN (SELECT     P.CD_PRODUTO
FROM   (SELECT  DISTINCT
                P.CD_PRODUTO,
                MAX(IME.CD_MVTO_ESTOQUE)CD_MVTO_ESTOQUE,
                Max(IME.DH_MVTO_ESTOQUE)DT
        FROM    DBAMV.MVTO_ESTOQUE ME,
                DBAMV.ITMVTO_ESTOQUE IME,
                DBAMV.PRODUTO P

        WHERE    ME.CD_MVTO_ESTOQUE = IME.CD_MVTO_ESTOQUE
          AND     IME.CD_PRODUTO = P.CD_PRODUTO
          AND   P.CD_ESPECIE IN (1,2,3)
          AND   P.SN_MOVIMENTACAO = 'S'
    GROUP
           BY   P.CD_PRODUTO
    ORDER
       BY   P.CD_PRODUTO)F,
        DBAMV.PRODUTO P,
        DBAMV.MVTO_ESTOQUE ME,
        DBAMV.ESTOQUE E,
        DBAMV.EST_PRO EP
        
WHERE    F.CD_PRODUTO = P.CD_PRODUTO
  AND     F.CD_MVTO_ESTOQUE = ME.CD_MVTO_ESTOQUE
  AND   ME.CD_ESTOQUE = E.CD_ESTOQUE
  AND    E.CD_ESTOQUE = EP.CD_ESTOQUE
  AND   P.CD_PRODUTO = EP.CD_PRODUTO
  AND   TO_CHAR(F.DT,'YYYY') <= '2019'
  AND   EP.QT_ESTOQUE_ATUAL = 0
  AND   P.SN_MOVIMENTACAO = 'S');
commit;
