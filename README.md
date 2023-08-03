
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Kubernetes Nodes with Disk Pressure
---

Kubernetes is a popular container orchestration system used to manage and deploy containerized applications. Kubernetes nodes are the individual servers in a Kubernetes cluster that run the containers. Disk pressure is a condition where a node is using too much disk space or is using disk space too fast according to the thresholds set in the Kubernetes configuration. This condition can be caused by applications legitimately needing more space or an application misbehaving and filling up the disk prematurely in an unanticipated manner. It is important to monitor disk pressure as it can lead to performance issues, instability, or even downtime. When a Kubernetes node experiences disk pressure, it can trigger an incident that needs to be addressed to ensure the stability of the cluster.

### Parameters
```shell
# Environment Variables

export NODE_NAME="PLACEHOLDER"

export CONTAINER_NAME="PLACEHOLDER"

export DISK_SPACE_LIMIT="PLACEHOLDER"

```

## Debug

### Get a list of nodes in the Kubernetes cluster
```shell
kubectl get nodes
```

### Check the disk usage on a specific node
```shell
kubectl ssh ${NODE_NAME} df -h
```

### Check if the Kubernetes nodes are running out of disk space
```shell
kubectl get nodes --field-selector spec.unschedulable=true
```

### Check the Kubernetes event logs for any disk-related errors
```shell
kubectl get events --field-selector involvedObject.kind=Node,reason=OutOfDisk
```

### Check if any pods are using a lot of disk space
```shell
kubectl get pods --all-namespaces -o json | jq '.items[].spec.containers[].resources.requests.storage' | grep -v null
```

### Check which namespaces are using the most disk space
```shell
kubectl get namespace --no-headers | xargs -I {} sh -c 'echo {}; kubectl get pods -n {} --no-headers | xargs -I {} sh -c "kubectl logs {} -n {} | wc -c"' | awk '{print $1" "($2/1024/1024)" MB"}' | sort -k2 -n -r | head
```
## Repair

### Cordon and then drain the node.
```shell
kubectl cordon $NODE_NAME && kubectl drain $NODE_NAME--ignore-daemonsets --delete-local-data

```