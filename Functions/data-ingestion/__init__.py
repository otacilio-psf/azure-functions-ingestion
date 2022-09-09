import json
import logging
from datetime import date

import azure.functions as func

from . import api_el as el

def main(req: func.HttpRequest) -> func.HttpResponse:

    req_method = req.method
    logging.info(f'Recived a {req_method} request')

    if req_method.upper() == 'GET':
        response = {
            "docs": "check how to use on https://github.com/otacilio-psf/azure-functions-ingestion#sample-request"
        }
        return func.HttpResponse(json.dumps(response), status_code=200)

    body_content = req.get_json()

    api_name = body_content.get('api_name')
    url = body_content.get('url')
    
    if (api_name != str()) or (url != str()):
        response = {
            "status": "fail",
            "menssage": "api_name or url invalid"
        }
        return func.HttpResponse(json.dumps(response), status_code=400)

    response = el.ApiEL(url, api_name).start()

    if response["status"] == "success":
        return func.HttpResponse(json.dumps(response), status_code=200)
    elif response["status"] == "fail":
        return func.HttpResponse(json.dumps(response), status_code=400)
    else:
        return func.HttpResponse(json.dumps(response), status_code=500)