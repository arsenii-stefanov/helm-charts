{{- define "irsa.cluster_tags" -}}
- key: cluster_name
  value: {{ .Values.clusterName }}
{{- end -}}
