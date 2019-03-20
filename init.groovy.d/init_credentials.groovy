import jenkins.model.*
import hudson.security.*
import hudson.security.csrf.DefaultCrumbIssuer
import jenkins.security.s2m.AdminWhitelistRule
import com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey
import com.cloudbees.plugins.credentials.CredentialsScope
import com.cloudbees.plugins.credentials.SystemCredentialsProvider
import org.apache.commons.lang.RandomStringUtils

def instance = Jenkins.getInstance()

// Enable ACL mechanism (see https://wiki.jenkins.io/display/JENKINS/Slave+To+Master+Access+Control)
instance.getInjector().getInstance(AdminWhitelistRule.class).setMasterKillSwitch(false)

int randomStringLength = 32
String charset = (('a'..'z') + ('A'..'Z') + ('0'..'9')).join()
String pass = RandomStringUtils.random(randomStringLength, charset.toCharArray())
println("")
println("******************************************************************************")
println("Created the following administrator password: $pass")
println("******************************************************************************")
println("")
 
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("admin", pass)
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)

// Disable CLI over remoting
instance.getDescriptor("jenkins.CLI").get().setEnabled(false)

// Enable CSRF protection
instance.setCrumbIssuer(new DefaultCrumbIssuer(true))

// Insert SSH test key
def ssh_key_description = "Test SSH credentials"
def ssh_key_scope = CredentialsScope.GLOBAL
def ssh_key_id = "test-key"
def ssh_key_username = "jenkins"
def ssh_key_private_key_source = new BasicSSHUserPrivateKey.DirectEntryPrivateKeySource (new File("/ssh/test-key").text.trim())
def ssh_key_passphrase = null
    
def system_credentials_provider = SystemCredentialsProvider.getInstance()
def ssh_key_domain = com.cloudbees.plugins.credentials.domains.Domain.global()
def ssh_key_creds = new BasicSSHUserPrivateKey(ssh_key_scope,ssh_key_id,ssh_key_username,ssh_key_private_key_source,ssh_key_passphrase,ssh_key_description)
system_credentials_provider.addCredentials(ssh_key_domain,ssh_key_creds)
    
// Commit changes
instance.save()

// Set root URL
jlc = JenkinsLocationConfiguration.get()
jlc.setUrl("http://localhost:8080")
jlc.save()

