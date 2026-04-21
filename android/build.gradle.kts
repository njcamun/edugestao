allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// Correção robusta para o erro "Namespace not specified" em plugins antigos
subprojects {
    val patchNamespace: Project.() -> Unit = {
        if (hasProperty("android")) {
            val android = extensions.getByName("android")
            try {
                val getNamespace = android.javaClass.getMethod("getNamespace")
                val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                
                if (getNamespace.invoke(android) == null) {
                    val defaultNamespace = "com.edugestao.${name.replace("-", "_")}"
                    setNamespace.invoke(android, defaultNamespace)
                }
            } catch (e: Exception) {
                // Silencioso se o método não existir
            }
        }
    }

    // Se o projecto já foi avaliado, aplica agora. Caso contrário, aguarda o final da avaliação.
    if (state.executed) {
        patchNamespace()
    } else {
        afterEvaluate { patchNamespace() }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
