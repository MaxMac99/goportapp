//
//  ServerProjectAPI.swift
//  GoPortApi
//
//  Created by Max Vissing on 30.01.22.
//

import Foundation

extension Server {
    
    /**
     List projects
     - GET /projects/json
     - Returns a list of projects. For details on the format, see the [inspect endpoint](#operation/ProjectInspect).  Note that it uses a different, smaller representation of a project than inspecting a single project.
     - parameter all: (query) Filter output based on conditions provided. (optional, default to false)
     - returns: [String: Stacks]
     */
    public func projects(all: Bool = false, stored: Bool = true) async throws -> (stored: [ProjectSummary]?, remote: [(context: GoPortContext, response: [ProjectSummary])]) {
        let response = try await ProjectAPI.projectList(host: host, context: selectedContextsString, all: all, stored: stored, session: session)
        return (stored: response.stored, remote: try stringToDockerContext(response.remote))
    }
    
    /**
     Create a project
     - POST /projects/{name}
     - parameter name: (path) Assign the specified name to the project. Must match &#x60;/?[a-zA-Z0-9][a-zA-Z0-9_.-]+&#x60;.
     - parameter body: (body) The docker-compose.yml file content, that should be added to the project
     
     */
    public func createProject(name: String, body: String) async throws {
        try await ProjectAPI.projectCreate(host: host, name: name, body: body, session: session)
    }
}

extension GoPortContext {
    
    /**
     List projects
     - GET /projects/json
     - Returns a list of projects. For details on the format, see the [inspect endpoint](#operation/ProjectInspect).  Note that it uses a different, smaller representation of a project than inspecting a single project.
     - parameter all: (query) Filter output based on conditions provided. (optional, default to false)
     - returns: [String: Stacks]
     */
    public func projects(all: Bool = false, stored: Bool = true) async throws -> (stored: [ProjectSummary]?, remote: [ProjectSummary]) {
        let response = try await ProjectAPI.projectList(host: host, context: [name], all: all, stored: stored, session: session)
        return (stored: response.stored, remote: try response.remote.dockerContext(name))
    }
}

extension Project {
    
    /**
     Build the project
     - POST /projects/{name}/build
     - Services are built once and then tagged, by default as project_service.  For example, composetest_db. If the Compose file specifies an image name,  the image is tagged with that name, substituting any variables beforehand.  See variable substitution.
     - parameter services: (query) Build only the given services.  (optional)
     - parameter buildargs: (query) JSON map of string pairs for build-time variables. Users pass these values at build-time. Docker uses the buildargs as the environment context for commands run via the &#x60;Dockerfile&#x60; RUN instruction, or for variable expansion in other &#x60;Dockerfile&#x60; instructions. This is not meant for passing secret values.  For example, the build arg &#x60;FOO&#x3D;bar&#x60; would become &#x60;{\&quot;FOO\&quot;:\&quot;bar\&quot;}&#x60; in JSON. This would result in the query parameter &#x60;buildargs&#x3D;{\&quot;FOO\&quot;:\&quot;bar\&quot;}&#x60;. Note that &#x60;{\&quot;FOO\&quot;:\&quot;bar\&quot;}&#x60; should be URI component encoded.  [Read more about the buildargs instruction.](/engine/reference/builder/#arg)  (optional)
     - parameter nocache: (query) Do not use the cache when building the image. (optional, default to false)
     - parameter pull: (query) Always attempt to pull a newer version of the image. (optional, default to false)
     - parameter quiet: (query) Suppress verbose build output. This will disable stream output. (optional, default to false)
     - returns: URL
     */
    public func buildStream(services: [String]? = nil, buildArgs: String? = nil, noCache: Bool = false, pull: Bool = false) async throws -> some AsyncSequence {
        try await ProjectAPI.projectStreamBuild(host: context.host, name: name, context: context.name, services: services, buildargs: buildArgs, nocache: noCache, pull: pull, session: context.session).stream
    }
    
    /**
     Build the project
     - POST /projects/{name}/build
     - Services are built once and then tagged, by default as project_service.  For example, composetest_db. If the Compose file specifies an image name,  the image is tagged with that name, substituting any variables beforehand.  See variable substitution.
     - parameter services: (query) Build only the given services.  (optional)
     - parameter buildargs: (query) JSON map of string pairs for build-time variables. Users pass these values at build-time. Docker uses the buildargs as the environment context for commands run via the &#x60;Dockerfile&#x60; RUN instruction, or for variable expansion in other &#x60;Dockerfile&#x60; instructions. This is not meant for passing secret values.  For example, the build arg &#x60;FOO&#x3D;bar&#x60; would become &#x60;{\&quot;FOO\&quot;:\&quot;bar\&quot;}&#x60; in JSON. This would result in the query parameter &#x60;buildargs&#x3D;{\&quot;FOO\&quot;:\&quot;bar\&quot;}&#x60;. Note that &#x60;{\&quot;FOO\&quot;:\&quot;bar\&quot;}&#x60; should be URI component encoded.  [Read more about the buildargs instruction.](/engine/reference/builder/#arg)  (optional)
     - parameter nocache: (query) Do not use the cache when building the image. (optional, default to false)
     - parameter pull: (query) Always attempt to pull a newer version of the image. (optional, default to false)
     - parameter quiet: (query) Suppress verbose build output. This will disable stream output. (optional, default to false)
     - returns: URL
     */
    public func build(services: [String]? = nil, buildArgs: String? = nil, noCache: Bool = false, pull: Bool = false) async throws {
        try await ProjectAPI.projectBuild(host: context.host, name: name, context: context.name, services: services, buildargs: buildArgs, nocache: noCache, pull: pull, session: context.session)
    }
    
    /**
     Stops containers and removes containers, networks, volumes, and images created by up
     - POST /projects/{name}/down
     - Stops containers and removes containers, networks, volumes, and images created by up.  By default, the only things removed are:  Containers for services defined in the Compose file Networks defined in the networks section of the Compose file The default network, if one is used Networks and volumes defined as external are never removed.  Anonymous volumes are not removed by default.  However, as they don’t have a stable name,  they will not be automatically mounted by a subsequent up.  For data that needs to persist between updates, use host or named volumes.
     - parameter rmi: (query) Remove images. Type must be one of:    * &#39;all&#39;: Remove all images used by any service.   * &#39;local&#39;: Remove only images that don&#39;t have a custom tag set by the &#x60;image&#x60; field.  (optional)
     - parameter volumes: (query) Remove named volumes declared in the &#x60;volumes&#x60; section of the Compose file and anonymous volumes attached to containers.  (optional, default to false)
     - parameter removeorphans: (query) Remove containers for services not defined in the Compose file (optional, default to false)
     - parameter timeout: (query) Specify a shutdown timeout in seconds. (optional)
     
     */
    public func down(rmi: ProjectAPI.Rmi_projectDown? = nil, volumes: Bool = false, removeOrphans: Bool = false, timeout: TimeInterval? = nil) async throws {
        var t: Int? = nil
        if let timeout = timeout {
            t = Int(timeout.rounded())
        }
        return try await ProjectAPI.projectDown(host: context.host, name: name, context: context.name, rmi: rmi, volumes: volumes, removeorphans: removeOrphans, timeout: t, session: context.session)
    }
    
    /**
     Stream container events for every container in the project
     - GET /projects/{name}/events
     - Stream container events for every container in the project.  With the --json flag, a json object is printed one per line with the format:  ``` {     \"time\": \"2015-11-20T18:01:03.615550\",     \"type\": \"container\",     \"action\": \"create\",     \"id\": \"213cf7...5fc39a\",     \"service\": \"web\",     \"attributes\": {         \"name\": \"application_web_1\",         \"image\": \"alpine:edge\"     } } ```  The events that can be received using this can be seen [here](https://docs.docker.com/engine/reference/commandline/events/#object-types).
     - parameter services: (query) Get events only for the given services.  (optional)
     - returns: SystemEventsResponse
     */
    public func events(services: [String]? = nil) async throws -> some AsyncSequence {
        try await ProjectAPI.projectEvents(host: context.host, name: name, context: context.name, services: services, session: context.session).stream
    }
    
    /**
     List images used by the created containers.
     - GET /projects/{name}/images
     - List images used by the created containers.
     - parameter services: (query) Get events only for the given services.  (optional)
     - returns: [ProjectImageResponseItem]
     */
    public func images(services: [String]? = nil) async throws -> ProjectImagesResponse {
        try await ProjectAPI.projectImages(host: context.host, name: name, context: context.name, services: services, quiet: false, session: context.session)
    }
    
    /**
     Inspect a project
     - GET /projects/{name}
     - Return the docker-compose.yml configuration file of the project
     - returns: String
     */
    public func inspect() async throws -> ProjectInspectResponse {
        try await ProjectAPI.projectInspect(host: context.host, name: name, context: context.name, session: context.session)
    }
    
    /**
     Forces running containers to stop by sending a SIGKILL signal.
     - POST /projects/{name}/kill
     - Forces running containers to stop by sending a SIGKILL signal.
     - parameter services: (query) Get events only for the given services.  (optional)
     - parameter signal: (query) SIGNAL to send to the container. (optional, default to "SIGKILL")
     
     */
    public func kill(services: [String]? = nil, signal: String? = nil) async throws {
        try await ProjectAPI.projectKill(host: context.host, name: name, context: context.name, services: services, signal: signal, session: context.session)
    }
    
    /**
     Get project logs
     - GET /projects/{name}/logs
     - Get `stdout` and `stderr` logs from a project.  Note: This endpoint works only for containers with the `json-file` or `journald` logging driver.
     - parameter services: (query) Get events only for the given services.  (optional)
     - parameter timestamps: (query) Add timestamps to every log line (optional, default to false)
     - parameter tail: (query) Only return this number of log lines from the end of the logs. Specify as an integer or &#x60;all&#x60; to output all log lines.  (optional, default to "all")
     - returns: [LogObject]
     */
    public func logsStream(services: [String]? = nil, timestamps: Bool = false, tail: Int? = nil) async throws -> some AsyncSequence {
        var tailStr: String? = nil
        if let tail = tail {
            tailStr = String(tail)
        }
        return try await ProjectAPI.projectStreamLogs(host: context.host, name: name, context: context.name, services: services, timestamps: timestamps, tail: tailStr, session: context.session).stream
    }
    
    /**
     Get project logs
     - GET /projects/{name}/logs
     - Get `stdout` and `stderr` logs from a project.  Note: This endpoint works only for containers with the `json-file` or `journald` logging driver.
     - parameter services: (query) Get events only for the given services.  (optional)
     - parameter timestamps: (query) Add timestamps to every log line (optional, default to false)
     - parameter tail: (query) Only return this number of log lines from the end of the logs. Specify as an integer or &#x60;all&#x60; to output all log lines.  (optional, default to "all")
     - returns: [LogObject]
     */
    public func logs(services: [String]? = nil, timestamps: Bool = false, tail: Int? = nil) async throws -> ProjectLogResponse {
        var tailStr: String? = nil
        if let tail = tail {
            tailStr = String(tail)
        }
        return try await ProjectAPI.projectLogs(host: context.host, name: name, context: context.name, services: services, timestamps: timestamps, tail: tailStr, session: context.session)
    }
    
    /**
     Pauses running containers of a service.
     - POST /projects/{name}/pause
     - Pauses running containers of a service.
     - parameter services: (query) Get events only for the given services.  (optional)
     
     */
    public func pause(services: [String]? = nil) async throws {
        try await ProjectAPI.projectPause(host: context.host, name: name, context: context.name, services: services, session: context.session)
    }
    
    /**
     Lists containers.
     - POST /projects/{name}/ps
     - Lists containers.
     - parameter services: (query) Get events only for the given services.  (optional)
     - parameter all: (query) Show all stopped containers (including those created by the run command)  (optional, default to false)
     - returns: [ProjectContainerSummaryItem]
     */
    public func containers(services: [String]? = nil, all: Bool? = false) async throws -> ProjectContainerSummary {
        try await ProjectAPI.projectPs(host: context.host, name: name, context: context.name, services: services, all: all, session: context.session)
    }
    
    /**
     Pulls images associated with a service.
     - POST /projects/{name}/pull
     - Pulls an image associated with a service defined in a `docker-compose.yml` or `docker-stack.yml` file, but does not start containers based on those images.  For example, suppose you have this `docker-compose.yml` file from the [Quickstart: Compose and Rails sample]{https://docs.docker.com/samples/rails/}.  ``` version: '2' services:   db:     image: postgres   web:     build: .     command: bundle exec rails s -p 3000 -b '0.0.0.0'     volumes:       - .:/myapp     ports:       - \"3000:3000\"     depends_on:       - db ```  If you run `docker-compose pull ServiceName` in the same directory as the `docker-compose.yml` file that defines the service, Docker pulls the associated image. For example, to call the `postgres` image configured as the `db` service in our example, you would run `docker-compose pull db`.  ``` $ docker-compose pull db ```
     - parameter ignorepullfailures: (query) Pull what it can and ignores images with pull failures. (optional, default to false)
     - returns: URL
     */
    public func pullStream(ignorePullFailures: Bool = false) async throws -> some AsyncSequence {
        try await ProjectAPI.projectStreamPull(host: context.host, name: name, context: context.name, ignorepullfailures: ignorePullFailures, session: context.session).stream
    }
    
    /**
     Pulls images associated with a service.
     - POST /projects/{name}/pull
     - Pulls an image associated with a service defined in a `docker-compose.yml` or `docker-stack.yml` file, but does not start containers based on those images.  For example, suppose you have this `docker-compose.yml` file from the [Quickstart: Compose and Rails sample]{https://docs.docker.com/samples/rails/}.  ``` version: '2' services:   db:     image: postgres   web:     build: .     command: bundle exec rails s -p 3000 -b '0.0.0.0'     volumes:       - .:/myapp     ports:       - \"3000:3000\"     depends_on:       - db ```  If you run `docker-compose pull ServiceName` in the same directory as the `docker-compose.yml` file that defines the service, Docker pulls the associated image. For example, to call the `postgres` image configured as the `db` service in our example, you would run `docker-compose pull db`.  ``` $ docker-compose pull db ```
     - parameter ignorepullfailures: (query) Pull what it can and ignores images with pull failures. (optional, default to false)
     - returns: URL
     */
    public func pull(ignorePullFailures: Bool = false) async throws -> String {
        try await ProjectAPI.projectPull(host: context.host, name: name, context: context.name, ignorepullfailures: ignorePullFailures, session: context.session)
    }
    
    /**
     Pushes images for services to their respective `registry/repository`.
     - POST /projects/{name}/push
     - Pushes images for services to their respective `registry/repository`.  The following assumptions are made:   * You are pushing an image you have built locally   * You have access to the build key
     - parameter name: (path) Name of the project
     - parameter context: (query) The context to connect to. (optional)
     - parameter ignorepushfailures: (query) Push what it can and ignores images with push failures. (optional, default to false)
     
     */
    public func push(ignorePushFailures: Bool = false) async throws {
        try await ProjectAPI.projectPush(host: context.host, name: name, context: context.name, ignorepushfailures: ignorePushFailures, session: context.session)
    }
    
    /**
     Removes stopped service containers.
     - POST /projects/{name}/rm
     - Removes stopped service containers.  By default, anonymous volumes attached to containers are not removed. You can override this with `-v`. To list all volumes, use `docker volume ls`.  Any data which is not in a volume is lost.  Running the command with no options also removes one-off containers created by `docker-compose up` or `docker-compose run`:  ``` $ docker-compose rm Going to remove djangoquickstart_web_run_1 Are you sure? [yN] y Removing djangoquickstart_web_run_1 ... done ```
     - parameter services: (query) Get events only for the given services.  (optional)
     - parameter volumes: (query) Remove any anonymous volumes attached to containers  (optional, default to false)
     
     */
    public func remove(services: [String]? = nil, volumes: Bool = false) async throws {
        try await ProjectAPI.projectRemove(host: context.host, name: name, context: context.name, services: services, volumes: volumes, session: context.session)
    }
    
    /**
     Restarts all stopped and running services.
     - POST /projects/{name}/restart
     - Restarts all stopped and running services.  If you make changes to your `docker-compose.yml` configuration these changes are not reflected after running this command.  For example, changes to environment variables (which are added after a container is built,  but before the container’s command is executed) are not updated after restarting.  If you are looking to configure a service’s restart policy,  please refer to [restart]{https://docs.docker.com/compose/compose-file/compose-file-v3/#restart} in Compose file v3  and [restart]{https://docs.docker.com/compose/compose-file/compose-file-v2/#restart} in Compose v2.  Note that if you are [deploying a stack in swarm mode]{https://docs.docker.com/engine/reference/commandline/stack_deploy/},  you should use [restart_policy]{https://docs.docker.com/compose/compose-file/compose-file-v3/#restart_policy}, instead.
     - parameter services: (query) Get events only for the given services.  (optional)
     - parameter timeout: (query) Specify a shutdown timeout in seconds. (optional, default to 10)
     
     */
    public func restart(services: [String]? = nil, timeout: TimeInterval? = nil) async throws {
        var t: Int? = nil
        if let timeout = timeout {
            t = Int(timeout.rounded())
        }
        return try await ProjectAPI.projectRestart(host: context.host, name: name, context: context.name, services: services, timeout: t, session: context.session)
    }
    
    /**
     Runs a one-time command against a service.
     - POST /projects/{name}/run/{service}
     - Runs a one-time command against a service. For example, the following command starts the `web` service and runs `bash` as its command.  ``` docker-compose run web bash ```  Commands you use with run start in new containers with configuration defined by that of the service, including volumes, links, and other details. However, there are two important differences.  First, the command passed by run overrides the command defined in the service configuration. For example, if the `web` service configuration is started with `bash`, then `docker-compose run web python app.py` overrides it with `python app.py`.  The second difference is that the docker-compose run command does not create any of the ports specified in the service configuration. This prevents port collisions with already-open ports. If you do want the service’s ports to be created and mapped to the host, specify the `--service-ports` flag:  ``` docker-compose run --service-ports web python manage.py shell ```  Alternatively, manual port mapping can be specified with the `--publish` or `-p` options, just as when using `docker run`:  ``` docker-compose run --publish 8080:80 -p 2022:22 -p 127.0.0.1:2021:21 web python manage.py shell ```  If you start a service configured with links, the `run` command first checks to see if the linked service is running and starts the service if it is stopped. Once all the linked services are running, the `run` executes the command you passed it. For example, you could run:  ``` docker-compose run db psql -h db -U docker ```  This opens an interactive PostgreSQL shell for the linked `db` container.  If you do not want the run command to start linked containers, use the `--no-deps` flag:  ``` docker-compose run --no-deps web python manage.py shell ```  If you want to remove the container after running while overriding the container’s restart policy, use the `--rm` flag:  docker-compose run --rm web python manage.py db upgrade This runs a database upgrade script, and removes the container when finished running, even if a restart policy is specified in the service configuration.
     - parameter service: (path) The name of the service to run in.
     - parameter body: (body)
     - parameter detach: (query) Run container in the background. No streamed response. (optional, default to false)
     - parameter autoremove: (query) Remove Container afterwards. (optional, default to false)
     - returns: URL
     */
    public func runStream(service: String, body: ProjectRunBody, detach: Bool = false, autoRemove: Bool = false) async throws -> some AsyncSequence {
        try await ProjectAPI.projectStreamRun(host: context.host, name: name, service: service, body: body, context: context.name, detach: detach, autoremove: autoRemove, session: context.session).stream
    }
    
    /**
     Runs a one-time command against a service.
     - POST /projects/{name}/run/{service}
     - Runs a one-time command against a service. For example, the following command starts the `web` service and runs `bash` as its command.  ``` docker-compose run web bash ```  Commands you use with run start in new containers with configuration defined by that of the service, including volumes, links, and other details. However, there are two important differences.  First, the command passed by run overrides the command defined in the service configuration. For example, if the `web` service configuration is started with `bash`, then `docker-compose run web python app.py` overrides it with `python app.py`.  The second difference is that the docker-compose run command does not create any of the ports specified in the service configuration. This prevents port collisions with already-open ports. If you do want the service’s ports to be created and mapped to the host, specify the `--service-ports` flag:  ``` docker-compose run --service-ports web python manage.py shell ```  Alternatively, manual port mapping can be specified with the `--publish` or `-p` options, just as when using `docker run`:  ``` docker-compose run --publish 8080:80 -p 2022:22 -p 127.0.0.1:2021:21 web python manage.py shell ```  If you start a service configured with links, the `run` command first checks to see if the linked service is running and starts the service if it is stopped. Once all the linked services are running, the `run` executes the command you passed it. For example, you could run:  ``` docker-compose run db psql -h db -U docker ```  This opens an interactive PostgreSQL shell for the linked `db` container.  If you do not want the run command to start linked containers, use the `--no-deps` flag:  ``` docker-compose run --no-deps web python manage.py shell ```  If you want to remove the container after running while overriding the container’s restart policy, use the `--rm` flag:  docker-compose run --rm web python manage.py db upgrade This runs a database upgrade script, and removes the container when finished running, even if a restart policy is specified in the service configuration.
     - parameter body: (body)
     - parameter detach: (query) Run container in the background. No streamed response. (optional, default to false)
     - parameter autoremove: (query) Remove Container afterwards. (optional, default to false)
     - returns: URL
     */
    public func run(service: String, body: ProjectRunBody, detach: Bool? = nil, autoRemove: Bool? = nil) async throws -> ProjectRunResponse {
        try await ProjectAPI.projectRun(host: context.host, name: context.name, service: service, body: body, context: context.name, detach: detach, autoremove: autoRemove, session: context.session)
    }
    
    /**
     Starts existing containers for a service.
     - POST /projects/{name}/start
     - Starts existing containers for a service.
     - parameter services: (query) Get events only for the given services.  (optional)
     
     */
    public func start(services: [String]? = nil) async throws {
        try await ProjectAPI.projectStart(host: context.host, name: name, context: context.name, services: services, session: context.session)
    }
    
    /**
     Stops running containers without removing them.
     - POST /projects/{name}/stop
     - Stops running containers without removing them. They can be started again with `docker-compose start`.
     - parameter services: (query) Get events only for the given services.  (optional)
     - parameter timeout: (query) Specify a shutdown timeout in seconds.  (optional, default to 10)
     
     */
    public func stop(services: [String]? = nil, timeout: TimeInterval? = nil) async throws {
        var t: Int? = nil
        if let timeout = timeout {
            t = Int(timeout.rounded())
        }
        return try await ProjectAPI.projectStop(host: context.host, name: name, context: context.name, services: services, timeout: t, session: context.session)
    }
    
    /**
     Displays the running processes.
     - GET /projects/{name}/top
     - Displays the running processes.
     - parameter services: (query) Get events only for the given services.  (optional)
     - returns: [ProjectTopResponse]
     */
    public func top(services: [String]? = nil) async throws -> ProjectTopResponse {
        try await ProjectAPI.projectTop(host: context.host, name: name, context: context.name, services: services, session: context.session)
    }
    
    /**
     Unpauses paused containers of a service.
     - POST /projects/{name}/unpause
     - Unpauses paused containers of a service.
     - parameter services: (query) Get events only for the given services.  (optional)
     
     */
    public func unpause(services: [String]? = nil) async throws {
        try await ProjectAPI.projectUnpause(host: context.host, name: name, context: context.name, services: services, session: context.session)
    }
    
    /**
     Builds, (re)creates, starts, and attaches to containers for a service.
     - POST /projects/{name}/up
     - Builds, (re)creates, starts, and attaches to containers for a service.  Unless they are already running, this command also starts any linked services.  The `docker-compose up` command aggregates the output of each container (essentially running `docker-compose logs --follow`). When the command exits, all containers are stopped. Running `docker-compose up --detach` starts the containers in the background and leaves them running.  If there are existing containers for a service, and the service’s configuration or image was changed after the container’s creation, `docker-compose up` picks up the changes by stopping and recreating the containers (preserving mounted volumes).  To prevent Compose from picking up changes, use the `--no-recreate` flag.  If you want to force Compose to stop and recreate all containers, use the `--force-recreate` flag.  If the process encounters an error, the exit code for this command is `1`. If the process is interrupted using `SIGINT` (`ctrl` + `C`) or `SIGTERM`, the containers are stopped, and the exit code is `0`. If `SIGINT` or `SIGTERM` is sent again during this shutdown phase, the running containers are killed, and the exit code is `2`.
     - parameter services: (query) Get events only for the given services.  (optional)
     - parameter quietpull: (query) Pull without printing progress information. (optional, default to false)
     - parameter deps: (query) Start linked services. (optional, default to true)
     - parameter forcerecreate: (query) Recreate containers even if their configuration and image haven&#39;t changed. (optional, default to false)
     - parameter alwaysrecreatedeps: (query) Recreate dependent containers. (optional, default to false)
     - parameter recreate: (query) If containers already exist, recreate them. (optional, default to true)
     - parameter nobuild: (query) Don&#39;t build an image, even if it&#39;s missing. (optional, default to false)
     - parameter start: (query) Start the services after creating them. (optional, default to true)
     - parameter build: (query) Build images before starting containers. (optional, default to false)
     - parameter abortexit: (query) Stops all container if any container was stopped. (optional, default to false)
     - parameter attachdeps: (query) Attach to dependent containers. (optional, default to false)
     - parameter timeout: (query) Use this timeout in seconds for container shutdown when attached or when containers are already running. (optional, default to 10)
     - parameter renewvolumes: (query) Recreate anonymous volumes instead of retrieving data from the previous containers. (optional, default to false)
     - parameter removeorphans: (query) Remove containers for service not defined in the Compose file. (optional, default to false)
     - parameter exitcodefrom: (query) Return the exit code of the selected service container. (optional)
     - parameter abortoncontainerexit: (query) Stops all containers if any container was stopped. Incompatible with -d. (optional, default to false)
     - parameter attach: (query) Attach to service output. (optional)
     - parameter scale: (query) Scale &#x60;SERVICE&#x60; to &#x60;NUM&#x60; instances. JSON map of string pairs for scaleing. For example, the arg &#x60;FOO&#x3D;bar&#x60; would become &#x60;{\&quot;FOO\&quot;:\&quot;bar\&quot;}&#x60; in JSON. This would result in the query parameter &#x60;scale&#x3D;{\&quot;FOO\&quot;:\&quot;bar\&quot;}&#x60;. Note that &#x60;{\&quot;FOO\&quot;:\&quot;bar\&quot;}&#x60; should be URI component encoded.  (optional)
     - returns: [LogObject]
     */
    public func up(services: [String]? = nil, quietPull: Bool = false, deps: Bool = true, forceRecreate: Bool = false, alwaysRecreateDeps: Bool = false, recreate: Bool = true, noBuild: Bool = false, start: Bool = true, build: Bool = false, abortExit: Bool = false, attachDeps: Bool = false, timeout: TimeInterval? = nil, renewVolumes: Bool = false, removeOrphans: Bool = false, exitCodeFrom: String? = nil, abortOnContainerExit: Bool = false, attach: [String]? = nil, scale: String? = nil) async throws -> some AsyncSequence {
        var t: Int? = nil
        if let timeout = timeout {
            t = Int(timeout.rounded())
        }
        return try await ProjectAPI.projectUp(host: context.host, name: name, context: context.name, services: services, quietpull: quietPull, deps: deps, forcerecreate: forceRecreate, alwaysrecreatedeps: alwaysRecreateDeps, recreate: recreate, nobuild: noBuild, start: start, build: build, abortexit: abortExit, attachdeps: attachDeps, timeout: t, renewvolumes: renewVolumes, removeorphans: removeOrphans, exitcodefrom: exitCodeFrom, abortoncontainerexit: abortOnContainerExit, attach: attach, scale: scale, session: context.session).stream
    }
    
    /**
     Builds, (re)creates, starts, and attaches to containers for a service.
     - POST /projects/{name}/up
     - Builds, (re)creates, starts, and attaches to containers for a service.  Unless they are already running, this command also starts any linked services.  The `docker-compose up` command aggregates the output of each container (essentially running `docker-compose logs --follow`). When the command exits, all containers are stopped. Running `docker-compose up --detach` starts the containers in the background and leaves them running.  If there are existing containers for a service, and the service’s configuration or image was changed after the container’s creation, `docker-compose up` picks up the changes by stopping and recreating the containers (preserving mounted volumes).  To prevent Compose from picking up changes, use the `--no-recreate` flag.  If you want to force Compose to stop and recreate all containers, use the `--force-recreate` flag.  If the process encounters an error, the exit code for this command is `1`. If the process is interrupted using `SIGINT` (`ctrl` + `C`) or `SIGTERM`, the containers are stopped, and the exit code is `0`. If `SIGINT` or `SIGTERM` is sent again during this shutdown phase, the running containers are killed, and the exit code is `2`.
     - parameter services: (query) Get events only for the given services.  (optional)
     - parameter detach: (query) Run containers in the background, print new container names. (optional, default to false)
     - parameter quietpull: (query) Pull without printing progress information. (optional, default to false)
     - parameter deps: (query) Start linked services. (optional, default to true)
     - parameter forcerecreate: (query) Recreate containers even if their configuration and image haven&#39;t changed. (optional, default to false)
     - parameter alwaysrecreatedeps: (query) Recreate dependent containers. (optional, default to false)
     - parameter recreate: (query) If containers already exist, recreate them. (optional, default to true)
     - parameter nobuild: (query) Don&#39;t build an image, even if it&#39;s missing. (optional, default to false)
     - parameter start: (query) Start the services after creating them. (optional, default to true)
     - parameter build: (query) Build images before starting containers. (optional, default to false)
     - parameter abortexit: (query) Stops all container if any container was stopped. (optional, default to false)
     - parameter attachdeps: (query) Attach to dependent containers. (optional, default to false)
     - parameter timeout: (query) Use this timeout in seconds for container shutdown when attached or when containers are already running. (optional, default to 10)
     - parameter renewvolumes: (query) Recreate anonymous volumes instead of retrieving data from the previous containers. (optional, default to false)
     - parameter removeorphans: (query) Remove containers for service not defined in the Compose file. (optional, default to false)
     - parameter exitcodefrom: (query) Return the exit code of the selected service container. (optional)
     - parameter abortoncontainerexit: (query) Stops all containers if any container was stopped. Incompatible with -d. (optional, default to false)
     - parameter attach: (query) Attach to service output. (optional)
     - parameter scale: (query) Scale &#x60;SERVICE&#x60; to &#x60;NUM&#x60; instances. JSON map of string pairs for scaleing. For example, the arg &#x60;FOO&#x3D;bar&#x60; would become &#x60;{\&quot;FOO\&quot;:\&quot;bar\&quot;}&#x60; in JSON. This would result in the query parameter &#x60;scale&#x3D;{\&quot;FOO\&quot;:\&quot;bar\&quot;}&#x60;. Note that &#x60;{\&quot;FOO\&quot;:\&quot;bar\&quot;}&#x60; should be URI component encoded.  (optional)
     - returns: [LogObject]
     */
    public func upDetach(services: [String]? = nil, quietPull: Bool = false, deps: Bool = true, forceRecreate: Bool = false, alwaysRecreateDeps: Bool = false, recreate: Bool = true, noBuild: Bool = false, start: Bool = true, build: Bool = false, abortExit: Bool = false, attachDeps: Bool = false, timeout: TimeInterval? = nil, renewVolumes: Bool = false, removeOrphans: Bool = false, exitCodeFrom: String? = nil, abortOnContainerExit: Bool = false, attach: [String]? = nil, scale: String? = nil) async throws {
        var t: Int? = nil
        if let timeout = timeout {
            t = Int(timeout.rounded())
        }
        try await ProjectAPI.projectDetachUp(host: context.host, name: name, context: context.name, services: services, quietpull: quietPull, deps: deps, forcerecreate: forceRecreate, alwaysrecreatedeps: alwaysRecreateDeps, recreate: recreate, nobuild: noBuild, start: start, build: build, abortexit: abortExit, attachdeps: attachDeps, timeout: t, renewvolumes: renewVolumes, removeorphans: removeOrphans, exitcodefrom: exitCodeFrom, abortoncontainerexit: abortOnContainerExit, attach: attach, scale: scale, session: context.session)
    }
}
