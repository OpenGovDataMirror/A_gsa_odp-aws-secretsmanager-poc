import secrets_manager as sm
import json
import sys

def get_secret_value(sname, skey):
    secrets = sm.get_secret(sname)
    if secrets:
        jSecrets = json.loads(secrets)
        return jSecrets[skey]

if __name__=="__main__":
    secret_name = sys.argv[1]
    secret_key = sys.argv[2]
    secret_value = get_secret_value(secret_name, secret_key)
    print("{} ==> {}".format(secret_key, secret_value))