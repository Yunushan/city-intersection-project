{{- define "cip.name" -}}
{{- default .Chart.Name .Values.global.projectName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "cip.namespace" -}}
{{- default "city-intersection" .Values.namespace.name -}}
{{- end -}}

{{- define "cip.labels" -}}
app.kubernetes.io/part-of: city-intersection-project
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | quote }}
{{- end -}}

{{- define "cip.selectorLabels" -}}
app.kubernetes.io/part-of: city-intersection-project
{{- end -}}

{{- define "cip.image" -}}
{{- $root := index . 0 -}}
{{- $img := index . 1 -}}
{{- $tag := default "latest" $img.tag -}}
{{- if $root.Values.global.imageRegistry -}}
{{ printf "%s/%s:%s" ($root.Values.global.imageRegistry | trimSuffix "/") $img.repository $tag }}
{{- else -}}
{{ printf "%s:%s" $img.repository $tag }}
{{- end -}}
{{- end -}}

{{- define "cip.securityContext" -}}
allowPrivilegeEscalation: {{ .Values.global.security.allowPrivilegeEscalation | default false }}
readOnlyRootFilesystem: {{ .Values.global.security.readOnlyRootFilesystem | default false }}
{{- end -}}
