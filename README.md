# Assignment readme
> The code is in the subfolders. The kubernetes yaml files are heavily commented but you can also see my summary below. I included terraform files as well to show you how I'd approach that. No CI/CD at this time.

## Task 1 - Build

| Task | Solution |
| ------ | ------ |
| Fetch the following image from DockerHub (Just a simple nginx deployment), and let's build a kubernetes deployment on top of it. | The deployment pulls the image from DockerHub

## Task 2 - Deployment
| Task | Solution |
| ------ | ------ |
| Create the necessary deployment resources to deploy the created app to a K8s cluster | 01-deployment.yaml
| Create a LoadBalancer for the App. It can use Service, NodePort, or an Ingress | 02-service.yaml

## Task 3 - Availability
| Task | Solution |
| ------ | ------ |
| Ensure the application can resist without downtime to host issues, and maintenance operations (at all times we should be able to query the /status endpoint with success) | deployment set to 3 replicas, rollingupdate maxsurge + maxunavailable set, autoscaler added, health check added (probes)
| Ensure application pods are distributed across the cluster nodes. We want to avoid all pods for the application residing on the same node | podAntiAffinity added to deployment to distribute the pods 

## Task 4 - Performance
| Task | Solution |
| ------ | ------ |
| It will be easier for you to test if you restrict the resources allocated to your deployment. |  Container resource limits + requests added
| Ensure App can scale up and down as needed with load. | Added horizontal pod autoscaler
| If CPU usage is over 70%, increase the number of pods | Behavior ScaleUp policy added in the spec
| If the CPU goes below 30% reduce the number of pods. | Behavior ScaleDown policy added in the spec

## Task 5 - Security
| Task | Solution |
| ------ | ------ |
| Ensure we cannot SSH into deployed containers. | Two networkpolicies added, one blocks ingress and the other re-allows HTTP.
| Ensure we do not run the application container in privileged mode. | SecurityContext added (privilege escalation / privileged set to false). Nginx port could be moved to an unprivileged port in the future.
 
## Task 6 - CI/CD
| Task | Solution |
| ------ | ------ |
| We should have an automated pipeline to build and deploy the changes, for example a CI/CD pipeline on Gitlab. | No solution provided at this time


