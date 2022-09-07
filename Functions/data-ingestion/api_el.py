from azure.storage.filedatalake import DataLakeServiceClient
from azure.identity             import ClientSecretCredential

import requests
import logging
import time
import os
import io

def get_file_system():
    credential = ClientSecretCredential(
        tenant_id=os.getenv('AZURE_STORAGE_TENANT_ID'),
        client_id=os.getenv('AZURE_STORAGE_CLIENT_ID'),
        client_secret=os.getenv('AZURE_STORAGE_SECRET_ID')
    )

    account_name = os.getenv('AZURE_STORAGE_ACCOUNT_NAME')
    container_name = os.getenv('AZURE_STORAGE_CONTAINER_NAME')
    account_url = f"https://{account_name}.dfs.core.windows.net"

    try:
        adls = DataLakeServiceClient(account_url=account_url, credential=credential)
        return adls.get_file_system_client(file_system=container_name)
    except Exception as e:
        logging.error(e)
        raise Exception


class ApiEL():

    def __init__(self, url):
        self._url = url
        self._input_file = io.BytesIO()

    def _extract(self):
        r = requests.get(self._url, stream=True)
        if r.status_code == requests.codes.OK:
            for part in r.iter_content(chunk_size=256):
                self._input_file.write(part)
        else:
            r.raise_for_status()
        self._input_file.seek(0)

    def _load(self):
        try:
            fs = get_file_system()
            file_name = f"base_{int(time.time())}.json"
            file_client = fs.get_file_client(f"raw/{file_name}")
            file_client.upload_data(self._input_file.getvalue(), overwrite=True)
            return_msg = f"{file_name}"
            return {
                "status": "success",
                "menssage": return_msg
            }
        except Exception as e:
            logging.error(e)
            return {
                "status": "error",
                "menssage": e
            }

    def start(self):
        self._extract()
        return self._load()

if __name__ == "__main__":
    url = "https://dadosabertos.nubank.com.br/taxasCartoes/itens"
    r = ApiEL(url).start()
    print(r)