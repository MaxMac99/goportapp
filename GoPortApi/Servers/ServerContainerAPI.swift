//
//  ServerContainerAPI.swift
//  GoPortApi
//
//  Created by Max Vissing on 30.01.22.
//

import Foundation

extension Server {
    
    /**
     List containers
     - GET /containers/json
     - Returns a list of containers. For details on the format, see the [inspect endpoint](#operation/ContainerInspect).  Note that it uses a different, smaller representation of a container than inspecting a single container. For example, the list of linked containers is not propagated .
     - parameter all: (query) Return all containers. By default, only running containers are shown.  (optional, default to false)
     - parameter limit: (query) Return this number of most recently created containers, including non-running ones.  (optional)
     - parameter size: (query) Return the size of container as fields &#x60;SizeRw&#x60; and &#x60;SizeRootFs&#x60;.  (optional, default to false)
     - parameter filters: (query) Filters to process on the container list, encoded as JSON (a &#x60;map[string][]string&#x60;). For example, &#x60;{\&quot;status\&quot;: [\&quot;paused\&quot;]}&#x60; will only return paused containers.  Available filters:  - &#x60;ancestor&#x60;&#x3D;(&#x60;&lt;image-name&gt;[:&lt;tag&gt;]&#x60;, &#x60;&lt;image id&gt;&#x60;, or &#x60;&lt;image@digest&gt;&#x60;) - &#x60;before&#x60;&#x3D;(&#x60;&lt;container id&gt;&#x60; or &#x60;&lt;container name&gt;&#x60;) - &#x60;expose&#x60;&#x3D;(&#x60;&lt;port&gt;[/&lt;proto&gt;]&#x60;|&#x60;&lt;startport-endport&gt;/[&lt;proto&gt;]&#x60;) - &#x60;exited&#x3D;&lt;int&gt;&#x60; containers with exit code of &#x60;&lt;int&gt;&#x60; - &#x60;health&#x60;&#x3D;(&#x60;starting&#x60;|&#x60;healthy&#x60;|&#x60;unhealthy&#x60;|&#x60;none&#x60;) - &#x60;id&#x3D;&lt;ID&gt;&#x60; a container&#39;s ID - &#x60;isolation&#x3D;&#x60;(&#x60;default&#x60;|&#x60;process&#x60;|&#x60;hyperv&#x60;) (Windows daemon only) - &#x60;is-task&#x3D;&#x60;(&#x60;true&#x60;|&#x60;false&#x60;) - &#x60;label&#x3D;key&#x60; or &#x60;label&#x3D;\&quot;key&#x3D;value\&quot;&#x60; of a container label - &#x60;name&#x3D;&lt;name&gt;&#x60; a container&#39;s name - &#x60;network&#x60;&#x3D;(&#x60;&lt;network id&gt;&#x60; or &#x60;&lt;network name&gt;&#x60;) - &#x60;publish&#x60;&#x3D;(&#x60;&lt;port&gt;[/&lt;proto&gt;]&#x60;|&#x60;&lt;startport-endport&gt;/[&lt;proto&gt;]&#x60;) - &#x60;since&#x60;&#x3D;(&#x60;&lt;container id&gt;&#x60; or &#x60;&lt;container name&gt;&#x60;) - &#x60;status&#x3D;&#x60;(&#x60;created&#x60;|&#x60;restarting&#x60;|&#x60;running&#x60;|&#x60;removing&#x60;|&#x60;paused&#x60;|&#x60;exited&#x60;|&#x60;dead&#x60;) - &#x60;volume&#x60;&#x3D;(&#x60;&lt;volume name&gt;&#x60; or &#x60;&lt;mount point destination&gt;&#x60;)  (optional)
     - returns: [String: [ContainerSummary]]
     */
    public func containers(all: Bool = false, limit: Int? = nil, size: Bool = false, filters: String? = nil) async throws -> [(context: GoPortContext, response: [ContainerSummaryResponseItem])] {
        try stringToDockerContext(try await ContainerAPI.containerList(host: host, context: selectedContextsString, all: all, limit: limit, size: size, filters: filters, session: session))
    }
    
    /**
     Delete stopped containers
     - POST /containers/prune
     - parameter filters: (query) Filters to process on the prune list, encoded as JSON (a &#x60;map[string][]string&#x60;).  Available filters: - &#x60;until&#x3D;&lt;timestamp&gt;&#x60; Prune containers created before this timestamp. The &#x60;&lt;timestamp&gt;&#x60; can be Unix timestamps, date formatted timestamps, or Go duration strings (e.g. &#x60;10m&#x60;, &#x60;1h30m&#x60;) computed relative to the daemon machine’s time. - &#x60;label&#x60; (&#x60;label&#x3D;&lt;key&gt;&#x60;, &#x60;label&#x3D;&lt;key&gt;&#x3D;&lt;value&gt;&#x60;, &#x60;label!&#x3D;&lt;key&gt;&#x60;, or &#x60;label!&#x3D;&lt;key&gt;&#x3D;&lt;value&gt;&#x60;) Prune containers with (or without, in case &#x60;label!&#x3D;...&#x60; is used) the specified labels.  (optional)
     - returns: ContainerPruneResponse
     */
    public func containerPrune(filters: String? = nil) async throws -> [(context: GoPortContext, response: ContainerPruneResponseItem)] {
        try stringToDockerContext(try await ContainerAPI.containerPrune(host: host, context: selectedContextsString, filters: filters, session: session))
    }
}

extension GoPortContext {
    
    /**
     List containers
     - GET /containers/json
     - Returns a list of containers. For details on the format, see the [inspect endpoint](#operation/ContainerInspect).  Note that it uses a different, smaller representation of a container than inspecting a single container. For example, the list of linked containers is not propagated .
     - parameter all: (query) Return all containers. By default, only running containers are shown.  (optional, default to false)
     - parameter limit: (query) Return this number of most recently created containers, including non-running ones.  (optional)
     - parameter size: (query) Return the size of container as fields &#x60;SizeRw&#x60; and &#x60;SizeRootFs&#x60;.  (optional, default to false)
     - parameter filters: (query) Filters to process on the container list, encoded as JSON (a &#x60;map[string][]string&#x60;). For example, &#x60;{\&quot;status\&quot;: [\&quot;paused\&quot;]}&#x60; will only return paused containers.  Available filters:  - &#x60;ancestor&#x60;&#x3D;(&#x60;&lt;image-name&gt;[:&lt;tag&gt;]&#x60;, &#x60;&lt;image id&gt;&#x60;, or &#x60;&lt;image@digest&gt;&#x60;) - &#x60;before&#x60;&#x3D;(&#x60;&lt;container id&gt;&#x60; or &#x60;&lt;container name&gt;&#x60;) - &#x60;expose&#x60;&#x3D;(&#x60;&lt;port&gt;[/&lt;proto&gt;]&#x60;|&#x60;&lt;startport-endport&gt;/[&lt;proto&gt;]&#x60;) - &#x60;exited&#x3D;&lt;int&gt;&#x60; containers with exit code of &#x60;&lt;int&gt;&#x60; - &#x60;health&#x60;&#x3D;(&#x60;starting&#x60;|&#x60;healthy&#x60;|&#x60;unhealthy&#x60;|&#x60;none&#x60;) - &#x60;id&#x3D;&lt;ID&gt;&#x60; a container&#39;s ID - &#x60;isolation&#x3D;&#x60;(&#x60;default&#x60;|&#x60;process&#x60;|&#x60;hyperv&#x60;) (Windows daemon only) - &#x60;is-task&#x3D;&#x60;(&#x60;true&#x60;|&#x60;false&#x60;) - &#x60;label&#x3D;key&#x60; or &#x60;label&#x3D;\&quot;key&#x3D;value\&quot;&#x60; of a container label - &#x60;name&#x3D;&lt;name&gt;&#x60; a container&#39;s name - &#x60;network&#x60;&#x3D;(&#x60;&lt;network id&gt;&#x60; or &#x60;&lt;network name&gt;&#x60;) - &#x60;publish&#x60;&#x3D;(&#x60;&lt;port&gt;[/&lt;proto&gt;]&#x60;|&#x60;&lt;startport-endport&gt;/[&lt;proto&gt;]&#x60;) - &#x60;since&#x60;&#x3D;(&#x60;&lt;container id&gt;&#x60; or &#x60;&lt;container name&gt;&#x60;) - &#x60;status&#x3D;&#x60;(&#x60;created&#x60;|&#x60;restarting&#x60;|&#x60;running&#x60;|&#x60;removing&#x60;|&#x60;paused&#x60;|&#x60;exited&#x60;|&#x60;dead&#x60;) - &#x60;volume&#x60;&#x3D;(&#x60;&lt;volume name&gt;&#x60; or &#x60;&lt;mount point destination&gt;&#x60;)  (optional)
     - returns: [String: [ContainerSummary]]
     */
    public func containers(all: Bool = false, limit: Int? = nil, size: Bool = false, filters: String? = nil) async throws -> [ContainerSummaryResponseItem] {
        try await ContainerAPI.containerList(host: host, context: [name], all: all, limit: limit, size: size, filters: filters, session: session).dockerContext(name)
    }
    
    /**
     Create a container
     - POST /containers/create
     - parameter body: (body) Container to create
     - parameter name: (query) Assign the specified name to the container. Must match &#x60;/?[a-zA-Z0-9][a-zA-Z0-9_.-]+&#x60;.  (optional)
     - returns: ContainerCreateResponse
     */
    public func containerCreate(body: ContainerCreateConfig, name: String? = nil) async throws -> ContainerCreateResponse {
        try await ContainerAPI.containerCreate(host: host, body: body, context: self.name, name: name, session: session)
    }
    
    /**
     Delete stopped containers
     - POST /containers/prune
     - parameter filters: (query) Filters to process on the prune list, encoded as JSON (a &#x60;map[string][]string&#x60;).  Available filters: - &#x60;until&#x3D;&lt;timestamp&gt;&#x60; Prune containers created before this timestamp. The &#x60;&lt;timestamp&gt;&#x60; can be Unix timestamps, date formatted timestamps, or Go duration strings (e.g. &#x60;10m&#x60;, &#x60;1h30m&#x60;) computed relative to the daemon machine’s time. - &#x60;label&#x60; (&#x60;label&#x3D;&lt;key&gt;&#x60;, &#x60;label&#x3D;&lt;key&gt;&#x3D;&lt;value&gt;&#x60;, &#x60;label!&#x3D;&lt;key&gt;&#x60;, or &#x60;label!&#x3D;&lt;key&gt;&#x3D;&lt;value&gt;&#x60;) Prune containers with (or without, in case &#x60;label!&#x3D;...&#x60; is used) the specified labels.  (optional)
     - returns: ContainerPruneResponse
     */
    public func containerPrune(filters: String? = nil) async throws -> ContainerPruneResponseItem {
        try await ContainerAPI.containerPrune(host: host, context: [name], filters: filters, session: session).dockerContext(name)
    }
}

extension Container {
    
    /**
     Get changes on a container’s filesystem
     - GET /containers/{id}/changes
     - Returns which files in a container's filesystem have been added, deleted, or modified. The `Kind` of modification can be one of:  - `0`: Modified - `1`: Added - `2`: Deleted
     - returns: ContainerChangeResponse
     */
    public func changes() async throws -> ContainerChangeResponse {
        try await ContainerAPI.containerChanges(host: context.host, id: id, context: context.name, session: context.session)
    }
    
    /**
     Remove a container
     - DELETE /containers/{id}
     
     */
    public func remove(volumes: Bool = false, force: Bool = false, link: Bool = false) async throws {
        try await ContainerAPI.containerDelete(host: context.host, id: id, context: context.name, v: volumes, force: force, link: link, session: context.session)
    }
    
    /**
     Export a container
     - GET /containers/{id}/export
     - Export the contents of a container as a tarball.
     - returns: Data
     */
    public func export() async throws -> Data {
        try await ContainerAPI.containerExport(host: context.host, id: id, context: context.name, session: context.session)
    }
    
    /**
     Inspect a container
     - GET /containers/{id}/json
     - Return low-level information about a container.
     - parameter size: (query) Return the size of container as fields &#x60;SizeRw&#x60; and &#x60;SizeRootFs&#x60; (optional, default to false)
     - returns: ContainerInspectResponse
     */
    public func inspect(size: Bool = false) async throws -> ContainerInspectResponse {
        try await ContainerAPI.containerInspect(host: context.host, id: id, context: context.id, size: size, session: context.session)
    }
    
    /**
     Kill a container
     - POST /containers/{id}/kill
     - Send a POSIX signal to a container, defaulting to killing to the container.
     - parameter signal: (query) Signal to send to the container as an integer or string (e.g. &#x60;SIGINT&#x60;) (optional, default to "SIGKILL")
     
     */
    public func kill(signal: String = "SIGKILL") async throws {
        try await ContainerAPI.containerKill(host: context.host, id: id, context: context.name, signal: signal, session: context.session)
    }
    
    /**
     Get container logs
     - GET /containers/{id}/logs
     - Get `stdout` and `stderr` logs from a container.  Note: This endpoint works only for containers with the `json-file` or `journald` logging driver.
     - parameter stdout: (query) Return logs from &#x60;stdout&#x60; (optional, default to true)
     - parameter stderr: (query) Return logs from &#x60;stderr&#x60; (optional, default to true)
     - parameter since: (query) Only return logs since this time, as a UNIX timestamp (optional, default to 0)
     - parameter until: (query) Only return logs before this time, as a UNIX timestamp (optional, default to 0)
     - parameter timestamps: (query) Add timestamps to every log line (optional, default to false)
     - parameter tail: (query) Only return this number of log lines from the end of the logs. Specify as an integer or &#x60;all&#x60; to output all log lines.  (optional, default to "all")
     - returns: URL
     */
    public func logs(stdout: Bool = true, stderr: Bool = true, since: Date? = nil, until: Date? = nil, timestamps: Bool = false, tail: Int? = nil) async throws -> ContainerLogResponse {
        var sinceInt: Int? = nil
        if let since = since {
            sinceInt = Int(since.timeIntervalSince1970 * 1_000)
        }
        var untilInt: Int? = nil
        if let until = until {
            untilInt = Int(until.timeIntervalSince1970 * 1_000)
        }
        var tailStr: String? = nil
        if let tail = tail {
            tailStr = String(tail)
        }
        return try await ContainerAPI.containerLogs(host: context.host, id: id, context: context.name, stdout: stdout, stderr: stderr, since: sinceInt, until: untilInt, timestamps: timestamps, tail: tailStr, session: context.session)
    }
    
    /**
     Get container logs
     - GET /containers/{id}/logs
     - Get `stdout` and `stderr` logs from a container.  Note: This endpoint works only for containers with the `json-file` or `journald` logging driver.
     - parameter stdout: (query) Return logs from &#x60;stdout&#x60; (optional, default to false)
     - parameter stderr: (query) Return logs from &#x60;stderr&#x60; (optional, default to false)
     - parameter since: (query) Only return logs since this time, as a UNIX timestamp (optional, default to 0)
     - parameter until: (query) Only return logs before this time, as a UNIX timestamp (optional, default to 0)
     - parameter timestamps: (query) Add timestamps to every log line (optional, default to false)
     - parameter tail: (query) Only return this number of log lines from the end of the logs. Specify as an integer or &#x60;all&#x60; to output all log lines.  (optional, default to "all")
     - returns: URL
     */
    public func logsStream(stdout: Bool = true, stderr: Bool = true, since: Date? = nil, until: Date? = nil, timestamps: Bool? = nil, tail: Int? = nil) async throws -> some AsyncSequence {
        var sinceInt: Int? = nil
        if let since = since {
            sinceInt = Int(since.timeIntervalSince1970 * 1_000)
        }
        var untilInt: Int? = nil
        if let until = until {
            untilInt = Int(until.timeIntervalSince1970 * 1_000)
        }
        var tailStr: String? = nil
        if let tail = tail {
            tailStr = String(tail)
        }
        return try await ContainerAPI.containerStreamLogs(host: context.host, id: id, context: context.name, stdout: stdout, stderr: stderr, since: sinceInt, until: untilInt, timestamps: timestamps, tail: tailStr, session: context.session).stream
    }
    
    /**
     Pause a container
     - POST /containers/{id}/pause
     - Use the freezer cgroup to suspend all processes in a container.  Traditionally, when suspending a process the `SIGSTOP` signal is used, which is observable by the process being suspended. With the freezer cgroup the process is unaware, and unable to capture, that it is being suspended, and subsequently resumed.
     
     */
    public func pause() async throws {
        try await ContainerAPI.containerPause(host: context.host, id: id, context: context.name, session: context.session)
    }
    
    /**
     Rename a container
     - POST /containers/{id}/rename
     - parameter name: (query) New name for the container
     
     */
    public func rename(name: String) async throws {
        try await ContainerAPI.containerRename(host: context.host, id: id, name: name, context: context.name, session: context.session)
    }
    
    /**
     Resize a container TTY
     - POST /containers/{id}/resize
     - Resize the TTY for a container.
     - parameter h: (query) Height of the TTY session in characters (optional)
     - parameter w: (query) Width of the TTY session in characters (optional)
     
     */
    public func resize(height: Int? = nil, width: Int? = nil) async throws {
        try await ContainerAPI.containerResize(host: context.host, id: id, context: context.name, h: height, w: width, session: context.session)
    }
    
    /**
     Restart a container
     - POST /containers/{id}/restart
     - parameter t: (query) Number of seconds to wait before killing the container (optional)
     
     */
    public func restart(timeout: TimeInterval? = nil) async throws {
        var t: Int? = nil
        if let timeout = timeout {
            t = Int(timeout.rounded())
        }
        try await ContainerAPI.containerRestart(host: context.host, id: id, context: context.name, t: t, session: context.session)
    }
    
    /**
     Start a container
     - POST /containers/{id}/start
     - parameter detachKeys: (query) Override the key sequence for detaching a container. Format is a single character &#x60;[a-Z]&#x60; or &#x60;ctrl-&lt;value&gt;&#x60; where &#x60;&lt;value&gt;&#x60; is one of: &#x60;a-z&#x60;, &#x60;@&#x60;, &#x60;^&#x60;, &#x60;[&#x60;, &#x60;,&#x60; or &#x60;_&#x60;.  (optional)
     
     */
    public func start(detachKeys: String? = nil) async throws {
        try await ContainerAPI.containerStart(host: context.host, id: id, context: context.name, detachKeys: detachKeys, session: context.session)
    }
    
    /**
     Get container stats based on resource usage
     - GET /containers/{id}/stats
     - This endpoint returns a live stream of a container’s resource usage statistics.  The `precpu_stats` is the CPU statistic of the *previous* read, and is used to calculate the CPU usage percentage. It is not an exact copy of the `cpu_stats` field.  If either `precpu_stats.online_cpus` or `cpu_stats.online_cpus` is nil then for compatibility with older daemons the length of the corresponding `cpu_usage.percpu_usage` array should be used.  On a cgroup v2 host, the following fields are not set * `blkio_stats`: all fields other than `io_service_bytes_recursive` * `cpu_stats`: `cpu_usage.percpu_usage` * `memory_stats`: `max_usage` and `failcnt` Also, `memory_stats.stats` fields are incompatible with cgroup v1.  To calculate the values shown by the `stats` command of the docker cli tool the following formulas can be used: * used_memory = `memory_stats.usage - memory_stats.stats.cache` * available_memory = `memory_stats.limit` * Memory usage % = `(used_memory / available_memory) * 100.0` * cpu_delta = `cpu_stats.cpu_usage.total_usage - precpu_stats.cpu_usage.total_usage` * system_cpu_delta = `cpu_stats.system_cpu_usage - precpu_stats.system_cpu_usage` * number_cpus = `lenght(cpu_stats.cpu_usage.percpu_usage)` or `cpu_stats.online_cpus` * CPU usage % = `(cpu_delta / system_cpu_delta) * number_cpus * 100.0`
     - parameter oneShot: (query) Only get a single stat instead of waiting for 2 cycles. Must be used with &#x60;stream&#x3D;false&#x60;.  (optional, default to false)
     - returns: [ContainerStatsResponse]
     */
    public func stats(oneShot: Bool = false) async throws -> ContainerStatsResponse {
        try await ContainerAPI.containerStats(host: context.host, id: id, context: context.name, oneShot: oneShot, session: context.session)
    }
    
    /**
     Get container stats based on resource usage
     - GET /containers/{id}/stats
     - This endpoint returns a live stream of a container’s resource usage statistics.  The `precpu_stats` is the CPU statistic of the *previous* read, and is used to calculate the CPU usage percentage. It is not an exact copy of the `cpu_stats` field.  If either `precpu_stats.online_cpus` or `cpu_stats.online_cpus` is nil then for compatibility with older daemons the length of the corresponding `cpu_usage.percpu_usage` array should be used.  On a cgroup v2 host, the following fields are not set * `blkio_stats`: all fields other than `io_service_bytes_recursive` * `cpu_stats`: `cpu_usage.percpu_usage` * `memory_stats`: `max_usage` and `failcnt` Also, `memory_stats.stats` fields are incompatible with cgroup v1.  To calculate the values shown by the `stats` command of the docker cli tool the following formulas can be used: * used_memory = `memory_stats.usage - memory_stats.stats.cache` * available_memory = `memory_stats.limit` * Memory usage % = `(used_memory / available_memory) * 100.0` * cpu_delta = `cpu_stats.cpu_usage.total_usage - precpu_stats.cpu_usage.total_usage` * system_cpu_delta = `cpu_stats.system_cpu_usage - precpu_stats.system_cpu_usage` * number_cpus = `lenght(cpu_stats.cpu_usage.percpu_usage)` or `cpu_stats.online_cpus` * CPU usage % = `(cpu_delta / system_cpu_delta) * number_cpus * 100.0`
     - parameter oneShot: (query) Only get a single stat instead of waiting for 2 cycles. Must be used with &#x60;stream&#x3D;false&#x60;.  (optional, default to false)
     - returns: [ContainerStatsResponse]
     */
    public func containerStreamStats(oneShot: Bool = false) async throws -> some AsyncSequence {
        try await ContainerAPI.containerStreamStats(host: context.host, id: id, context: context.name, oneShot: oneShot, session: context.session).stream
    }
    
    /**
     Stop a container
     - POST /containers/{id}/stop
     - parameter t: (query) Number of seconds to wait before killing the container (optional)
     
     */
    public func stop(timeout: TimeInterval? = nil) async throws {
        var t: Int? = nil
        if let timeout = timeout {
            t = Int(timeout.rounded())
        }
        try await ContainerAPI.containerStop(host: context.host, id: id, context: context.name, t: t, session: context.session)
    }
    
    /**
     List processes running inside a container
     - GET /containers/{id}/top
     - On Unix systems, this is done by running the `ps` command. This endpoint is not supported on Windows.
     - parameter psArgs: (query) The arguments to pass to &#x60;ps&#x60;. For example, &#x60;aux&#x60; (optional, default to "-ef")
     - returns: ContainerTopResponse
     */
    public func top(psArgs: String? = nil) async throws -> ContainerTopResponse {
        try await ContainerAPI.containerTop(host: context.host, id: id, context: context.name, psArgs: psArgs, session: context.session)
    }
    
    /**
     Unpause a container
     - POST /containers/{id}/unpause
     - Resume a container which has been paused.
     
     */
    public func unpause() async throws {
        try await ContainerAPI.containerUnpause(host: context.host, id: id, context: context.name, session: context.session)
    }
    
    /**
     Update a container
     - POST /containers/{id}/update
     - Change various configuration options of a container without having to recreate it.
     - parameter update: (body)
     - returns: ContainerUpdateResponse
     */
    public func update(update: ContainerUpdateConfig) async throws -> ContainerUpdateResponse {
        try await ContainerAPI.containerUpdate(host: context.host, id: id, update: update, context: context.name, session: context.session)
    }
    
    /**
     Wait for a container
     - POST /containers/{id}/wait
     - Block until a container stops, then returns the exit code.
     - parameter condition: (query) Wait until a container state reaches the given condition, either &#39;not-running&#39; (default), &#39;next-exit&#39;, or &#39;removed&#39;.  (optional, default to "not-running")
     - returns: ContainerWaitResponse
     */
    public func wait(condition: String? = nil) async throws -> ContainerWaitResponse {
        try await ContainerAPI.containerWait(host: context.host, id: id, context: context.name, condition: condition, session: context.session)
    }
}
