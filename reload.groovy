import jenkins.model.*
import hudson.security.*
import org.jenkinsci.plugins.*

def instance = Jenkins.getInstance()
def scmSyncPlugin = instance.getPlugin('scm-sync-configuration')
scmSyncPlugin.reloadAllFilesFromScm()
instance.save()