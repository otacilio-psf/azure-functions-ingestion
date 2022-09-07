import json
import logging

import azure.functions as func

from . import api_el as el

def main(req: func.HttpRequest) -> func.HttpResponse:

    index = req.params.get('index')

    logging.info(f'Requested for {index}')
    response = el.ApiEL().start()
    return func.HttpResponse(json.dumps(response), status_code=200)