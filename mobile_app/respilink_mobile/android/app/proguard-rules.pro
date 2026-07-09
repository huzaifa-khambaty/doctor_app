# slf4j is an optional logging binder pulled in transitively (e.g. by OkHttp/WebSocket
# dependencies). No binder implementation is shipped, and none is needed at runtime.
-dontwarn org.slf4j.**
-dontwarn org.slf4j.impl.**
