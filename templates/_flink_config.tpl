{{/*
Generate Flink Configuration.
We do it here to support HA mode where we cannot
provide jobmanager.rpc.address to Taskmanagers
*/}}
{{- define "flink.configuration" -}}
    taskmanager.numberOfTaskSlots: {{ .Values.global.taskmanager.numberOfTaskSlots }}
    blob.server.port: {{ .Values.global.jobmanager.ports.blob }}
    taskmanager.rpc.port: {{ .Values.global.taskmanager.ports.rpc }}
    jobmanager.heap.size: {{ .Values.global.jobmanager.heapSize }}
    {{- if .Values.global.taskmanager.memoryProcessSize }}
    taskmanager.memory.process.size: {{ .Values.global.taskmanager.memoryProcessSize }}
    {{- end }}
    {{- if .Values.global.taskmanager.memoryFlinkSize }}
    taskmanager.memory.flink.size: {{ .Values.global.taskmanager.memoryFlinkSize }}
    {{- end }}
    {{- if .Values.global.flink.monitoring.enabled }}
    metrics.reporters: prom
    metrics.reporter.prom.class: org.apache.flink.metrics.prometheus.PrometheusReporter
    metrics.reporter.prom.port: {{ .Values.global.flink.monitoring.port }}
      {{- if .Values.global.flink.monitoring.system.enabled }}
    metrics.system-resource: true
    metrics.system-resource-probing-interval: {{ .Values.global.flink.monitoring.system.probingInterval }}
      {{- end }}
      {{- if .Values.global.flink.monitoring.latency.enabled }}
    metrics.latency.interval: {{ .Values.global.flink.monitoring.latency.probingInterval }}
      {{- end }}
      {{- if .Values.global.flink.monitoring.rocksdb.enabled }}
    state.backend.rocksdb.metrics.cur-size-active-mem-table: true
    state.backend.rocksdb.metrics.cur-size-all-mem-tables: true
    state.backend.rocksdb.metrics.estimate-live-data-size: true
    state.backend.rocksdb.metrics.size-all-mem-tables: true
    state.backend.rocksdb.metrics.estimate-num-keys: true
      {{- end }}
    {{- end }}
    {{- if .Values.global.flink.state.backend }}
    state.backend: {{ .Values.global.flink.state.backend }}
    {{- .Values.global.flink.state.params | nindent 4 }}
      {{- if eq .Values.global.flink.state.backend "rocksdb" }}
    {{- .Values.global.flink.state.rocksdb | nindent 4 }}
      {{- end }}
    {{- end }}
    {{- if .Values.global.jobmanager.highAvailability.enabled }}
    high-availability: zookeeper
    high-availability.zookeeper.quorum: {{ tpl .Values.global.jobmanager.highAvailability.zookeeperConnect . }}
    high-availability.zookeeper.path.root: {{ .Values.global.jobmanager.highAvailability.zookeeperRootPath }}
    high-availability.cluster-id: {{ .Values.global.jobmanager.highAvailability.clusterId }}
    high-availability.storageDir: {{ .Values.global.jobmanager.highAvailability.storageDir }}
    high-availability.jobmanager.port: {{ .Values.global.jobmanager.highAvailability.syncPort }}
    {{- else }}
    jobmanager.rpc.address: {{ include "flink.fullname" . }}-jobmanager
    jobmanager.rpc.port: {{ .Values.global.jobmanager.ports.rpc }}
    {{- end }}
    {{- .Values.global.flink.params | nindent 4 }}
{{- end -}}
