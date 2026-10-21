allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Custom build directory logic
val newBuildDir: Directory = rootProject.layout.buildDirectory
    .dir("../../build")
    .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    // 1. Set custom build directory
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // 2. FORCE SDK 36 and Namespace Fix
    afterEvaluate {
        if (project.hasProperty("android")) {
            val android = project.extensions.getByName("android") as com.android.build.gradle.BaseExtension

            // This forces every plugin to compile against API 36
            android.compileSdkVersion(36)

            // Namespace fix for tflite_v2 specifically
            if (project.name == "tflite_v2") {
                android.namespace = "sq.flutter.tflite"
            } else if (android.namespace == null) {
                android.namespace = "com.fix.${project.name.replace(":", ".")}"
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}