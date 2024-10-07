{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "templates.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "templates.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "templates.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "templates.labels" -}}
helm.sh/chart: {{ include "templates.chart" . }}
app_type: {{ include "templates.fullname" . }}
{{ include "templates.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "templates.selectorLabels" -}}
app.kubernetes.io/name: {{ include "templates.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "templates.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "templates.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Kubernetes API server address block for network policies
*/}}
{{- define "templates.APIServerAddress" -}}
{{- $APIServerEndpoints := (index (lookup "v1" "Endpoints" "default" "kubernetes").subsets 0) }}
- to:
  {{- range $k, $v := $APIServerEndpoints.addresses }}
  - ipBlock:
      cidr: {{ $v.ip }}/32
  {{- end }}
  ports:
  {{- range $k, $v := $APIServerEndpoints.ports }}
  {{- if eq $v.name "https" }}
  - protocol: TCP
    port: {{ $v.port }}
  {{- end }}
  {{- end }}
{{- end }}

{{/*
Kubernetes DNS service address block for network policies
*/}}
{{- define "templates.KubeDNSAddress" -}}
{{- if (lookup "v1" "Service" "kube-system" "kube-dns") }}
{{- print (lookup "v1" "Service" "kube-system" "kube-dns").spec.clusterIP "/32" }}
{{- end }}
{{- if (lookup "v1" "Service" "kube-system" "coredns") }}
{{- print (lookup "v1" "Service" "kube-system" "coredns").spec.clusterIP "/32" }}
{{- end }}
{{- end }}

{{/*
Allow KubeVersion to be overridden
*/}}
{{- define "templates.kubeVersion" -}}
  {{- default .Capabilities.KubeVersion.Version .Values.kubeVersionOverride -}}
{{- end -}}

{{/*
Create set of annotations for vault-webhook
*/}}
{{- define "webhook.vaultAnnotations" -}}
vault.security.banzaicloud.io/vault-addr: "https://vault.your.domain.com:8200"
vault.security.banzaicloud.io/vault-role: {{ .Values.vaultWebhook.role  }}
vault.security.banzaicloud.io/vault-skip-verify: "true"
vault.security.banzaicloud.io/vault-path: {{ .Values.vaultWebhook.path }}
{{- end }}
