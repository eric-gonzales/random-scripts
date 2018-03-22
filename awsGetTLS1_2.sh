 lb_policies=$(aws elb describe-load-balancer-policies --query 'PolicyDescriptions[]')

 for policy in $(echo "${lb_policies}" | jq -r '.[] | @base64'); do
     _containsPolicy() {
         policy_descriptions=$(echo ${policy} | base64 --decode | jq -c '.PolicyAttributeDescriptions')
         if [[ "${policy_descriptions}" = *"\"AttributeName\":\"${1}\",\"AttributeValue\":\"true\""* &&
             "${policy_descriptions}" = *"\"AttributeName\":\"Protocol-SSLv3\",\"AttributeValue\":\"false\""* &&
             "${policy_descriptions}" = *"\"AttributeName\":\"Protocol-TLSv1\",\"AttributeValue\":\"false\""* &&
             "${policy_descriptions}" = *"\"AttributeName\":\"Protocol-TLSv1.1\",\"AttributeValue\":\"false\""* ]]; then
                 echo ${policy} | base64 --decode | jq -r '.PolicyName'
         fi
     }

     _containsPolicy 'Protocol-TLSv1.2'
 done
