{{/*
Expand the name of the chart.
*/}}
{{- define "py_log_demo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "py_log_demo.fullname" -}}
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
{{- define "py_log_demo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "py_log_demo.labels" -}}
helm.sh/chart: {{ include "py_log_demo.chart" . }}
helm.sh/chart: {{ include "py_log_demo.chart" . }}
{{ include "py_log_demo.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "py_log_demo.selectorLabels" -}}
app.kubernetes.io/name: {{ include "py_log_demo.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/type: {{ .Values.type }}
{{- end }}

{{/*
Deployment annotations
*/}}
{{- define "py_log_demo.annotations" -}}
app.kubernetes.io/name: {{ include "py_log_demo.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/type: {{ .Values.type }}
prometheus.io/scrape: {{ .Values.monitoring.enabled | default "false" | quote }}
prometheus.io/path: {{ .Values.monitoring.metrics_path | default "/metrics" | quote }}
prometheus.io/port: {{ .Values.monitoring.metrics_port_number | default "8080" | quote }}
{{- end }}
