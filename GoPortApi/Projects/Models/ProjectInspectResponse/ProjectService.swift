// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let projectService = try? newJSONDecoder().decode(ProjectService.self, from: jsonData)

import Foundation

// MARK: - ProjectService
public struct ProjectService: Codable {
    public var blkioConfig: ProjectBlkioConfig?
    public var build: ProjectBuildUnion?
    public var capAdd: [String]?
    public var capDrop: [String]?
    public var cgroupParent: String?
    public var command: ProjectStringOrList?
    public var configs: [ProjectConfigUnion]?
    public var containerName: String?
    public var cpuCount: Int?
    public var cpuPercent: Int?
    public var cpuPeriod: ProjectCPUPeriod?
    public var cpuQuota: ProjectCPUPeriod?
    public var cpuRtPeriod: ProjectCPUPeriod?
    public var cpuRtRuntime: ProjectCPUPeriod?
    public var cpuShares: ProjectCPUPeriod?
    public var cpus: ProjectCPUPeriod?
    public var cpuset: String?
    public var credentialSpec: ProjectCredentialSpec?
    public var dependsOn: ProjectDependsOnUnion?
    public var deploy: ProjectDeployment?
    public var deviceCgroupRules: [String]?
    public var devices: [String]?
    public var dns: ProjectStringOrList?
    public var dnsOpt: [String]?
    public var dnsSearch: ProjectStringOrList?
    public var domainname: String?
    public var entrypoint: ProjectStringOrList?
    public var envFile: ProjectStringOrList?
    public var environment: ProjectListOrDict?
    public var expose: [ProjectCPUPeriod]?
    public var extends: ProjectExtendsUnion?
    public var externalLinks: [String]?
    public var extraHosts: ProjectListOrDict?
    public var groupAdd: [ProjectCPUPeriod]?
    public var healthcheck: ProjectHealthcheck?
    public var hostname: String?
    public var image: String?
    public var serviceInit: Bool?
    public var ipc: String?
    public var isolation: String?
    public var labels: ProjectListOrDict?
    public var links: [String]?
    public var logging: ProjectLogging?
    public var macAddress: String?
    public var memLimit: ProjectCPUPeriod?
    public var memReservation: ProjectRate?
    public var memSwappiness: Int?
    public var memswapLimit: ProjectCPUPeriod?
    public var networkMode: String?
    public var networks: ProjectNetworks?
    public var oomKillDisable: Bool?
    public var oomScoreAdj: Int?
    public var pid: String?
    public var pidsLimit: ProjectCPUPeriod?
    public var platform: String?
    public var ports: [ProjectPortElement]?
    public var privileged: Bool?
    public var profiles: [String]?
    public var pullPolicy: ProjectPullPolicy?
    public var readOnly: Bool?
    public var restart: String?
    public var runtime: String?
    public var scale: Int?
    public var secrets: [ProjectSecretElement]?
    public var securityOpt: [String]?
    public var shmSize: ProjectCPUPeriod?
    public var stdinOpen: Bool?
    public var stopGracePeriod: String?
    public var stopSignal: String?
    public var storageOpt: [String: JSONAny]?
    public var sysctls: ProjectListOrDict?
    public var tmpfs: ProjectStringOrList?
    public var tty: Bool?
    public var ulimits: [String: ProjectUlimitValue]?
    public var user: String?
    public var usernsMode: String?
    public var volumes: [ProjectVolumeElement]?
    public var volumesFrom: [String]?
    public var workingDir: String?

    enum CodingKeys: String, CodingKey {
        case blkioConfig
        case build
        case capAdd
        case capDrop
        case cgroupParent
        case command
        case configs
        case containerName
        case cpuCount
        case cpuPercent
        case cpuPeriod
        case cpuQuota
        case cpuRtPeriod
        case cpuRtRuntime
        case cpuShares
        case cpus
        case cpuset
        case credentialSpec
        case dependsOn
        case deploy
        case deviceCgroupRules
        case devices
        case dns
        case dnsOpt
        case dnsSearch
        case domainname
        case entrypoint
        case envFile
        case environment
        case expose
        case extends
        case externalLinks
        case extraHosts
        case groupAdd
        case healthcheck
        case hostname
        case image
        case serviceInit
        case ipc
        case isolation
        case labels
        case links
        case logging
        case macAddress
        case memLimit
        case memReservation
        case memSwappiness
        case memswapLimit
        case networkMode
        case networks
        case oomKillDisable
        case oomScoreAdj
        case pid
        case pidsLimit
        case platform
        case ports
        case privileged
        case profiles
        case pullPolicy
        case readOnly
        case restart
        case runtime
        case scale
        case secrets
        case securityOpt
        case shmSize
        case stdinOpen
        case stopGracePeriod
        case stopSignal
        case storageOpt
        case sysctls
        case tmpfs
        case tty
        case ulimits
        case user
        case usernsMode
        case volumes
        case volumesFrom
        case workingDir
    }

    public init(blkioConfig: ProjectBlkioConfig?, build: ProjectBuildUnion?, capAdd: [String]?, capDrop: [String]?, cgroupParent: String?, command: ProjectStringOrList?, configs: [ProjectConfigUnion]?, containerName: String?, cpuCount: Int?, cpuPercent: Int?, cpuPeriod: ProjectCPUPeriod?, cpuQuota: ProjectCPUPeriod?, cpuRtPeriod: ProjectCPUPeriod?, cpuRtRuntime: ProjectCPUPeriod?, cpuShares: ProjectCPUPeriod?, cpus: ProjectCPUPeriod?, cpuset: String?, credentialSpec: ProjectCredentialSpec?, dependsOn: ProjectDependsOnUnion?, deploy: ProjectDeployment?, deviceCgroupRules: [String]?, devices: [String]?, dns: ProjectStringOrList?, dnsOpt: [String]?, dnsSearch: ProjectStringOrList?, domainname: String?, entrypoint: ProjectStringOrList?, envFile: ProjectStringOrList?, environment: ProjectListOrDict?, expose: [ProjectCPUPeriod]?, extends: ProjectExtendsUnion?, externalLinks: [String]?, extraHosts: ProjectListOrDict?, groupAdd: [ProjectCPUPeriod]?, healthcheck: ProjectHealthcheck?, hostname: String?, image: String?, serviceInit: Bool?, ipc: String?, isolation: String?, labels: ProjectListOrDict?, links: [String]?, logging: ProjectLogging?, macAddress: String?, memLimit: ProjectCPUPeriod?, memReservation: ProjectRate?, memSwappiness: Int?, memswapLimit: ProjectCPUPeriod?, networkMode: String?, networks: ProjectNetworks?, oomKillDisable: Bool?, oomScoreAdj: Int?, pid: String?, pidsLimit: ProjectCPUPeriod?, platform: String?, ports: [ProjectPortElement]?, privileged: Bool?, profiles: [String]?, pullPolicy: ProjectPullPolicy?, readOnly: Bool?, restart: String?, runtime: String?, scale: Int?, secrets: [ProjectSecretElement]?, securityOpt: [String]?, shmSize: ProjectCPUPeriod?, stdinOpen: Bool?, stopGracePeriod: String?, stopSignal: String?, storageOpt: [String: JSONAny]?, sysctls: ProjectListOrDict?, tmpfs: ProjectStringOrList?, tty: Bool?, ulimits: [String: ProjectUlimitValue]?, user: String?, usernsMode: String?, volumes: [ProjectVolumeElement]?, volumesFrom: [String]?, workingDir: String?) {
        self.blkioConfig = blkioConfig
        self.build = build
        self.capAdd = capAdd
        self.capDrop = capDrop
        self.cgroupParent = cgroupParent
        self.command = command
        self.configs = configs
        self.containerName = containerName
        self.cpuCount = cpuCount
        self.cpuPercent = cpuPercent
        self.cpuPeriod = cpuPeriod
        self.cpuQuota = cpuQuota
        self.cpuRtPeriod = cpuRtPeriod
        self.cpuRtRuntime = cpuRtRuntime
        self.cpuShares = cpuShares
        self.cpus = cpus
        self.cpuset = cpuset
        self.credentialSpec = credentialSpec
        self.dependsOn = dependsOn
        self.deploy = deploy
        self.deviceCgroupRules = deviceCgroupRules
        self.devices = devices
        self.dns = dns
        self.dnsOpt = dnsOpt
        self.dnsSearch = dnsSearch
        self.domainname = domainname
        self.entrypoint = entrypoint
        self.envFile = envFile
        self.environment = environment
        self.expose = expose
        self.extends = extends
        self.externalLinks = externalLinks
        self.extraHosts = extraHosts
        self.groupAdd = groupAdd
        self.healthcheck = healthcheck
        self.hostname = hostname
        self.image = image
        self.serviceInit = serviceInit
        self.ipc = ipc
        self.isolation = isolation
        self.labels = labels
        self.links = links
        self.logging = logging
        self.macAddress = macAddress
        self.memLimit = memLimit
        self.memReservation = memReservation
        self.memSwappiness = memSwappiness
        self.memswapLimit = memswapLimit
        self.networkMode = networkMode
        self.networks = networks
        self.oomKillDisable = oomKillDisable
        self.oomScoreAdj = oomScoreAdj
        self.pid = pid
        self.pidsLimit = pidsLimit
        self.platform = platform
        self.ports = ports
        self.privileged = privileged
        self.profiles = profiles
        self.pullPolicy = pullPolicy
        self.readOnly = readOnly
        self.restart = restart
        self.runtime = runtime
        self.scale = scale
        self.secrets = secrets
        self.securityOpt = securityOpt
        self.shmSize = shmSize
        self.stdinOpen = stdinOpen
        self.stopGracePeriod = stopGracePeriod
        self.stopSignal = stopSignal
        self.storageOpt = storageOpt
        self.sysctls = sysctls
        self.tmpfs = tmpfs
        self.tty = tty
        self.ulimits = ulimits
        self.user = user
        self.usernsMode = usernsMode
        self.volumes = volumes
        self.volumesFrom = volumesFrom
        self.workingDir = workingDir
    }
}
