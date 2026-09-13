package pt.up.fe.ni.uni

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform