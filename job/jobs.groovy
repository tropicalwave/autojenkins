pipelineJob('test') {
  definition {
    cpsScm {
      scm {
        git {
          remote {
            url('file:///tmp/localrepo')
          }
        }
      }
      scriptPath('Jenkinsfile')
    }
  }
  triggers {
      cron('@midnight')
  }
}
