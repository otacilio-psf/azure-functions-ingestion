from azure.storage.filedatalake import DataLakeServiceClient
from azure.identity             import ClientSecretCredential
import logging
import requests
import os

tenant_id = os.getenv('AZURE_STORAGE_TENANT_ID')
client_id = os.getenv('AZURE_STORAGE_CLIENT_ID')
client_secret = os.getenv('AZURE_STORAGE_CLIENT_SECRET')

def get_file_system():
    pass


class ApiEL():

    def __init__(self):
        pass

    def _extract(self):
        pass

    def _load(self):
        pass

    def start(self):
        return {"output": "WIP"}

if __name__ == "__main__":
    pass