#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
#INCLUDE "FWMVCDEF.CH"

#DEFINE PL chr(13)+chr(10)

    WSRESTFUL GetCtrFin DESCRIPTION "Serviço REST inclusao de contas"

        WSDATA cGetJson As String
        
        WSMETHOD POST DESCRIPTION "Faz um lançamento" WSSYNTAX "GetCtrFin" path "GetCtrFin"
        WSMETHOD GET  DESCRIPTION "Retorna lista de objetos" WSSYNTAX "GetCtrFin" path "GetCtrFin"
    END WSRESTFUL
      

    WSMETHOD POST WSRECEIVE cGetJson WSSERVICE GetCtrFin
        Local cJson     := Self:GetContent()
        Local oJson     := nil
        Local aObj      := {}
        Local cResult   := ''
        oJson   := JsonObject():New()
        cError  := oJson:FromJson(cJson)
        self:SetContentType("text/html")
        
        IF .NOT. Empty(cError)
            SetRestFault(500,'Parser Json Error')
            lRet    := .F.
       Else
            AADD(aObj,{oJson:GetJsonObject('cCodobj')}) 
            AADD(aObj,{oJson:GetJsonObject('dataFin')})
            AADD(aObj,{oJson:GetJsonObject('valor')})
            AADD(aObj,{oJson:GetJsonObject('desc')})

            cResult := RecData(aObj)

            self:SetResponse(cResult)

            self:SetStatus(200)
        endif
    
  
Return .T.

WSMETHOD GET WSSERVICE GetCtrFin
    Local oResponse := Nil
    Local cResponse := ''
    Local aResponse := {}
    local aArea     := GetArea()

    ::SetContentType("application/json")

    DbSelectArea("ZF2")
    ZF2->(dbgotop())

    while ZF2->(!Eof())
        oResponse := JsonObject():New()
        oResponse['codigo'] := ZF2->ZF2_COD
        oResponse['desc']   := ZF2->ZF2_DESC
        AADD(aResponse,oResponse)

        ZF2->(dbSkip())
    enddo

    cResponse := FWJsonSerialize(aResponse, .F., .F., .T.)
    ::SetResponse(cResponse)

    ZF2->(dbCloseArea())

    RestArea(aArea)

Return .T.


STATIC FUNCTION RecData(aObj)
    Local aArea := GetArea()
    
   IF(aObj[1,1] <> '')
        DbSelectArea("ZF2")
        ZF2->(dbgotop())
        ZF2->(dbSetOrder(1))
        if(ZF2->(dbSeek(xFilial("ZF2")+aObj[1,1])))
            DbSelectArea("ZF1")
            RecLock("ZF1",.T.)
            ZF1->ZF1_FILIAL := '01'
            ZF1->ZF1_OBJ    := aObj[1,1]
            ZF1->ZF1_DATA   := CTOD(aObj[2,1])
            ZF1->ZF1_VALOR  := aObj[3,1]
            ZF1->ZF1_DESC   := aObj[4,1]
            ZF1->ZF1_DESCO  := ZF2->ZF2_DESC
            ZF1->ZF1_FAT    := ZF2->ZF2_FAT
            MSUnlock()
            ZF1->(dbCloseArea())
            ZF2->(dbCloseArea())
            cResult := 'Dados salvos com sucesso!!'
        else
            cResult := 'Objeto inesistente!!'
        endif
    else
        cResult := 'Objeto nao informado!!'
   endif

   RestArea(aArea)

Return cResult




