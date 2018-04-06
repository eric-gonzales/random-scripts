VAULT_ADDR=${VAULT_ADDR}
VAULT_TOKEN=${VAULT_TOKEN}
SECRET_DATA=$(curl --header "X-Vault-Token: ${VAULT_TOKEN}" ${VAULT_ADDR}/v1/secret/foo)

for key in $(echo "$SECRET_DATA" | jq -r '.["data"]' | jq keys); do
    echo $key
done

for key in $(echo "$SECRET_DATA" | jq -r '.["data"]' | jq .[]); do
    echo $key
done

for key in $(echo "$SECRET_DATA" | jq -r '.data | keys as $k | "\($k)"' ); do
    echo $key
done

for key in $(echo "$SECRET_DATA" | jq -r '.data | to_entries[] | {"": .key, "=": .value}' ); do
    echo $key
done

for secret in $(echo "$SECRET_DATA" | jq -r '.data | to_entries[] | "\(.key)=\(.value)"' ); do
    export $secret
done
