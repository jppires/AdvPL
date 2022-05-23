#INCLUDE 'TOTVS.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOPCONN.ch'
#DEFINE PL chr(13) + chr(10)

/*/{Protheus.doc} User Function cfShwCalc
    Mostra os detalhes e resultado da receita - despesas no periodo
    @type  Function
    @author Joao Paulo
    @since 16/07/2020
    /*/
User Function cfShwCalc()
    Local nCont := 1
    aArea := GetArea()
    SetPrvt("oDlg1","oSay1")
    Private aDesp := {}
    Private aRec := {}
    Private cHtml := ''
    Private nTotal := 0   
    
    pergunte("ZCFLAN",.T.)
    aRec := u_cfGetRec(MV_PAR01,MV_PAR02)
    aDesp := u_cfGetDes(MV_PAR01,MV_PAR02) 

    cHtml := " <table>"+;
		"<tr>"+;
			"<td style='border-style:solid'>"+;
				"<h2 style='color:blue'>----------------Receitas-------------</h2><br>"+;
				"<table>"	
                for nCont := 1 to LEN(aRec)
                  cHtml += "<tr><td>"+aRec[nCont][1]+"        +</td>"+PL
                  cHtml += "<td>"+str(aRec[nCont][2])+"</td></tr>"
                  nTotal += aRec[nCont][2]
                next
	cHtml +="</table>"+;
			"</td>"+;
			"<td style='border-style:solid'>"+;
				"<h2 style='color:red'>----------------Despesas-------------</h2><br>"+;
				"<table>"
                nCont := 1
                for nCont := 1 to LEN(aDesp)
                  cHtml += "<tr><td>"+aDesp[nCont][1]+"        -</td>"+PL
                  cHtml += "<td>"+str(aDesp[nCont][2])+"</td></tr>"
                  nTotal -= aDesp[nCont][2]
                next
	cHtml +="</table>"+;
			"</td>"+;
		"</tr>"+;
	"</table><br>"+;
    "<table border='1'>"+;
		"<tr>"+;
			"<td><h2 style='color:black'>Totais</h2><br></td>"+;
		"</tr>"+;
		"<tr>"+;
			"<td>Total no periodo:  </td>"+;
			"<td style='text-align:center'>"+str(nTotal)+"</td>"+;
		"</tr>"+;
		"<tr>"+;
			"<td>Total saldo:  </td>"+;
			"<td>----EM IMPLANTACAO----</td>"+;
		"</tr>"+;
		"<tr>"+;
			"<td>Total poupança:  </td>"+;
			"<td>----EM IMPLANTACAO----</td>"+;			
		"</tr>"+;
	"</table>"

    DEFINE DIALOG oDlg1 TITLE "Calculo financeiro" FROM 180,180 TO 650,800 PIXEL
    oSay1      := TSay():New( 01,01,{||cHtml},oDlg1,,,,,,.T.,,,400,300,,,,,,.T.)
    
     ACTIVATE DIALOG oDlg1 CENTERED

    RestArea(aArea)
Return 


/*/{Protheus.doc} User Function cfGetRec
    Retorna os dados de receita baseado em data de inicio e termino
    @type  Function
    @author Joao Paulo
    @since 16/07/2020
    /*/

USER FUNCTION cfGetRec(dIni,dFin)
    Private aRec := {}
    Private cQuery := ""

    cQuery := "select ZF1_DESCO, SUM(ZF1_VALOR) AS ZF1_VALOR "+PL
    cQuery += "from "+RetSqlName("ZF1")+" ZF1 "+PL
    cQuery += "WHERE D_E_L_E_T_ <> '*' AND ZF1_FAT = 'P' "+PL
    cQuery += "AND ZF1_DATA BETWEEN "+DTOS(dIni)+"AND "+DTOS(dFin)+" "+PL
    cQuery += "GROUP BY ZF1_DESCO ORDER BY ZF1_VALOR DESC"
    cQuery := ChangeQuery(cQuery)
    TCQuery cQuery New alias "QRY_ZF1"

    while !QRY_ZF1->(Eof())
        AADD(aRec,{QRY_ZF1->ZF1_DESCO,QRY_ZF1->ZF1_VALOR})
        QRY_ZF1->(dbSkip())
    end

    QRY_ZF1->(dbCloseArea())

return aRec

/*/{Protheus.doc} User Function cfGetRec
    Retorna os dados de despesas baseado em data de inicio e termino
    @type  Function
    @author Joao Paulo
    @since 16/07/2020
    /*/

USER FUNCTION cfGetDes(dIni,dFin)
    Private aRec := {}
    Private cQuery := ""

    cQuery := "select ZF1_DESCO, SUM(ZF1_VALOR) AS ZF1_VALOR "+PL
    cQuery += "from "+RetSqlName("ZF1")+" ZF1 "+PL
    cQuery += "WHERE D_E_L_E_T_ <> '*' AND ZF1_FAT = 'N' "+PL
    cQuery += "AND ZF1_DATA BETWEEN "+DTOS(dIni)+"AND "+DTOS(dFin)+" "+PL
    cQuery += "GROUP BY ZF1_DESCO ORDER BY ZF1_VALOR DESC"
    cQuery := ChangeQuery(cQuery)
    TCQuery cQuery New alias "QRY_ZF1"

    while !QRY_ZF1->(Eof())
        AADD(aRec,{QRY_ZF1->ZF1_DESCO,QRY_ZF1->ZF1_VALOR})
        QRY_ZF1->(dbSkip())
    end

    QRY_ZF1->(dbCloseArea())

return aRec
