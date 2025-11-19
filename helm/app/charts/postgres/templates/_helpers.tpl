{{- define "postgres.name" -}}
{{- default $.Chart.Name $.Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "postgres.chart" -}}
{{- printf "%s-%s" $.Chart.Name $.Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "postgres.labels" -}}
helm.sh/chart: {{ include "postgres.chart" $ }}
{{ include "postgres.selectorLabels" $ }}
{{- if $.Chart.AppVersion }}
app.kubernetes.io/version: {{ $.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ $.Release.Service }}
{{- end }}

{{- define "postgres.selectorLabels" -}}
app.kubernetes.io/name: {{ include "postgres.name" $ }}
app.kubernetes.io/instance: {{ $.Release.Name }}
{{- end }}

{{- define "postgres.secretName" -}}
{{- default (printf "%s-secret" $.Chart.Name) $.Values.global.secret.name | trunc 63 | trimSuffix "-" }}
{{- end }}
