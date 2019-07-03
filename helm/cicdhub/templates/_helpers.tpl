{{/*
Create a comma separated list of SANs
*/}}
{{- define "commaSeparatedListOfSANs" -}}
{{- $local := dict "first" true -}}
{{- range $k, $v := . -}}{{- if not $local.first -}},{{- end -}}{{ "DNS:" }}{{- $v -}}{{- $_ := set $local "first" false -}}{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified volume prefix for volumesInit.
We truncate at 53 chars because some Kubernetes name fields are limited to 63 (by the DNS naming spec) - we reserve an extra 10 for the suffix of each volume
If release name contains 'starter-vol' it will be used as a full name.
*/}}
{{- define "volumesInit.fullPrefix" -}}
{{- if .Values.volumesInit.fullPrefixOverride -}}
{{- .Values.volumesInit.fullPrefixOverride | trunc 53 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "starter-vol" .Values.volumesInit.prefixOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 53 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 53 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "nexus-docker-registry.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "nexus-docker-registry.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "cicdhub.openldap.name" -}}
{{- default "openldap" .Values.openldap.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cicdhub.openldap.fullname" -}}
{{- if .Values.openldap.fullnameOverride -}}
{{- .Values.openldap.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "openldap" .Values.openldap.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cicdhub.openldap.chart" -}}
{{- printf "%s-%s" "openldap" "0.2.3" | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cicdhub.nexus.chart" -}}
{{- printf "%s-%s" "nexus" .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "cicdhub.nexus.name" -}}
{{- default "nexus" .Values.nexus.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cicdhub.nexus.fullname" -}}
{{- if .Values.nexus.fullnameOverride -}}
{{- .Values.nexus.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "nexus" .Values.nexus.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*  Manage the labels for each entity  */}}
{{- define "cicdhub.nexus.labels" -}}
app: {{ template "cicdhub.nexus.name" . }}
fullname: {{ template "cicdhub.nexus.fullname" . }}
chart: {{ template "cicdhub.nexus.chart" . }}
release: {{ .Release.Name }}
heritage: {{ .Release.Service }}
{{- end -}}