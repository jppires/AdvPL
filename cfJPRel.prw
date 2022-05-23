#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE PL chr(13) + chr(10)


User Function cfJpRel()
    Local cNextAlias  := GetNextAlias()
    Local oReport     := nil
    
    IF(pergunte("ZCFLAN",.T.))
         oReport:=ReportDef(cNextAlias)
         oReport:PrintDialog()
    ENDIF

Return 


Static Function ReportDef(cNextAlias)
    
    Local oReport   := TReport():New("ZCFLAN","Relatório Controle Financeiro","ZCFLAN",{|oReport|ReportPrint(oReport,cNextAlias)},"Impressao de controle financeiro")
    Local oSection  := TRSection():New(oReport,OEMToAnsi("Relatorio de Contr. financeiro"),{"ZF1"})

    TRCell():New(oSection,"ZF1_FILIAL",     cNextAlias,"Filial"   ,,,,,,,,,,.T.)
    TRCell():New(oSection,"ZF1_DATA",       cNextAlias,"Data"     ,,,,,,,,,,.T.)
    TRCell():New(oSection,"ZF1_DESCO",      cNextAlias,"Objeto"   ,,,,,,,,,,.T.)
    TRCell():New(oSection,"ZF1_DESC" ,      cNextAlias,"Descricao",,,,,,,,,,.T.)
    TRCell():New(oSection,"ZF1_FAT" ,       cNextAlias,"Fator"    ,,,,,,,,,,.T.)
    TRCell():New(oSection,"CREDITO",        cNextAlias,"Credito","@E 99,999,999,999.99",,,,'LEFT',,,,,.T.)
    TRCell():New(oSection,"DEBITO",         cNextAlias,"Debito",  "@E 99,999,999,999.99",,,,'LEFT',,,,,.T.)
   
    TRFunction():New(oSection:Cell("CREDITO"),NIL,"SUM",,,,,.F.,.T.)
    TRFunction():New(oSection:Cell("DEBITO"),NIL,"SUM",,,,,.F.,.T.)
   
    oReport:SetTotalInLine(.F.)

Return oReport


Static Function ReportPrint(oReport, cNextAlias)
    Local oSection  := oReport:Section(1)
    Local cQuery    := ""
    Local nCount    := 0

    cQuery += "SELECT "                                 +PL
    cQuery += "ZF1_FILIAL,"                             +PL
	cQuery += "ZF1_DATA,"                               +PL
	cQuery += "ZF1_DESCO,"                              +PL
	cQuery += "ZF1_DESC,"                               +PL
    cQuery += "ZF1_FAT,"                                +PL
	cQuery += "IIF(ZF1_FAT='P',ZF1_VALOR,0) AS CREDITO,"+PL
	cQuery += "IIF(ZF1_FAT='N',ZF1_VALOR,0) AS DEBITO " +PL
    cQuery += "FROM "+RetSqlName("ZF1")+" "             +PL
    cQuery += "WHERE D_E_L_E_T_ = '' AND ZF1_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'"
    cQuery += "ORDER BY ZF1_DATA"
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cNextAlias)
    TCSETFIELD( cNextAlias,"ZF1_DATA","D")

    Count to nCount
    (cNextAlias)->(dbGoTop())
    oReport:SetMEter(nCount)
    oSection:Init()

    while !(cNextAlias)->(Eof())
       oReport:IncMeter() 
       oSection:PrintLine()
       if oReport:Cancel()
           exit
       endif
       (cNextAlias)->(dbSkip())
    enddo
Return 
