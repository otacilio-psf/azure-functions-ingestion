import json
import logging
from datetime import date

import azure.functions as func

from . import api_el as el

def main(req: func.HttpRequest) -> func.HttpResponse:

    index = req.params.get('index')

    logging.info(f'Requested for {index}')
    
    if index == 'nubank':
        url = 'https://dadosabertos.nubank.com.br/taxasCartoes/itens'
        response = el.ApiEL(url, index).start()
    elif index == 'bradesco':
        url = 'https://openapi.bradesco.com.br/bradesco/dadosabertos/taxasCartoes/itens'
        response = el.ApiEL(url, index).start()
    elif index == 'dolar':
        start_date = '08-25-2019' #first date in taxs (nubank)
        final_date = date.today().strftime("%m-%d-%Y")
        url = f"https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/CotacaoDolarPeriodo(dataInicial=@dataInicial,dataFinalCotacao=@dataFinalCotacao)?@dataInicial='{start_date}'&@dataFinalCotacao='{final_date}'&$format=json"
        response = el.ApiEL(url, index).start()
    else:
        response = {
            "status": "fail",
            "menssage": "unknow mode"
             }

    response["index"] = index

    if response["status"] == "success":
        return func.HttpResponse(json.dumps(response), status_code=200)
    elif response["status"] == "fail":
        return func.HttpResponse(json.dumps(response), status_code=400)
    else:
        return func.HttpResponse(json.dumps(response), status_code=500)