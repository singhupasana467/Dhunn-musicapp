# Music Streaming Backend – DevOps Implementation

This repository presents a complete DevOps pipeline for deploying a containerized backend music streaming application. It integrates CI/CD automation, GitOps workflows, container orchestration, real-time monitoring, and vulnerability scanning using modern open-source tools.

---

## Key Technologies

- **Docker** – Containerization of backend and MySQL services  
- **Kubernetes** – Orchestration, scaling, and service networking  
- **Helm** – Declarative deployment using templated charts  
- **Argo CD** – GitOps-based synchronization of manifests  
- **GitHub Actions** – CI/CD automation and tool installation  
- **Prometheus & Grafana** – Monitoring and alerting  
- **Trivy** – Vulnerability scanning during build  
- **Ingress Controller** – Secure routing of external traffic

---

## Architecture Overview

```
GitHub Repo (Helm Charts & Manifests)
        ↓
GitHub Actions (CI/CD Pipeline)
        ↓
Docker (Build & Containerize)
        ↓
Trivy (Security Scan)
        ↓
Kubernetes Cluster
        ├─ Helm (Deploy Resources)
        ├─ Argo CD (GitOps Sync)
        ├─ Prometheus (Metrics Collection)
        ├─ Grafana (Visualization & Alerts)
        └─ Ingress Controller (External Access)
```

---

## Setup Instructions

### Prerequisites

- Kubernetes cluster (local or cloud)
- kubectl configured
- Helm installed
- GitHub repository with Helm charts and manifests
- Self-hosted GitHub Actions runner (Windows)

### Argo CD Installation

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### Access Argo CD UI

```bash
kubectl port-forward svc/argocd-server -n argocd 8088:443
```

Visit: `https://localhost:8088`

### Login to Argo CD

```bash
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
argocd login localhost:8088 --username admin --password <password> --insecure
```

### Deploy Applications via Argo CD

Define each service using an Argo CD Application manifest pointing to its Helm chart path in GitHub. Apply these manifests to the `argocd` namespace.

### CI/CD Pipeline with GitHub Actions

- Installs Trivy, Helm, and kubectl on the runner  
- Configures Kubernetes access using base64-encoded kubeconfig  
- Scans Docker images for vulnerabilities  
- Installs NGINX Ingress Controller if not present  
- Deploys services using Helm

### Monitoring Setup

```bash
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring
helm install grafana ./grafana-chart -n monitoring
```

### Ingress Controller

```bash
helm install ingress-nginx ingress-nginx/ingress-nginx -n musicapp-net
```

---

## Usage Guide

### CI/CD Workflow

1. Developer pushes code or chart updates to GitHub  
2. GitHub Actions pipeline triggers:
   - Docker image build
   - Trivy vulnerability scan
   - Helm deployment to Kubernetes  
3. Argo CD syncs manifests from GitHub to cluster  
4. Prometheus collects metrics  
5. Grafana visualizes performance and alerts

### Access URLs

| Service           | Namespace     | Access URL                   |
|------------------|---------------|------------------------------|
| Backend API       | musicapp-net  | http://localhost:8080        |
| Prometheus        | monitoring    | http://prometheus.devops.local |
| Grafana           | monitoring    | http://grafana.devops.local    |
| Argo CD UI        | argocd        | https://localhost:8088       |

### Applications Managed by Argo CD

| Application Name | Namespace     | Status  | Sync Status | Chart Path                                      |
|------------------|---------------|---------|-------------|-------------------------------------------------|
| dhunn-backend    | musicapp-net  | Healthy | Synced      | musicapp-helm/dhunn-backend-chart               |
| dhunn-mysql      | musicapp-net  | Healthy | Synced      | musicapp-helm/dhunn-mysql-chart                 |
| grafana          | monitoring    | Healthy | Synced      | musicapp-helm/grafana-chart                     |
| prometheus       | monitoring    | Healthy | Synced      | musicapp-helm/prometheus-chart                  |
| ingress          | musicapp-net  | Healthy | Synced      | musicapp-helm/ingress                           |
| windows-exporter | musicapp-net  | Healthy | Synced      | musicapp-helm/window-exporter-chart             |

### Monitoring & Alerting

- Prometheus tracks pod lifecycle, resource usage, and service health  
- Grafana dashboards visualize metrics  
- Alerts configured for:
  - Pod failures
  - CPU/memory exhaustion  
- Email notifications enabled for critical events

### Security Integration

- Trivy scans Docker images during CI  
- Only secure builds are deployed  
- Scan results stored as JSON artifacts  
- Optional Slack/email alerts for vulnerabilities

### Docker Optimization Summary

| Metric        | Before Optimization | After Optimization |
|---------------|----------------------|--------------------|
| Image Size    | 2.5 GB               | 482 MB             |

**Techniques Used:**
- Alpine base image  
- Multi-stage builds  
- Cache cleanup  
- Dependency pruning
