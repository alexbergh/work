Замечания
PSP deprecated — pod-security-policy.yaml
использует policy/v1beta1, который удалён в K8s 1.25+. Для новых кластеров используйте Pod Security Admission или OPA Gatekeeper.
Webhook image —  validating-webhook.yaml
указан placeholder capabilities-validator:latest. Нужно собрать образ из Python-кода в ConfigMap.
TLS сертификаты — caBundle в webhook содержит placeholder. Нужно сгенерировать реальные сертификаты.
