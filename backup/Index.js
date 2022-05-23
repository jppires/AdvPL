$(document).ready(function(){
    $('#Data').mask("00/00/0000");
	 $('#mes').mask("00");
	 $('#ano').mask("0000");
    $('#Valor').mask('###0.00', {reverse: true});
});

function sendJSON(){ 
            var result  = document.querySelector('.result'); 
            var cCodobj = document.querySelector('#cCodobj'); 
            var dataFin = document.querySelector('#Data'); 
			var valor   = document.querySelector('#Valor'); 
			var desc    = document.querySelector('#Desc'); 
               
            // Creating a XHR object 
            var xhr     = new XMLHttpRequest(); 
            var url     = "http://localhost:8085/rest/GetCtrFin"; 
           
        
            // open a connection 
            xhr.open("POST", url, true); 
            xhr.timeout = 2000;
  
            // Set the request header i.e. which type of content you are sending 
            xhr.setRequestHeader("Content-Type", "application/json"); 
  
            // Create a state change callback 
            xhr.onreadystatechange = function () { 
                if (xhr.readyState === 4 && xhr.status === 200) { 
  
                    // Print received data from server 
                    alert(this.responseText); 
                    window.location.reload();
  
                } 
            }; 

            xhr.ontimeout = function () {
                result.innerHTML = '<p style="color:red">Servidor nao responde!!</p>';
              };

              xhr.onerror = function () {
                result.innerHTML = 'Falha na conexão com o servidor!! Erro: '+xhr.responseText;
              };
			
           // Mounting Json 
            var data = '{';
                data += '"cCodobj":"'+cCodobj.value+'",';
                data += '"dataFin":"'+dataFin.value+'",';  
                data += '"valor":'   +valor.value+',';
                data += '"desc":"'   +desc.value+'"';
                data += '}'

            // Sending data with the request 
            xhr.send(data); 

            xhr.onload = function () {              
 
                result.innerHTML = this.responseText; 

            }
        } 
		

function erase(){
    var cCodobj = document.querySelector('#cCodobj'); 
    var dataFin = document.querySelector('#Data'); 
    var valor   = document.querySelector('#Valor'); 
    var desc    = document.querySelector('#Desc'); 
    
    cCodobj.value   = ''
    dataFin.value   = ''
    valor.value     = ''
    desc.value      = ''
    
}        

function getData(){
			var mes 	= document.querySelector ('#mes');
			var ano 	= document.querySelector ('#ano');
			
			if (mes.value < 0 || mes.value > 12) {
				alert("Mes invalido");
				return;
			}

}

function ShowObj(){
	var requestURL = "http://localhost:8085/rest/GetCtrFin/";
	var request = new XMLHttpRequest();
	var objetos = null;
	
	request.open('GET', requestURL);
	request.responseType = 'json';
	request.send();
	
	 request.onreadystatechange = function () { 
                if (request.readyState === 4 && request.status === 200) { 
				   objetos = request.response;
				   montaobj(objetos);
                  }
            }; 
	
	 request.onload = function () {              
 
                 objetos = request.response;
				   montaobj(objetos);

            } 

}

function montaobj(obj){
	var divObj = "";
	var resultDivObj = document.querySelector('.divObj'); 
	
	divObj = '<div class="modal fade" id="ExemploModalCentralizado" tabindex="-1" role="dialog" aria-labelledby="TituloModalCentralizado" aria-hidden="true"> ';
	divObj += '<div class="modal-dialog modal-dialog-centered" role="document"> ';
    divObj += '<div class="modal-content"> ';
    divObj += '  <div class="modal-header"> ';
    divObj += '   <h5 class="modal-title" id="TituloModalCentralizado">Objetos</h5> ';
    divObj += '		 <button type="button" class="close" data-dismiss="modal" aria-label="Fechar"> ';
    divObj += '      <span aria-hidden="true">&times;</span> ';
    divObj += '    </button> ';
    divObj += '  </div> ';
    divObj += '  <div class="modal-body"> ';
	
	 for (var i = 0; i < obj.length; i++) {
			divObj += '    <input type="radio" name="obj" value="'+obj[i].codigo+'"> ';
			divObj += '	<label>'+obj[i].desc+'</label><br>';
	 }	
	
	
    divObj += '  </div> ';
    divObj += '  <div class="modal-footer"> ';
    divObj += '    <button type="button" class="btn btn-secondary" data-dismiss="modal">Fechar</button> ';
    divObj += '    <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="getObj()">Selecionar</button> ';
    divObj += '  </div> ';
    divObj += '</div> ';
    divObj += '</div> ';
    divObj += '</div> ';
	
	resultDivObj.innerHTML = divObj;
	
}

function getObj(){
	var radios = document.getElementsByName("obj");
	var obj = document.querySelector('#cCodobj');

    for (var i = 0; i < radios.length; i++) {
        if (radios[i].checked) {
            obj.value = radios[i].value;
			return;
        }
    }
}