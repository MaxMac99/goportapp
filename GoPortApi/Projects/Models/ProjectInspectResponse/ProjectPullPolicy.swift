import Foundation

public enum ProjectPullPolicy: String, Codable {
    case always = "always"
    case build = "build"
    case ifNotPresent = "if_not_present"
    case missing = "missing"
    case never = "never"
}
