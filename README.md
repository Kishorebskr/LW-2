# Lamp Service - DevOps Assessment

Simple catalog service for Luminara lamps. 

## Quick Start

Need minikube running first:
```bash
minikube start
minikube addons enable ingress
```

Build and deploy:
```bash
./scripts/build.sh
./scripts/deploy.sh
```

Test it:
```bash
# get service URL (easiest way)
minikube service lamp-svc --url

# or manually
export SERVICE_URL=http://$(minikube ip):$(kubectl get svc lamp-svc -o jsonpath='{.spec.ports[0].nodePort}')
curl $SERVICE_URL/healthz
curl $SERVICE_URL/lamps
```

## What's included

- FastAPI app with prometheus metrics
- K8s deployment with health checks and scaling
- Terraform configs (alternative to kubectl)
- CI/CD pipeline for GitHub Actions  
- Varnish cache config (example)
- Basic monitoring alerts

## Architecture

```
Client -> NodePort -> Service -> Pod(s)
                                  |
                              Prometheus metrics
```

## Terraform Usage

Alternative to kubectl (creates same resources):
```bash
cd terraform
terraform init
terraform apply
```

Note: Don't run both kubectl and terraform deployments at same time - they create the same resources.

## Caching

`varnish.vcl` shows example cache config for production. For this assessment it demonstrates understanding of:
- TTL strategies for different endpoints
- Cache bypass for health checks
- Performance headers

## Monitoring

Prometheus metrics at `/metrics`. Example alerts in `alerts.yml` show production monitoring approach.

## Troubleshooting

**Build fails**: Check minikube is running with `minikube status`

**Deploy fails**: Verify image exists with `docker images | grep lamp-svc`

**Service unreachable**: Get URL with `minikube service lamp-svc --url`

**Terraform conflicts**: Run `kubectl delete deployment,service lamp-svc` before terraform

## Assessment Notes

This solution demonstrates:
- Practical DevOps approach (not over-engineered)
- Production patterns (health checks, resource limits, monitoring)
- IaC with both kubectl and Terraform options
- Understanding of caching and observability concepts
