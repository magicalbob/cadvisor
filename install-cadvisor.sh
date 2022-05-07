# create monitoring namespace, if it doesn't exist
kubectl get ns monitoring 2> /dev/null
if [ $? -eq 1 ]
then
    kubectl create namespace monitoring
fi

# create a clusterRole
kubectl apply -f clusterRole.yml

# You need a configmap for all of Prometheus’s configurations and alert rules.
# This is a crucial step since you’ll put the configuration related to
# cAdvisor and other jobs like Node Exporter in this file.
# This will create two files inside the container, one containing 
# configurations to discover pods and running services in Kubernetes,
# and one containing the alert rules for sending alerts to the alert manager.
kubectl apply -f config-map.yml

# create deployment of prometheus
kubectl apply -f prometheus-deployment.yml

# create the prometheus server
kubectl apply -f prometheus-service.yml

# create the prometheus datasource for grafana
kubectl apply -f grafana-datasource-config.yml

# create deployment of grafana
kubectl apply -f grafana-deployment.yml

# create the grafana-server
kubectl apply -f grafana-service.yml

# now in grafana ui, import the dashboard 14282 - need to find out how to
# do this in code!

# show the deployments and the pods - `grafana` and `prompetheus-deployment`
# should be listed.
kubectl get deployments -n monitoring
kubectl get pods -n monitoring
