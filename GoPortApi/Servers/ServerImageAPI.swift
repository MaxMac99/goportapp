//
//  ServerImageAPI.swift
//  GoPortApi
//
//  Created by Max Vissing on 31.01.22.
//

import Foundation

extension Server {
    /**
     Delete builder cache
     - POST /build/prune
     - parameter keepStorage: (query) Amount of disk space in bytes to keep for cache (optional)
     - parameter all: (query) Remove all types of build cache (optional)
     - parameter filters: (query) A JSON encoded value of the filters (a &#x60;map[string][]string&#x60;) to process on the list of build cache objects.  Available filters:  - &#x60;until&#x3D;&lt;duration&gt;&#x60;: duration relative to daemon&#39;s time, during which build cache was not used, in Go&#39;s duration format (e.g., &#39;24h&#39;) - &#x60;id&#x3D;&lt;id&gt;&#x60; - &#x60;parent&#x3D;&lt;id&gt;&#x60; - &#x60;type&#x3D;&lt;string&gt;&#x60; - &#x60;description&#x3D;&lt;string&gt;&#x60; - &#x60;inuse&#x60; - &#x60;shared&#x60; - &#x60;private&#x60;  (optional)
     - returns: BuildPruneResponse
     */
    public func pruneBuild(keepStorage: Int64? = nil, all: Bool? = nil, filters: String? = nil) async throws -> [(context: GoPortContext, response: BuildPruneResponseItem)] {
        try stringToDockerContext(try await ImageAPI.buildPrune(host: host, context: selectedContextsString, keepStorage: keepStorage, all: all, filters: filters, session: session))
    }
    
    /**
     List Images
     - GET /images/json
     - Returns a list of images on the server. Note that it uses a different, smaller representation of an image than inspecting a single image.
     - parameter all: (query) Show all images. Only images from a final layer (no children) are shown by default. (optional, default to false)
     - parameter filters: (query) A JSON encoded value of the filters (a &#x60;map[string][]string&#x60;) to process on the images list.  Available filters:  - &#x60;before&#x60;&#x3D;(&#x60;&lt;image-name&gt;[:&lt;tag&gt;]&#x60;,  &#x60;&lt;image id&gt;&#x60; or &#x60;&lt;image@digest&gt;&#x60;) - &#x60;dangling&#x3D;true&#x60; - &#x60;label&#x3D;key&#x60; or &#x60;label&#x3D;\&quot;key&#x3D;value\&quot;&#x60; of an image label - &#x60;reference&#x60;&#x3D;(&#x60;&lt;image-name&gt;[:&lt;tag&gt;]&#x60;) - &#x60;since&#x60;&#x3D;(&#x60;&lt;image-name&gt;[:&lt;tag&gt;]&#x60;,  &#x60;&lt;image id&gt;&#x60; or &#x60;&lt;image@digest&gt;&#x60;)  (optional)
     - parameter digests: (query) Show digest information as a &#x60;RepoDigests&#x60; field on each image. (optional, default to false)
     - returns: [String: [ImageSummary]]
     */
    public func images(all: Bool = false, filters: String? = nil, digests: Bool = false) async throws -> [(context: GoPortContext, response: ImageListResponseItem)] {
        try stringToDockerContext(try await ImageAPI.imageList(host: host, context: selectedContextsString, all: all, filters: filters, digests: digests, session: session))
    }
    
    /**
     Delete unused images
     - POST /images/prune
     - parameter filters: (query) Filters to process on the prune list, encoded as JSON (a &#x60;map[string][]string&#x60;). Available filters:  - &#x60;dangling&#x3D;&lt;boolean&gt;&#x60; When set to &#x60;true&#x60; (or &#x60;1&#x60;), prune only    unused *and* untagged images. When set to &#x60;false&#x60;    (or &#x60;0&#x60;), all unused images are pruned. - &#x60;until&#x3D;&lt;string&gt;&#x60; Prune images created before this timestamp. The &#x60;&lt;timestamp&gt;&#x60; can be Unix timestamps, date formatted timestamps, or Go duration strings (e.g. &#x60;10m&#x60;, &#x60;1h30m&#x60;) computed relative to the daemon machine’s time. - &#x60;label&#x60; (&#x60;label&#x3D;&lt;key&gt;&#x60;, &#x60;label&#x3D;&lt;key&gt;&#x3D;&lt;value&gt;&#x60;, &#x60;label!&#x3D;&lt;key&gt;&#x60;, or &#x60;label!&#x3D;&lt;key&gt;&#x3D;&lt;value&gt;&#x60;) Prune images with (or without, in case &#x60;label!&#x3D;...&#x60; is used) the specified labels.  (optional)
     - returns: ImagePruneResponse
     */
    public func pruneImages(filters: String? = nil) async throws -> [(context: GoPortContext, response: ImagePruneResponseItem)] {
        try stringToDockerContext(try await ImageAPI.imagePrune(host: host, context: selectedContextsString, filters: filters, session: session))
    }
    
    /**
     Search images
     - GET /images/search
     - Search for an image on Docker Hub.
     - parameter term: (query) Term to search
     - parameter limit: (query) Maximum number of results to return (optional)
     - parameter filters: (query) A JSON encoded value of the filters (a &#x60;map[string][]string&#x60;) to process on the images list. Available filters:  - &#x60;is-automated&#x3D;(true|false)&#x60; - &#x60;is-official&#x3D;(true|false)&#x60; - &#x60;stars&#x3D;&lt;number&gt;&#x60; Matches images that has at least &#39;number&#39; stars.  (optional)
     - returns: [ImageSearchResponseItem]
     */
    public func searchImage(term: String, limit: Int? = nil, filters: String? = nil) async throws -> ImageSearchResponse {
        try await ImageAPI.imageSearch(host: host, term: term, context: nil, limit: limit, filters: filters, session: session)
    }
}

extension GoPortContext {
    /**
     Delete builder cache
     - POST /build/prune
     - parameter keepStorage: (query) Amount of disk space in bytes to keep for cache (optional)
     - parameter all: (query) Remove all types of build cache (optional)
     - parameter filters: (query) A JSON encoded value of the filters (a &#x60;map[string][]string&#x60;) to process on the list of build cache objects.  Available filters:  - &#x60;until&#x3D;&lt;duration&gt;&#x60;: duration relative to daemon&#39;s time, during which build cache was not used, in Go&#39;s duration format (e.g., &#39;24h&#39;) - &#x60;id&#x3D;&lt;id&gt;&#x60; - &#x60;parent&#x3D;&lt;id&gt;&#x60; - &#x60;type&#x3D;&lt;string&gt;&#x60; - &#x60;description&#x3D;&lt;string&gt;&#x60; - &#x60;inuse&#x60; - &#x60;shared&#x60; - &#x60;private&#x60;  (optional)
     - returns: BuildPruneResponse
     */
    public func pruneBuild(keepStorage: Int64? = nil, all: Bool? = nil, filters: String? = nil) async throws -> BuildPruneResponseItem {
        try await ImageAPI.buildPrune(host: host, context: [name], keepStorage: keepStorage, all: all, filters: filters, session: session).dockerContext(name)
    }
    
    /**
     List Images
     - GET /images/json
     - Returns a list of images on the server. Note that it uses a different, smaller representation of an image than inspecting a single image.
     - parameter all: (query) Show all images. Only images from a final layer (no children) are shown by default. (optional, default to false)
     - parameter filters: (query) A JSON encoded value of the filters (a &#x60;map[string][]string&#x60;) to process on the images list.  Available filters:  - &#x60;before&#x60;&#x3D;(&#x60;&lt;image-name&gt;[:&lt;tag&gt;]&#x60;,  &#x60;&lt;image id&gt;&#x60; or &#x60;&lt;image@digest&gt;&#x60;) - &#x60;dangling&#x3D;true&#x60; - &#x60;label&#x3D;key&#x60; or &#x60;label&#x3D;\&quot;key&#x3D;value\&quot;&#x60; of an image label - &#x60;reference&#x60;&#x3D;(&#x60;&lt;image-name&gt;[:&lt;tag&gt;]&#x60;) - &#x60;since&#x60;&#x3D;(&#x60;&lt;image-name&gt;[:&lt;tag&gt;]&#x60;,  &#x60;&lt;image id&gt;&#x60; or &#x60;&lt;image@digest&gt;&#x60;)  (optional)
     - parameter digests: (query) Show digest information as a &#x60;RepoDigests&#x60; field on each image. (optional, default to false)
     - returns: [String: [ImageSummary]]
     */
    public func images(all: Bool = false, filters: String? = nil, digests: Bool = false) async throws -> ImageListResponseItem {
        try await ImageAPI.imageList(host: host, context: [name], all: all, filters: filters, digests: digests, session: session).dockerContext(name)
    }
    
    /**
     Delete unused images
     - POST /images/prune
     - parameter filters: (query) Filters to process on the prune list, encoded as JSON (a &#x60;map[string][]string&#x60;). Available filters:  - &#x60;dangling&#x3D;&lt;boolean&gt;&#x60; When set to &#x60;true&#x60; (or &#x60;1&#x60;), prune only    unused *and* untagged images. When set to &#x60;false&#x60;    (or &#x60;0&#x60;), all unused images are pruned. - &#x60;until&#x3D;&lt;string&gt;&#x60; Prune images created before this timestamp. The &#x60;&lt;timestamp&gt;&#x60; can be Unix timestamps, date formatted timestamps, or Go duration strings (e.g. &#x60;10m&#x60;, &#x60;1h30m&#x60;) computed relative to the daemon machine’s time. - &#x60;label&#x60; (&#x60;label&#x3D;&lt;key&gt;&#x60;, &#x60;label&#x3D;&lt;key&gt;&#x3D;&lt;value&gt;&#x60;, &#x60;label!&#x3D;&lt;key&gt;&#x60;, or &#x60;label!&#x3D;&lt;key&gt;&#x3D;&lt;value&gt;&#x60;) Prune images with (or without, in case &#x60;label!&#x3D;...&#x60; is used) the specified labels.  (optional)
     - returns: ImagePruneResponse
     */
    @discardableResult
    public func pruneImages(filters: String? = nil) async throws -> ImagePruneResponseItem {
        try await ImageAPI.imagePrune(host: host, context: [name], filters: filters, session: session).dockerContext(name)
    }
    
    /**
     Build an image
     - POST /build
     - Build an image from a tar archive with a `Dockerfile` in it.  The `Dockerfile` specifies how the image is built from the tar archive. It is typically in the archive's root, but can be at a different path or have a different name by specifying the `dockerfile` parameter. [See the `Dockerfile` reference for more information](/engine/reference/builder/).  The Docker daemon performs a preliminary validation of the `Dockerfile` before starting the build, and returns an error if the syntax is incorrect. After that, each instruction is run one-by-one until the ID of the new image is output.  The build is canceled if the client drops the connection by quitting or being killed.
     - parameter dockerfile: (query) Path within the build context to the &#x60;Dockerfile&#x60;. This is ignored if &#x60;remote&#x60; is specified and points to an external &#x60;Dockerfile&#x60;. (optional, default to "Dockerfile")
     - parameter tags: (query) A name and optional tag to apply to the image in the &#x60;name:tag&#x60; format. If you omit the tag the default &#x60;latest&#x60; value is assumed. You can provide several &#x60;t&#x60; parameters. (optional)
     - parameter extrahosts: (query) Extra hosts to add to /etc/hosts (optional)
     - parameter remote: (query) A Git repository URI or HTTP/HTTPS context URI. If the URI points to a single text file, the file’s contents are placed into a file called &#x60;Dockerfile&#x60; and the image is built from that file. If the URI points to a tarball, the file is downloaded by the daemon and the contents therein used as the context for the build. If the URI points to a tarball and the &#x60;dockerfile&#x60; parameter is also specified, there must be a file with the corresponding path inside the tarball. (optional)
     - parameter quiet: (query) Suppress verbose build output. (optional, default to false)
     - parameter nocache: (query) Do not use the cache when building the image. (optional, default to false)
     - parameter cachefrom: (query) JSON array of images used for build cache resolution. (optional)
     - parameter pull: (query) Attempt to pull the image even if an older image exists locally. (optional)
     - parameter remove: (query) Remove intermediate containers after a successful build. (optional, default to true)
     - parameter forceremove: (query) Always remove intermediate containers, even upon failure. (optional, default to false)
     - parameter memory: (query) Set memory limit for build. (optional)
     - parameter memswap: (query) Total memory (memory + swap). Set as &#x60;-1&#x60; to disable swap. (optional)
     - parameter cpushares: (query) CPU shares (relative weight). (optional)
     - parameter cpusetcpus: (query) CPUs in which to allow execution (e.g., &#x60;0-3&#x60;, &#x60;0,1&#x60;). (optional)
     - parameter cpuperiod: (query) The length of a CPU period in microseconds. (optional)
     - parameter cpuquota: (query) Microseconds of CPU time that the container can get in a CPU period. (optional)
     - parameter buildargs: (query) JSON map of string pairs for build-time variables. Users pass these values at build-time. Docker uses the buildargs as the environment context for commands run via the &#x60;Dockerfile&#x60; RUN instruction, or for variable expansion in other &#x60;Dockerfile&#x60; instructions. This is not meant for passing secret values.  For example, the build arg &#x60;FOO&#x3D;bar&#x60; would become &#x60;{\&quot;FOO\&quot;:\&quot;bar\&quot;}&#x60; in JSON. This would result in the query parameter &#x60;buildargs&#x3D;{\&quot;FOO\&quot;:\&quot;bar\&quot;}&#x60;. Note that &#x60;{\&quot;FOO\&quot;:\&quot;bar\&quot;}&#x60; should be URI component encoded.  [Read more about the buildargs instruction.](/engine/reference/builder/#arg)  (optional)
     - parameter shmsize: (query) Size of &#x60;/dev/shm&#x60; in bytes. The size must be greater than 0. If omitted the system uses 64MB. (optional)
     - parameter squash: (query) Squash the resulting images layers into a single layer. *(Experimental release only.)* (optional)
     - parameter labels: (query) Arbitrary key/value labels to set on the image, as a JSON map of string pairs. (optional)
     - parameter networkmode: (query) Sets the networking mode for the run commands during build. Supported standard values are: &#x60;bridge&#x60;, &#x60;host&#x60;, &#x60;none&#x60;, and &#x60;container:&lt;name|id&gt;&#x60;. Any other value is taken as a custom network&#39;s name or ID to which this container should connect to.  (optional)
     - parameter contentType: (header)  (optional, default to .applicationXTar)
     - parameter xRegistryConfig: (header) This is a base64-encoded JSON object with auth configurations for multiple registries that a build may refer to.  The key is a registry URL, and the value is an auth configuration object, [as described in the authentication section](#section/Authentication). For example:  &#x60;&#x60;&#x60; {   \&quot;docker.example.com\&quot;: {     \&quot;username\&quot;: \&quot;janedoe\&quot;,     \&quot;password\&quot;: \&quot;hunter2\&quot;   },   \&quot;https://index.docker.io/v1/\&quot;: {     \&quot;username\&quot;: \&quot;mobydock\&quot;,     \&quot;password\&quot;: \&quot;conta1n3rize14\&quot;   } } &#x60;&#x60;&#x60;  Only the registry domain name (and port if not the default 443) are required. However, for legacy reasons, the Docker Hub registry must be specified with both a &#x60;https://&#x60; prefix and a &#x60;/v1/&#x60; suffix even though Docker will prefer to use the v2 registry API.  (optional)
     - parameter platform: (query) Platform in the format os[/arch[/variant]] (optional)
     - parameter target: (query) Target build stage (optional)
     - parameter outputs: (query) BuildKit output configuration (optional)
     - parameter inputStream: (body) A tar archive compressed with one of the following algorithms: identity (no compression), gzip, bzip2, xz. (optional)
     
     */
    public func build(dockerfile: String? = nil, tags: [String]? = nil, extraHosts: [String]? = nil, remote: String? = nil, quiet: Bool = false, noCache: Bool = false, cacheFrom: [String]? = nil, pull: Bool? = nil, remove: Bool = true, forceRemove: Bool = false, memory: Int64? = nil, memSwap: Int64? = nil, cpuShares: Int64? = nil, cpuSetCPUs: String? = nil, cpuPeriod: Int64? = nil, cpuQuota: Int64? = nil, buildArgs: String? = nil, shmSize: Int64? = nil, squash: Bool? = nil, labels: String? = nil, networkMode: String? = nil, contentType: ImageAPI.ContentType_imageBuild = .applicationXTar, xRegistryConfig: String? = nil, platform: String? = nil, target: String? = nil, outputs: String? = nil, inputStream: Data? = nil) async throws -> APIStreamResponse<ProgressResponse> {
        try await ImageAPI.imageBuild(host: host, context: name, dockerfile: dockerfile, tags: tags, extrahosts: extraHosts, remote: remote, quiet: quiet, nocache: noCache, cachefrom: cacheFrom, pull: pull, remove: remove, forceremove: forceRemove, memory: memory, memswap: memSwap, cpushares: cpuShares, cpusetcpus: cpuSetCPUs, cpuperiod: cpuPeriod, cpuquota: cpuQuota, buildargs: buildArgs, shmsize: shmSize, squash: squash, labels: labels, networkmode: networkMode, contentType: contentType, xRegistryConfig: xRegistryConfig, platform: platform, target: target, outputs: outputs, inputStream: inputStream, session: session)
    }
    
    /**
     Create a new image from a container
     - POST /commit
     - parameter container: (query) The ID or name of the container to commit (optional)
     - parameter repo: (query) Repository name for the created image (optional)
     - parameter tag: (query) Tag name for the create image (optional)
     - parameter comment: (query) Commit message (optional)
     - parameter author: (query) Author of the image (e.g., &#x60;John Hannibal Smith &lt;hannibal@a-team.com&gt;&#x60;) (optional)
     - parameter pause: (query) Whether to pause the container before committing (optional, default to true)
     - parameter changes: (query) &#x60;Dockerfile&#x60; instructions to apply while committing (optional)
     - parameter containerConfig: (body) The container configuration (optional)
     - returns: IdResponse
     */
    public func imageCommit(container: Container, repo: String? = nil, tag: String? = nil, comment: String? = nil, author: String? = nil, pause: Bool = true, changes: [String]? = nil, containerConfig: ContainerConfig? = nil) async throws -> IdResponse {
        try await ImageAPI.imageCommit(host: host, context: self.name, container: container.id, repo: repo, tag: tag, comment: comment, author: author, pause: pause, changes: changes, containerConfig: containerConfig, session: session)
    }
    
    /**
     Create an image
     - POST /images/create
     - Create an image by either pulling it from a registry or importing it.
     - parameter fromSrc: (query) Source to import. The value may be a URL from which the image can be retrieved or &#x60;-&#x60; to read the image from the request body. This parameter may only be used when importing an image. (optional)
     - parameter repo: (query) Repository name given to an image when it is imported. The repo may include a tag. This parameter may only be used when importing an image. (optional)
     - parameter tag: (query) Tag or digest. If empty when pulling an image, this causes all tags for the given image to be pulled. (optional)
     - parameter message: (query) Set commit message for imported image. (optional)
     - parameter xRegistryAuth: (header) A base64url-encoded auth configuration.  Refer to the [authentication section](#section/Authentication) for details.  (optional)
     - parameter platform: (query) Platform in the format os[/arch[/variant]] (optional)
     - parameter quiet: (query) Show logs when pulling. (optional, default to true)
     - parameter inputImage: (body) Image content if the value &#x60;-&#x60; has been specified in fromSrc query parameter (optional)
     
     */
    public func pullImage(fromSrc src: URL, repo: String? = nil, tag: String? = nil, message: String? = nil, xRegistryAuth: String? = nil, platform: String? = nil, quiet: Bool? = nil, inputImage: String? = nil) async throws -> APIStreamResponse<ProgressResponse> {
        try await ImageAPI.imageCreate(host: host, context: name, fromImage: nil, fromSrc: src.absoluteString, repo: repo, tag: tag, message: message, xRegistryAuth: xRegistryAuth, platform: platform, quiet: quiet, inputImage: inputImage, session: session)
    }
    
    /**
     Import images
     - POST /images/load
     - Load a set of images and tags into a repository.  For details on the format, see the [export image endpoint](#operation/ImageGet).
     - parameter quiet: (query) Suppress progress details during load. (optional, default to false)
     - parameter imagesTarball: (body) Tar archive containing images (optional)
     
     */
    public func loadImage(quiet: Bool = false, imagesTarball: Data? = nil) async throws -> APIStreamResponse<ProgressResponse> {
        try await ImageAPI.imageLoad(host: host, context: name, quiet: quiet, imagesTarball: imagesTarball, session: session)
    }
}

extension GoPortImage {
    
    /**
     Create an image
     - POST /images/create
     - Create an image by either pulling it from a registry or importing it.
     - parameter repo: (query) Repository name given to an image when it is imported. The repo may include a tag. This parameter may only be used when importing an image. (optional)
     - parameter tag: (query) Tag or digest. If empty when pulling an image, this causes all tags for the given image to be pulled. (optional)
     - parameter message: (query) Set commit message for imported image. (optional)
     - parameter xRegistryAuth: (header) A base64url-encoded auth configuration.  Refer to the [authentication section](#section/Authentication) for details.  (optional)
     - parameter platform: (query) Platform in the format os[/arch[/variant]] (optional)
     - parameter quiet: (query) Show logs when pulling. (optional, default to true)
     - parameter inputImage: (body) Image content if the value &#x60;-&#x60; has been specified in fromSrc query parameter (optional)
     
     */
    public func create(repo: String? = nil, tag: String? = nil, message: String? = nil, xRegistryAuth: String? = nil, platform: String? = nil, quiet: Bool = true, inputImage: String? = nil) async throws -> APIStreamResponse<ProgressResponse> {
        try await ImageAPI.imageCreate(host: context.host, context: context.name, fromImage: id, fromSrc: nil, repo: repo, tag: tag, message: message, xRegistryAuth: xRegistryAuth, platform: platform, quiet: quiet, inputImage: inputImage, session: context.session)
    }
    
    /**
     Remove an image
     - DELETE /images/{name}
     - Remove an image, along with any untagged parent images that were referenced by that image.  Images can't be removed if they have descendant images, are being used by a running container or are being used by a build.
     - parameter force: (query) Remove the image even if it is being used by stopped containers or has other tags (optional, default to false)
     - parameter noprune: (query) Do not delete untagged parent images (optional, default to false)
     - returns: [ImageDeleteResponseItem]
     */
    public func delete(force: Bool? = nil, noPrune: Bool? = nil) async throws -> ImageDeleteResponse {
        try await ImageAPI.imageDelete(host: context.host, name: id, context: context.name, force: force, noprune: noPrune, session: context.session)
    }
    
    /**
     Get the history of an image
     - GET /images/{name}/history
     - Return parent layers of an image.
     - returns: [HistoryResponseItem]
     */
    public func history() async throws -> HistoryResponse {
        try await ImageAPI.imageHistory(host: context.host, name: id, context: context.name, session: context.session)
    }
    
    /**
     Inspect an image
     - GET /images/{name}/json
     - Return low-level information about an image.
     - returns: Image
     */
    public func inspect() async throws -> ImageResponse {
        try await ImageAPI.imageInspect(host: context.host, name: id, context: context.name, session: context.session)
    }
    
    /**
     Push an image
     - POST /images/{name}/push
     - Push an image to a registry.  If you wish to push an image on to a private registry, that image must already have a tag which references the registry. For example, `registry.example.com/myimage:latest`.  The push is cancelled if the HTTP connection is closed.
     - parameter xRegistryAuth: (header) A base64url-encoded auth configuration.  Refer to the [authentication section](#section/Authentication) for details.
     - parameter tag: (query) The tag to associate with the image on the registry. (optional)
     
     */
    public func push(xRegistryAuth: String, tag: String? = nil) async throws -> APIStreamResponse<ProgressResponse> {
        try await ImageAPI.imagePush(host: context.host, name: id, xRegistryAuth: xRegistryAuth, context: context.name, tag: tag, session: context.session)
    }
    
    /**
     Tag an image
     - POST /images/{name}/tag
     - Tag an image so that it becomes part of a repository.
     - parameter repo: (query) The repository to tag in. For example, &#x60;someuser/someimage&#x60;. (optional)
     - parameter tag: (query) The name of the new tag. (optional)
     
     */
    public func tag(repo: String? = nil, tag: String? = nil) async throws {
        try await ImageAPI.imageTag(host: context.host, name: id, context: context.name, repo: repo, tag: tag, session: context.session)
    }
}
