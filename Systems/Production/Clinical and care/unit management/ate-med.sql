select  TO_DATE(atend.dt_atendimento)DT_ATEND,
        atend.cd_atendimento,
        atend.nm_paciente,
        atend.nm_convenio,
        atend.nr_guia,
        atend.nr_carteira,
        atend.lote,
        atend.nm_prestador,
        atend.cd_servico,
        atend.servico,
        valor.vl_total,
        ATEND.DT_COMPETENCIA

from   (select  a.dt_atendimento,
                a.cd_atendimento,
                tg.nm_paciente,
                c.nm_convenio,
                tg.nr_guia,
                tg.nr_carteira,
                vl.nr_lote as lote,
                pr.nm_prestador,
                a.cd_pro_int as cd_servico,
                pf.ds_pro_fat as servico,
                F.DT_COMPETENCIA

        from    prestador pr,
                atendime a,
                convenio c,
                tiss_guia tg,
                remessa_fatura rf,
                V_TISS_STATUS_PROTOCOLO vl,
                pro_fat pf,
                DBAMV.FATURA F

        where   pr.cd_prestador = a.cd_prestador
          and   a.cd_atendimento = a.cd_atendimento
          and   c.cd_convenio = a.cd_convenio
          and   tg.cd_atendimento = a.cd_atendimento
          and   rf.cd_remessa(+) = tg.cd_remessa
          and   vl.cd_remessa(+) = rf.cd_remessa
          and   pf.cd_pro_fat = a.cd_pro_int
          AND   RF.CD_FATURA = F.CD_FATURA

          and   pr.cd_prestador = 1023
          and   a.cd_multi_empresa = 1
          and   a.cd_convenio = 3
          and   a.dt_atendimento between TO_DATE('01/09/2022','DD/MM/YYYY') and TO_DATE('30/04/2023','DD/MM/YYYY')
       ) atend,

       (select  pf.cd_pro_fat,
                pf.ds_pro_fat,
                vp.vl_total,
                vp.dt_vigencia
        from    val_pro vp,
                pro_fat pf
        where   pf.cd_pro_fat = vp.cd_pro_fat
            and   vp.cd_tab_fat = 36
            and   vp.dt_vigencia =   (select  max(vp2.dt_vigencia)
                                    from    val_pro vp2
                                    where   vp2.cd_pro_fat = vp.cd_pro_fat
                                        and   vp2.cd_tab_fat in (36))
       ) valor

where atend.cd_servico = valor.cd_pro_fat(+)


union ALL


select  TO_DATE(atend.dt_atendimento)DT_ATEND,
        atend.cd_atendimento,
        atend.nm_paciente,
        atend.nm_convenio,
        atend.nr_guia,
        atend.nr_carteira,
        atend.lote,
        atend.nm_prestador,
        atend.cd_servico,
        atend.servico,
        valor.vl_total,
        ATEND.DT_COMPETENCIA

from   (select  a.dt_atendimento,
                a.cd_atendimento,
                tg.nm_paciente,
                c.nm_convenio,
                tg.nr_guia,
                tg.nr_carteira,
                vl.nr_lote as lote,
                pr.nm_prestador,
                a.cd_pro_int as cd_servico,
                pf.ds_pro_fat as servico,
                F.DT_COMPETENCIA

        from    prestador pr,
                atendime a,
                convenio c,
                tiss_guia tg,
                remessa_fatura rf,
                V_TISS_STATUS_PROTOCOLO vl,
                pro_fat pf,
                DBAMV.FATURA F
        where   pr.cd_prestador = a.cd_prestador
          and   a.cd_atendimento = a.cd_atendimento
          and   c.cd_convenio = a.cd_convenio
          and   tg.cd_atendimento = a.cd_atendimento
          and   rf.cd_remessa(+) = tg.cd_remessa
          and   vl.cd_remessa(+) = rf.cd_remessa
          and   pf.cd_pro_fat = a.cd_pro_int
          AND   RF.CD_FATURA = F.CD_FATURA

          and   pr.cd_prestador = 1023
          and   a.cd_multi_empresa = 1
          and   a.cd_convenio in (3,4)
          and   a.dt_atendimento between TO_DATE('01/09/2022','DD/MM/YYYY') and TO_DATE('30/04/2023','DD/MM/YYYY')
       ) atend,

       (select  pf.cd_pro_fat,
                pf.ds_pro_fat,
                vp.vl_total,
                vp.dt_vigencia

        from    val_pro vp,
                pro_fat pf
                
        where   pf.cd_pro_fat = vp.cd_pro_fat
          and   vp.cd_tab_fat = 36
          and   vp.dt_vigencia =   (select  max(vp2.dt_vigencia)
                                    from    val_pro vp2
                                    where   vp2.cd_pro_fat = vp.cd_pro_fat
                                      and   vp2.cd_tab_fat in (36))
       ) valor
where   atend.cd_servico = valor.cd_pro_fat(+)
;
