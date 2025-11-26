# Kubernetes Security Configuration

## Статус конфигов

Для Kubernetes всё готово. Полный набор конфигурационных файлов для CIS Kubernetes Benchmark v1.10.

## Готовые конфиги

| Файл | Назначение | Статус |
|------|------------|--------|
| `deployment-cis-compliant.yaml` | Шаблон CIS-совместимого Deployment | + |
| `pod-security-policy.yaml` | PSP с ограничениями (deprecated в K8s 1.25+) | + |
| `pod-security-admission.yaml` | Pod Security Admission для K8s 1.25+ | + |
| `capabilities-config.yaml` | ConfigMap с профилями capabilities | + |
| `kube-bench-custom.yaml` | Кастомные проверки для kube-bench | + |
| `validating-webhook.yaml` | Admission webhook + Python логика | + |
| `opa-gatekeeper-pod-security.yaml` | OPA политики для pod security | + |
| `opa-gatekeeper-networkpolicy.yaml` | OPA политики для NetworkPolicy | + |

## Покрытие CIS Kubernetes v1.10

### Контроль 5.2 - Pod Security Policies
- **5.2.2** — Запрет privileged контейнеров
- **5.2.4** — `allowPrivilegeEscalation: false`
- **5.2.5/5.2.6** — `runAsNonRoot`, явный UID
- **5.2.7/5.2.8** — `drop: ALL` capabilities

### Контроль 5.3 - Network Policies
- **5.3.2** — NetworkPolicy enforcement

### Контроль 5.7 - Runtime Security
- **5.7.2** — Seccomp `RuntimeDefault`

## Pod Security Standards (K8s 1.25+)

| Уровень | Что разрешено | Использование |
|---------|---------------|---------------|
| **privileged** | Всё (только для системных компонентов) | `kube-system` |
| **baseline** | Минимальные ограничения (без privileged, hostNetwork) | `staging` |
| **restricted** | Строгий режим (runAsNonRoot, drop ALL caps, seccomp) | `production` |

## Конфигурация Pod Security Admission

### Namespace Labels

```yaml
# Production - Restricted (самый строгий)
metadata:
  labels:
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/audit: restricted
    pod-security.kubernetes.io/warn: restricted

# Staging - Baseline
metadata:
  labels:
    pod-security.kubernetes.io/enforce: baseline
    pod-security.kubernetes.io/audit: restricted
    pod-security.kubernetes.io/warn: restricted

# System - Privileged
metadata:
  labels:
    pod-security.kubernetes.io/enforce: privileged
```

### Кластерный конфиг (kube-apiserver)

```yaml
# /etc/kubernetes/admission/config.yaml
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
- name: PodSecurity
  configuration:
    apiVersion: pod-security.admission.config.k8s.io/v1
    kind: PodSecurityConfiguration
    defaults:
      enforce: baseline
      audit: restricted
      warn: restricted
    exemptions:
      namespaces:
        - kube-system
        - kube-public
        - kube-node-lease
```

## Пример CIS-совместимого Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: secure-app
  namespace: production
spec:
  template:
    spec:
      securityContext:
        runAsNonRoot: true
        runAsUser: 10001
        fsGroup: 10001
        seccompProfile:
          type: RuntimeDefault
      containers:
      - name: app
        securityContext:
          allowPrivilegeEscalation: false
          readOnlyRootFilesystem: true
          runAsNonRoot: true
          capabilities:
            drop:
              - ALL
```

## Применение конфигов

```bash
# Применить все конфигурации
kubectl apply -f deployment-cis-compliant.yaml
kubectl apply -f pod-security-admission.yaml
kubectl apply -f capabilities-config.yaml
kubectl apply -f opa-gatekeeper-pod-security.yaml
kubectl apply -f opa-gatekeeper-networkpolicy.yaml

# Для webhook (требует сборки образа)
kubectl apply -f validating-webhook.yaml

# Проверить compliance
kubectl get pods -n production
kubectl get networkpolicy -n production
```

## Валидация с kube-bench

```bash
# Запустить кастомные проверки
kube-bench run --config kube-bench-custom.yaml

# Проверить результаты
kube-bench run --config kube-bench-custom.yaml --json > compliance-report.json
```

## Замечания и TODO

### PSP Deprecated
- `pod-security-policy.yaml` использует `policy/v1beta1`, удалённый в K8s 1.25+
- Используйте `pod-security-admission.yaml` для новых кластеров

### 🔧 Webhook Setup Required
- В `validating-webhook.yaml` указан placeholder `capabilities-validator:latest`
- Нужно собрать образ из Python-кода в ConfigMap
- `caBundle` содержит placeholder - сгенерируйте реальные сертификаты

### Migration Path
1. **Legacy (≤1.24)**: Используйте `pod-security-policy.yaml`
2. **Modern (≥1.25)**: Используйте `pod-security-admission.yaml`
3. **Advanced**: OPA Gatekeeper + Admission Webhooks

## Мониторинг и аудит

```bash
# Проверить violations в restricted namespace
kubectl get events -n production --field-selector reason=Violation

# Audit log для Pod Security
kubectl get events --field-selector type=Warning

# Проверить NetworkPolicy violations
kubectl get networkpolicy -A -o wide
```

## Дополнительные ресурсы

- [CIS Kubernetes Benchmark v1.10](https://www.scribd.com/document/869161543/CIS-Kubernetes-Benchmark-v1-10-PDF)
- [Pod Security Standards Documentation](https://kubernetes.io/docs/concepts/security/pod-security-standards/)
- [OPA Gatekeeper](https://open-policy-agent.github.io/gatekeeper/)

---

