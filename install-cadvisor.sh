# create monitoring namespace, if it doesn't exist
kubectl get ns cadvisor 2> /dev/null
if [ $? -eq 1 ]
then
    kubectl create namespace cadvisor
fi

# create a clusterRole
kubectl apply -f cluster/cadvisor/clusterRole.yml

# You need a configmap for all of Prometheus’s configurations and alert rules.
# This is a crucial step since you’ll put the configuration related to
# cAdvisor and other jobs like Node Exporter in this file.
# This will create two files inside the container, one containing 
# configurations to discover pods and running services in Kubernetes,
# and one containing the alert rules for sending alerts to the alert manager.
kubectl apply -f cluster/cadvisor/config-map.yml

# create deployment of prometheus
kubectl apply -f cluster/cadvisor/prometheus-deployment.yml

# create the prometheus server
kubectl apply -f cluster/cadvisor/prometheus-service.yml

# create the prometheus datasource for grafana
kubectl apply -f cluster/cadvisor/grafana-datasource-config.yml

# create the grafana dashboards
kubectl apply -f cluster/cadvisor/grafana-dashboards.yaml

# create deployment of grafana
kubectl apply -f cluster/cadvisor/grafana-deployment.yml

# create the grafana-server
kubectl apply -f cluster/cadvisor/grafana-service.yml

# now in grafana ui, import the dashboard 14282 - need to find out how to
# do this in code!

# show the deployments and the pods - `grafana` and `prompetheus-deployment`
# should be listed.
kubectl get deployments -n cadvisor
kubectl get pods -n cadvisor
