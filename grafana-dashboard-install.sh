#!/usr/bin/env bash

USAGE="$0 <grafana_admin_user> <grafana_admin_password> <dashboard_number>"

if [ $# -ne 3 ]
then
    echo $USAGE
    exit -1
fi

### Please edit grafana_* variables to match your Grafana setup:
grafana_host="http://dev.ellisbs.co.uk:32000"
grafana_cred="${1}:${2}"
grafana_datasource="prometheus"
ds=(${3});
for d in "${ds[@]}"; do
  echo -n "Processing $d: "
  j=$(curl -s -k -u "$grafana_cred" $grafana_host/api/gnet/dashboards/$d | jq .json)
  curl -s -k -u "$grafana_cred" -XPOST -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -d "{\"dashboard\":$j,\"overwrite\":true, \
        \"inputs\":[{\"name\":\"DS_PROMETHEUS\",\"type\":\"datasource\", \
        \"pluginId\":\"cloudwatch\",\"value\":\"$grafana_datasource\"}]}" \
    $grafana_host/api/dashboards/import; echo ""
done
