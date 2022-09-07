import json
import logging

import azure.functions as func

from . import api_el as el

def main(req: func.HttpRequest) -> func.HttpResponse:

    index = req.params.get('index')

    logging.info(f'Requested for {index}')
    url = "https://dadosabertos.nubank.com.br/taxasCartoes/itens"
    response = el.ApiEL(url).start()
    response["index"] = index

    return func.HttpResponse(json.dumps(response), status_code=200)