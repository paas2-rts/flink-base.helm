{{/*
ServiceAccount for Jobmanager
*/}}
{{- define "jobmanager.serviceAccount" -}}
{{ default ( printf "%s-jobmanager" ( include "flink.fullname" . ) ) .Values.global.jobmanager.serviceAccount.name }}
{{- end -}}

{{/*
ServiceAccount for Taskmanager
*/}}
{{- define "taskmanager.serviceAccount" -}}
{{ default ( printf "%s-taskmanager" ( include "flink.fullname" . ) ) .Values.global.taskmanager.serviceAccount.name }}
{{- end -}}

{{/*
Generate command for Jobmanager
*/}}
{{- define "jobmanager.command" -}}
{{ $cmd := .Values.global.jobmanager.command }}
{{- if .Values.global.jobmanager.highAvailability.enabled }}
{{ $cmd = (tpl .Values.global.jobmanager.highAvailability.command .) }}
{{- end }}
{{- if .Values.global.jobmanager.additionalCommand -}}
{{ printf "%s && %s" .Values.global.jobmanager.additionalCommand $cmd }}
{{- else }}
{{ $cmd }}
{{- end -}}
{{- end -}}

{{/*
Generate command for Taskmanager
*/}}
{{- define "taskmanager.command" -}}
{{ $cmd := .Values.global.taskmanager.command }}
{{- if .Values.global.taskmanager.additionalCommand -}}
{{ printf "%s && %s" .Values.global.taskmanager.additionalCommand $cmd }}
{{- else }}
{{ $cmd }}
{{- end -}}
{{- end -}}

{{/*
Check if specific namespace is passed if false
then .Release.Namespace will be used
*/}}
{{- define "serviceMonitor.namespace" -}}
{{- if .Values.global.prometheus.serviceMonitor.namespace -}}
{{ .Values.global.prometheus.serviceMonitor.namespace }}
{{- else -}}
{{ .Release.Namespace }}
{{- end -}}
{{- end -}}
