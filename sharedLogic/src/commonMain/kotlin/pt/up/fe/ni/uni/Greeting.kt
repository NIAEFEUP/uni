package pt.up.fe.ni.uni

class Greeting {
    private val platform = getPlatform()

    fun greet(): String = sayHello(platform.name)
}
