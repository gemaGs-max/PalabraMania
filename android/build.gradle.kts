import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
import org.gradle.api.tasks.compile.JavaCompile

// Si es build.gradle.kts (Kotlin DSL), este bloque va solo si usas dependencias antiguas.
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        //  Plugin de servicios de Google para Firebase
        classpath("com.google.gms:google-services:4.3.15")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

//  Cambia la ruta de build para evitar conflictos de estructura
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

//  Configura los subproyectos
subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)

    project.evaluationDependsOn(":app")

    tasks.withType<KotlinCompile>().configureEach {
        kotlinOptions {
            jvmTarget = "11"
        }
    }

    tasks.withType<JavaCompile>().configureEach {
        sourceCompatibility = "11"
        targetCompatibility = "11"
    }
}

//  Tarea para limpiar
tasks.register("clean", Delete::class) {
    delete(rootProject.layout.buildDirectory)
}





