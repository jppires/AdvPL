#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE PL chr(13)+chr(10)

    WSRESTFUL ListCtrFin DESCRIPTION "Serviço REST listagem de contas"
        WSDATA cMes As String
        WSDATA cAno As String

        WSMETHOD GET  DESCRIPTION "Retorna lista de Contas" WSSYNTAX "ListCtrFin" path "ListCtrFin"
    END WSRESTFUL      

WSMETHOD GET WSRECEIVE cMes,cAno WSSERVICE ListCtrFin
    Local cMesAno   := Self:cAno+Self:cMes
    Local cQuery    := ''
    Local oResponse := Nil
    Local aResponse := {}
    local aArea     := GetArea()
    
    ::SetContentType("application/json")

    cQuery += "SELECT  "                                                            +PL
    cQuery += "Z1.ZF1_DATA as DATE, "                                               +PL
    cQuery += "Z2.ZF2_DESC as OBJ, "                                                +PL
    cQuery += "Z1.ZF1_VALOR as VALOR, "                                             +PL
    cQuery += "Z1.ZF1_DESC as DESCR, "                                               +PL
    cQuery += "Z1.ZF1_FAT as FAT "                                                   +PL
    cQuery += "FROM "+RetSqlName("ZF1")+" Z1 JOIN "+RetSqlName("ZF2")+" Z2  "       +PL
    cQuery += "ON Z1.ZF1_OBJ = ZF2_COD "                                            +PL
    cQuery += "WHERE  "                                                             +PL
    cQuery += "Z1.ZF1_DATA >= '"+cMesAno+"01' AND Z1.ZF1_DATA <= '"+cMesAno+"31' "  +PL
    cQuery += "AND Z1.D_E_L_E_T_ = '' AND Z2.D_E_L_E_T_ = '' "                      +PL
    cQuery += "ORDER BY Z1.ZF1_FAT DESC "                                           +PL
    cQuery := ChangeQuery(cQuery)

    if SELECT("QRY1") <> 0
        dbSelectArea("QRY1")
        dbCloseArea()
    endif

    TCQuery cQuery new alias "QRY1"
    TCSETFIELD( "QRY1","DATE","D")

    QRY1->(dbGoTop())

     while QRY1->(!Eof())
        oResponse := JsonObject():New()
        oResponse['date']   := DTOC(QRY1->DATE)
        oResponse['obj']    := QRY1->OBJ
        oResponse['valor']  := QRY1->VALOR
        oResponse['descr']  := QRY1->DESCR
        oResponse['fat']    := QRY1->FAT
        AADD(aResponse,oResponse)
        QRY1->(dbSkip())
    enddo

    cResponse := FWJsonSerialize(aResponse, .F., .F., .T.)
    ::SetResponse(cResponse)

    QRY1->(dbCloseArea())
    RestArea(aArea)

Return .T.
           
