#INCLUDE 'TOTVS.CH'
#INCLUDE 'PROTHEUS.CH'


USER FUNCTION cfPrincipal()

PRIVATE cCadastro  := "Cadastro de Lançamentos"
private  aRotina     := {}
private aCores :={}
private aArea := GetArea()
private cString := "ZF1"


aRotina := {{"Pesquisar","AxPesqui",0,1},;
            {"Visualizar","AxVisual",0,2},;
            {"Incluir","AxInclui",0,3},;
            {"Alterar","AxAltera",0,4},;
            {"Excluir","AxDeleta",0,5},;
            {"Legenda","u_cfLeg",0,6},;
            {"Calculo","u_cfShwCalc",0,7}}

dbSelectArea("ZF1")
dbSetOrder(1)


aCores := {{"ZF1_FAT='P'","BR_AZUL"},;
            {"ZF1_FAT='N'","BR_VERMELHO"},;
            {"ZF1_FAT='I'","BR_LARANJA"}}

dbSelectArea(cString)

MBrowse(6,1,22,75,cString,,,,,,aCores)

(cString)->(dbCloseArea())


RestArea(aArea)

Return Nil

USER FUNCTION cfLeg()
    Local aLegenda := {}

    AADD(aLegenda,{"BR_AZUL" ,"Receita" })
    AADD(aLegenda,{"BR_VERMELHO" ,"Despesa" })
    AADD(aLegenda,{"BR_LARANJA" ,"Investimento" })
	
	BrwLegenda("Legenda", "Legenda", aLegenda)
return

USER FUNCTION cfObjeto()
    PRIVATE cCadastro := "Cadastro de objetos"

    private aRotina := {}

    AxCadastro("ZF2",cCadastro,".T.",".T.")

return nil


