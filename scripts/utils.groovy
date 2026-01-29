// At the end of the file we must return 'this'

def sendNotification(color, message) {
    slackSend(
            color: "${color}",
            message: "${message}"
    )
}

def runLoadTest(scriptPath, reportName) {
    try {
        sh "k6 run ${scriptPath}"
    } catch (Exception e) {
        echo "⚠️ O k6 falhou (talvez um threshold?), mas vamos publicar o relatório na mesma.: ${e}"
    } finally {
        publishReport(
                path: '.',
                file: "GenresGetRampUpReport-${env.BUILD_NUMBER}.html",
                name: reportName
        )
    }
}

def publishReport(Map config = [:]) {
    // allow permanet link to last build
    archiveArtifacts artifacts: "**/*.html", allowEmptyArchive: false

    publishHTML(target: [
            alwaysLinkToLastBuild: true,
            keepAll: true,
            reportDir: config.path,
            reportFiles: config.file,
            reportName: config.name
    ])
}

return this