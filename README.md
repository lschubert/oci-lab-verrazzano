# oci-lab-verrazzano
Automation to set up OCNE in Oracle provided free lab environment (https://luna.oracle.com/lab/df827e4c-2ca2-4686-84e5-0cb8c8e1e0c5)

At the time this code was created the lab timeslot is limited to 4 hours. This automation code is inteded to execute the lab steps to save some time.

This automation is best executed within the Luna Lab environment using Visual Studio Code.

# Pre-Requisites on execution machine
- git client, ansible installed
    - verify with ```git version``` and ```ansible --version```

# Instructions to setup

1. Launch Lab

    1.1. Wait until the lab ressources are provisioned. Setting up the underlying OKE cluster as pre-requisite is part of the free lab provisioning process and takes approximately 5 minutes to finish after launch. Unlike other Luna Labs the Resources Tab on Luna Lab page does only show a checkmark once provisioning is finished (no resource details) 

2. Checkout this git repo in Luna Lab Visual Studio Code

    2.1 Open Visual Studio Code. Select Topmost left Icon ("Explorer") and press "Clone Repository" button.
    
    Provide github URL: https://github.com/lschubert/oci-lab-verrazzano.git
    
    Select "Open Folder" and choose the local path of cloned repo

3. Gather Registry information on local machine with podman installed

   3.1. Make sure podman is available and started on local machine 
   ```
    LSCHUBER@LSCHUBER-mac oci-lab-verrazzano % podman version
    Client:       Podman Engine
    Version:      4.1.1
    API Version:  4.1.1
    Go Version:   go1.18.3
    Built:        Tue Jun 14 22:12:46 2022
    OS/Arch:      darwin/arm64

    Server:       Podman Engine
    Version:      4.2.0
    API Version:  4.2.0
    Go Version:   go1.18.4
    Built:        Thu Aug 11 16:43:11 2022
    OS/Arch:      linux/arm64

    LSCHUBER@LSCHUBER-mac oci-lab-verrazzano % podman machine list
    NAME                     VM TYPE     CREATED      LAST UP            CPUS        MEMORY      DISK SIZE
    podman-machine-default*  qemu        3 weeks ago  Currently running  1           2.147GB     107.4GB
   ```

   3.2. Login to Oracle container-registry
   ```
   LSCHUBER@LSCHUBER-mac oci-lab-verrazzano % podman login container-registry.oracle.com -u <Oracle-Account-Name>
   Password: 
   Login Succeeded!
   ```

   3.3. Copy auth token
   ```
   LSCHUBER@LSCHUBER-mac oci-lab-verrazzano % cat ~/.config/containers/auth.json 
    {
            "auths": {
                    "container-registry.oracle.com": {
                            "auth": "XXXXXXXXXXXXXXXXXXXXXXX"
                    }
            }
    }%                                              
   ```

4. In Lab Environement Visual Studio Code

    3.1. Select "Terminal > New Terminal"

    3.2. In oci-lab-ocne-verrazzano folder execute ```./setup.sh```

    Provide MY_REGISTRY_USER (Oracle-Account-Name), MY_REGISTRY_PASS (Password) and REGISTRY_AUTH_TOKEN (from step 3.3. above) for registry container-registry.oracle.com

    The automation triggered by ```./setup.sh``` is expected to be idempotent. You can change variables in ```vars/main.yml``` or the automation code itself and re-run the ```./setup.sh``` to reconfigure the setup.

    Potential configuration options are:

    | Variable  | Comment |
    |------------|---------|
    | v8o_version | Verrazzano Operator Version (default: 1.2.1) | 
    | v8o_profile | Verrazzano deployment profile type {dev, prod, managed-cluster} (default: dev) <br> For details see [Verrazzano Custom Resource Definition](https://verrazzano.io/docs/reference/api/verrazzano/verrazzano/) | 

    3.3. Import bookmarks to Google Chrome

    In Google Chrome choose the "three vertcal dot menu" > "Bookmarks" > Import Bookmarks and Settings... > Choose file 

    Select under Desktop the file bookmarks.html and enable "Show bookmarks bar"

    Bookmarks are now imported in the Browsers Bookmarks bar.

# About this Luna Lab environment

1. An OKE Cluster will be provisioned with a node pool containing 3 worker nodes

## Versions

| Component  | Version |
|------------|---------|
| Kubernetes | 1.21.5  |

# Developer info

## Issue during bob's books deployment

[luna.user@lunabox oci-lab-verrazzano]$ kubectl get pods -n bobs-books
NAME                                                READY   STATUS    RESTARTS   AGE
bobbys-coherence-0                                  2/2     Running   0          54m
bobbys-front-end-introspector-js8xv                 0/1     Error     0          45m
bobbys-helidon-stock-application-74cc496b77-c5rcx   2/2     Running   0          54m
bobs-bookstore-introspector-64s4s                   0/1     Error     0          45m
mysql-7ffbc78ff9-scxhd                              2/2     Running   0          54m
robert-helidon-5bdc8b7d7-45vn9                      2/2     Running   0          54m
robert-helidon-5bdc8b7d7-hhfts                      2/2     Running   0          54m
roberts-coherence-0                                 2/2     Running   0          54m
roberts-coherence-1                                 2/2     Running   0          54m

[luna.user@lunabox oci-lab-verrazzano]$ kubectl logs bobs-bookstore-introspector-64s4s -n bobs-books
@[2022-08-30T12:05:28.451204376Z][utils.sh:712][FINE] Auxiliary Image: AUXILIARY_IMAGE_PATHS is '/auxiliary'.
@[2022-08-30T12:05:28.460551868Z][utils.sh:714][FINE] Auxiliary Image: AUXILIARY_IMAGE_PATH is '/auxiliary'.
@[2022-08-30T12:05:28.472653547Z][utils_base.sh:147][FINE] id = 'uid=1000(oracle) gid=0(root) groups=0(root)'
@[2022-08-30T12:05:28.491795846Z][utils.sh:742][FINE] Auxiliary Image: Contents of '/auxiliary/auxiliaryImageLogs/operator-aux-container1.out':
@[2022-08-30T12:05:28.%NZ][auxImage.sh:13][FINE] Auxiliary Image: About to execute command 'cp -R $AUXILIARY_IMAGE_PATH/* $AUXILIARY_IMAGE_TARGET_PATH' in container image='container-registry.oracle.com/verrazzano/example-bobs-books-order-manager:20211129200415-ae4e89e'.  AUXILIARY_IMAGE_PATH is '/auxiliary' and AUXILIARY_IMAGE_TARGET_PATH is '/tmpAuxiliaryImage'.
@[2022-08-30T12:05:28.%NZ][auxImage.sh:13][FINE] id = 'uid=1000(oracle) gid=1000(oracle) groups=1000(oracle)'
@[2022-08-30T12:05:28.%NZ][auxImage.sh:13][FINE] Directory trace for /auxiliary=/auxiliary (before)
  ls -ld /auxiliary/*:
    drwxr-xr-x    1 oracle   oracle          61 Nov 29  2021 /auxiliary/models
    drwxr-x---    6 oracle   oracle          92 Nov 29  2021 /auxiliary/weblogic-deploy
  ls -ld /auxiliary:
    drwxr-xr-x    1 oracle   oracle          20 Nov 29  2021 /auxiliary
  ls -ld /:
    dr-xr-xr-x    1 root     root           112 Aug 30 12:05 /
@[2022-08-30T12:05:28.%NZ][auxImage.sh:13][FINE] Auxiliary Image: About to execute AUXILIARY_IMAGE_COMMAND='cp -R $AUXILIARY_IMAGE_PATH/* $AUXILIARY_IMAGE_TARGET_PATH' .
@[2022-08-30T12:05:28.%NZ][auxImage.sh:13][FINE] Auxiliary Image: Command 'cp -R $AUXILIARY_IMAGE_PATH/* $AUXILIARY_IMAGE_TARGET_PATH' executed successfully. Output -> ''.
@[2022-08-30T12:05:28.502118893Z][utils.sh:744][FINE] Auxiliary Image: End of '/auxiliary/auxiliaryImageLogs/operator-aux-container1.out' contents
@[2022-08-30T12:05:28.524574579Z][modelInImage.sh:80][FINE] Creating WDT standard output directory: '/scratch/logs/bobs-orders-wls'
@[2022-08-30T12:05:28.545786304Z][utils_base.sh:147][FINE] id = 'uid=1000(oracle) gid=0(root) groups=0(root)'
@[2022-08-30T12:05:28.555100081Z][utils_base.sh:155][FINE] Directory trace for LOG_HOME=LOG_HOME (before)
  ls -ld LOG_HOME/*:
    ls: cannot access LOG_HOME/*: No such file or directory
  ls -ld LOG_HOME:
    ls: cannot access LOG_HOME: No such file or directory
  ls -ld .:
    drwxr-xr-x. 1 oracle root 4096 Aug  8 21:02 .
@[2022-08-30T12:05:29.132685010Z][introspectDomain.sh:115][FINE] Introspecting domain 'bobs-bookstore', log location: '/scratch/logs/bobs-orders-wls/introspector_script.out'
@[2022-08-30T12:05:29.144889886Z][utils_base.sh:147][FINE] id = 'uid=1000(oracle) gid=0(root) groups=0(root)'
@[2022-08-30T12:05:29.153963092Z][utils_base.sh:155][FINE] Directory trace for LOG_HOME=LOG_HOME (after)
  ls -ld LOG_HOME/*:
    ls: cannot access LOG_HOME/*: No such file or directory
  ls -ld LOG_HOME:
    ls: cannot access LOG_HOME: No such file or directory
  ls -ld .:
    drwxr-xr-x. 1 oracle root 4096 Aug  8 21:02 .
@[2022-08-30T12:05:29.175591207Z][utils.sh:76][FINE] Env vars before:
    DOMAIN_UID='bobs-bookstore'
    NAMESPACE='bobs-books'
    SERVER_NAME=''
    SERVICE_NAME=''
    ADMIN_NAME='AdminServer'
    AS_SERVICE_NAME=''
    ADMIN_PORT=''
    ADMIN_PORT_SECURE=''
    USER_MEM_ARGS='-Djava.security.egd=file:/dev/./urandom '
    JAVA_OPTIONS='-Dweblogic.StdoutDebugEnabled=false'
    FAIL_BOOT_ON_SITUATIONAL_CONFIG_ERROR=''
    STARTUP_MODE=''
    DOMAIN_HOME='/u01/oracle/user_projects/domains/bobs-bookstore'
    LOG_HOME='/scratch/logs/bobs-orders-wls'
    SERVER_OUT_IN_POD_LOG='true'
    DATA_HOME=''
    KEEP_DEFAULT_DATA_HOME=''
    EXPERIMENTAL_LINK_SERVER_DEFAULT_DATA_DIR=''
    JAVA_HOME='/u01/jdk'
    ORACLE_HOME='/u01/oracle'
    WL_HOME='/u01/oracle/wlserver'
    MW_HOME='/u01/oracle'
    NODEMGR_HOME='/u01/nodemanager'
    INTROSPECT_HOME='/u01/oracle/user_projects/domains/bobs-bookstore'
    PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/u01/jdk/bin:/u01/oracle/oracle_common/common/bin:/u01/oracle/wlserver/common/bin:/u01/oracle'
    TRACE_TIMING=''
    OPERATOR_ENVVAR_NAMES='JAVA_OPTIONS,USER_MEM_ARGS,WL_HOME,MW_HOME,DOMAIN_UID,DOMAIN_HOME,NODEMGR_HOME,LOG_HOME,SERVER_OUT_IN_POD_LOG,ACCESS_LOG_IN_LOG_HOME,NAMESPACE,INTROSPECT_HOME,CREDENTIALS_SECRET_NAME,OPSS_KEY_SECRET_NAME,OPSS_WALLETFILE_SECRET_NAME,RUNTIME_ENCRYPTION_SECRET_NAME,WDT_DOMAIN_TYPE,DOMAIN_SOURCE_TYPE,ISTIO_ENABLED,ADMIN_CHANNEL_PORT_FORWARDING_ENABLED,ISTIO_READINESS_PORT,ISTIO_POD_NAMESPACE,ISTIO_USE_LOCALHOST_BINDINGS'
@[2022-08-30T12:05:29.188199487Z][utils_base.sh:147][FINE] id = 'uid=1000(oracle) gid=0(root) groups=0(root)'
@[2022-08-30T12:05:29.197085790Z][utils_base.sh:155][FINE] Directory trace for DOMAIN_HOME=DOMAIN_HOME (before)
  ls -ld DOMAIN_HOME/*:
    ls: cannot access DOMAIN_HOME/*: No such file or directory
  ls -ld DOMAIN_HOME:
    ls: cannot access DOMAIN_HOME: No such file or directory
  ls -ld .:
    drwxr-xr-x. 1 oracle root 4096 Aug  8 21:02 .
@[2022-08-30T12:05:29.218101107Z][utils_base.sh:155][FINE] Directory trace for DATA_HOME=DATA_HOME (before)
  ls -ld DATA_HOME/*:
    ls: cannot access DATA_HOME/*: No such file or directory
  ls -ld DATA_HOME:
    ls: cannot access DATA_HOME: No such file or directory
  ls -ld .:
    drwxr-xr-x. 1 oracle root 4096 Aug  8 21:02 .
@[2022-08-30T12:05:29.242393275Z][utils_base.sh:208][FINE] WDT_MODEL_HOME='/auxiliary/models'
@[2022-08-30T12:05:29.251624059Z][utils_base.sh:208][FINE] WDT_INSTALL_HOME='/auxiliary/weblogic-deploy'
@[2022-08-30T12:05:29.260799042Z][introspectDomain.sh:167][FINE] Beginning Model In Image
/usr/bin/gzip
/usr/bin/tar
/usr/bin/unzip
@[2022-08-30T12:05:29.276964703Z][modelInImage.sh:317][FINE] Entering createWLDomain
@[2022-08-30T12:05:29.286038666Z][modelInImage.sh:426][FINE] Entering checkDirNotExistsOrEmpty
@[2022-08-30T12:05:29.297498597Z][modelInImage.sh:440][FINE] Exiting checkDirNotExistsOrEmpty
@[2022-08-30T12:05:29.307753433Z][modelInImage.sh:426][FINE] Entering checkDirNotExistsOrEmpty
@[2022-08-30T12:05:29.319411946Z][modelInImage.sh:440][FINE] Exiting checkDirNotExistsOrEmpty
@[2022-08-30T12:05:29.331735376Z][modelInImage.sh:446][FINE] Entering checkModelDirectoryExtensions
@[2022-08-30T12:05:29.349545928Z][modelInImage.sh:467][FINE] Exiting checkModelDirectoryExtensions
@[2022-08-30T12:05:29.359950518Z][modelInImage.sh:473][FINE] Entering checkWDTVersion
@[2022-08-30T12:05:29.385407597Z][modelInImage.sh:497][FINE] Exiting checkWDTVersion
@[2022-08-30T12:05:29.408329634Z][modelInImage.sh:365][FINE] current version 12.2.1.4.0
@[2022-08-30T12:05:29.418627470Z][modelInImage.sh:508][FINE] Entering getSecretsAndEnvMD5
@[2022-08-30T12:05:29.442226379Z][modelInImage.sh:536][FINE] Found secrets and env: md5=bacde0f851620d78b83a77018b0df03a
@[2022-08-30T12:05:29.452816820Z][modelInImage.sh:538][FINE] Exiting getSecretsAndEnvMD5
@[2022-08-30T12:05:29.464745453Z][modelInImage.sh:370][FINE] Checking changes in secrets and jdk path
@[2022-08-30T12:05:29.477084260Z][modelInImage.sh:395][FINE] Building WDT parameters and MD5s
@[2022-08-30T12:05:29.487640867Z][modelInImage.sh:180][FINE] Entering setupInventoryList
@[2022-08-30T12:05:29.575842115Z][modelInImage.sh:276][FINE] Exiting setupInventoryList
@[2022-08-30T12:05:29.585823716Z][modelInImage.sh:122][FINE] Entering checkExistInventory
@[2022-08-30T12:05:29.596117486Z][modelInImage.sh:124][FINE] Checking wdt artifacts in image
@[2022-08-30T12:05:29.606768353Z][modelInImage.sh:135][FINE] Checking wdt artifacts in config map
@[2022-08-30T12:05:29.616991387Z][modelInImage.sh:146][FINE] New inventory in cm: create domain
@[2022-08-30T12:05:29.627279773Z][modelInImage.sh:153][FINE] no md5 found: create domain
@[2022-08-30T12:05:29.637444922Z][modelInImage.sh:157][FINE] Exiting checkExistInventory
@[2022-08-30T12:05:29.647634308Z][modelInImage.sh:410][FINE] Need to create domain WLS
@[2022-08-30T12:05:29.657845580Z][modelInImage.sh:548][FINE] Entering createModelDomain
@[2022-08-30T12:05:29.667935412Z][modelInImage.sh:695][FINE] Entering createPrimordialDomain
@[2022-08-30T12:05:29.678328760Z][modelInImage.sh:790][FINE] No primordial domain or need to create again because of changes require domain recreation
@[2022-08-30T12:05:29.689370816Z][modelInImage.sh:871][FINE] Entering wdtCreatePrimordialDomain
@[2022-08-30T12:05:29.700001335Z][modelInImage.sh:895][FINE] About to call '/auxiliary/weblogic-deploy/bin/createDomain.sh  -oracle_home /u01/oracle -domain_home /u01/oracle/user_projects/domains/bobs-bookstore -model_file /auxiliary/models/bobs-bookstore-topology.yaml,/weblogic-operator/wdt-config-map/WebLogicPlugin.yaml,/weblogic-operator/wdt-config-map/datasource.yaml -archive_file /auxiliary/models/archive.zip  -domain_type WLS  '.
@[2022-08-30T12:05:52.153343832Z][modelInImage.sh:943][SEVERE] Model in Image: WDT Create Primordial Domain Failed, ret=2
JDK version is 1.8.0_341-b10
JAVA_HOME = /u01/jdk
WLST_EXT_CLASSPATH = /auxiliary/weblogic-deploy/lib/weblogic-deploy-core.jar
CLASSPATH = /auxiliary/weblogic-deploy/lib/weblogic-deploy-core.jar
WLST_PROPERTIES = -Dcom.oracle.cie.script.throwException=true -Djava.util.logging.config.class=oracle.weblogic.deploy.logging.WLSDeployCustomizeLoggingConfig 
/u01/oracle/oracle_common/common/bin/wlst.sh /auxiliary/weblogic-deploy/lib/python/create.py -oracle_home /u01/oracle -domain_home /u01/oracle/user_projects/domains/bobs-bookstore -model_file /auxiliary/models/bobs-bookstore-topology.yaml,/weblogic-operator/wdt-config-map/WebLogicPlugin.yaml,/weblogic-operator/wdt-config-map/datasource.yaml -archive_file /auxiliary/models/archive.zip -domain_type WLS

Initializing WebLogic Scripting Tool (WLST) ...

Jython scans all the jar files it can find at first startup. Depending on the system, this process may take a few minutes to complete, and WLST may not return a prompt right away.

Welcome to WebLogic Server Administration Scripting Shell

Type help() for help on available commands

####<Aug 30, 2022 12:05:51 PM> <INFO> <WebLogicDeployToolingVersion> <logVersionInfo> <WLSDPLY-01750> <The WebLogic Deploy Tooling createDomain version is 1.9.0:master.75ef19a:May 27, 2020 21:46 UTC>
####<Aug 30, 2022 12:05:52 PM> <SEVERE> <cla_helper> <load_model> <WLSDPLY-20004> <createDomain variable substitution failed: No value in variable file /weblogic-operator/config-overrides-secrets/mysql-credentials/username>

Issue Log for createDomain version 1.9.0 running WebLogic version 12.2.1.4.0 offline mode:

SEVERE Messages:

        1. WLSDPLY-20004: createDomain variable substitution failed: No value in variable file /weblogic-operator/config-overrides-secrets/mysql-credentials/username

Total:       WARNING :     0    SEVERE :     1

createDomain.sh failed (exit code = 2)

[luna.user@lunabox oci-lab-verrazzano]$ kubectl logs bobbys-front-end-introspector-js8xv -n bobs-books
@[2022-08-30T12:05:27.424583723Z][utils.sh:712][FINE] Auxiliary Image: AUXILIARY_IMAGE_PATHS is '/auxiliary'.
@[2022-08-30T12:05:27.437322473Z][utils.sh:714][FINE] Auxiliary Image: AUXILIARY_IMAGE_PATH is '/auxiliary'.
@[2022-08-30T12:05:27.448825182Z][utils_base.sh:147][FINE] id = 'uid=1000(oracle) gid=0(root) groups=0(root)'
@[2022-08-30T12:05:27.469542680Z][utils.sh:742][FINE] Auxiliary Image: Contents of '/auxiliary/auxiliaryImageLogs/operator-aux-container1.out':
@[2022-08-30T12:05:26.%NZ][auxImage.sh:13][FINE] Auxiliary Image: About to execute command 'cp -R $AUXILIARY_IMAGE_PATH/* $AUXILIARY_IMAGE_TARGET_PATH' in container image='container-registry.oracle.com/verrazzano/example-bobbys-front-end:1.0.0-1-20211208104359-15ca14d'.  AUXILIARY_IMAGE_PATH is '/auxiliary' and AUXILIARY_IMAGE_TARGET_PATH is '/tmpAuxiliaryImage'.
@[2022-08-30T12:05:26.%NZ][auxImage.sh:13][FINE] id = 'uid=1000(oracle) gid=1000(oracle) groups=1000(oracle)'
@[2022-08-30T12:05:26.%NZ][auxImage.sh:13][FINE] Directory trace for /auxiliary=/auxiliary (before)
  ls -ld /auxiliary/*:
    drwxr-xr-x    1 oracle   oracle          54 Dec  8  2021 /auxiliary/models
    drwxr-x---    6 oracle   oracle          92 Dec  8  2021 /auxiliary/weblogic-deploy
  ls -ld /auxiliary:
    drwxr-xr-x    1 oracle   oracle          20 Dec  8  2021 /auxiliary
  ls -ld /:
    dr-xr-xr-x    1 root     root           112 Aug 30 12:05 /
@[2022-08-30T12:05:26.%NZ][auxImage.sh:13][FINE] Auxiliary Image: About to execute AUXILIARY_IMAGE_COMMAND='cp -R $AUXILIARY_IMAGE_PATH/* $AUXILIARY_IMAGE_TARGET_PATH' .
@[2022-08-30T12:05:26.%NZ][auxImage.sh:13][FINE] Auxiliary Image: Command 'cp -R $AUXILIARY_IMAGE_PATH/* $AUXILIARY_IMAGE_TARGET_PATH' executed successfully. Output -> ''.
@[2022-08-30T12:05:27.480843652Z][utils.sh:744][FINE] Auxiliary Image: End of '/auxiliary/auxiliaryImageLogs/operator-aux-container1.out' contents
@[2022-08-30T12:05:27.507029756Z][modelInImage.sh:80][FINE] Creating WDT standard output directory: '/scratch/logs/bobbys-front-end'
@[2022-08-30T12:05:27.532118591Z][utils_base.sh:147][FINE] id = 'uid=1000(oracle) gid=0(root) groups=0(root)'
@[2022-08-30T12:05:27.543051735Z][utils_base.sh:155][FINE] Directory trace for LOG_HOME=LOG_HOME (before)
  ls -ld LOG_HOME/*:
    ls: cannot access LOG_HOME/*: No such file or directory
  ls -ld LOG_HOME:
    ls: cannot access LOG_HOME: No such file or directory
  ls -ld .:
    drwxr-xr-x. 1 oracle root 4096 Aug  8 21:02 .
@[2022-08-30T12:05:28.180138200Z][introspectDomain.sh:115][FINE] Introspecting domain 'bobbys-front-end', log location: '/scratch/logs/bobbys-front-end/introspector_script.out'
@[2022-08-30T12:05:28.191308528Z][utils_base.sh:147][FINE] id = 'uid=1000(oracle) gid=0(root) groups=0(root)'
@[2022-08-30T12:05:28.200174136Z][utils_base.sh:155][FINE] Directory trace for LOG_HOME=LOG_HOME (after)
  ls -ld LOG_HOME/*:
    ls: cannot access LOG_HOME/*: No such file or directory
  ls -ld LOG_HOME:
    ls: cannot access LOG_HOME: No such file or directory
  ls -ld .:
    drwxr-xr-x. 1 oracle root 4096 Aug  8 21:02 .
@[2022-08-30T12:05:28.221173707Z][utils.sh:76][FINE] Env vars before:
    DOMAIN_UID='bobbys-front-end'
    NAMESPACE='bobs-books'
    SERVER_NAME=''
    SERVICE_NAME=''
    ADMIN_NAME='AdminServer'
    AS_SERVICE_NAME=''
    ADMIN_PORT=''
    ADMIN_PORT_SECURE=''
    USER_MEM_ARGS='-Djava.security.egd=file:/dev/./urandom'
    JAVA_OPTIONS='-Dweblogic.StdoutDebugEnabled=false'
    FAIL_BOOT_ON_SITUATIONAL_CONFIG_ERROR=''
    STARTUP_MODE=''
    DOMAIN_HOME='/u01/oracle/user_projects/domains/bobbys-front-end'
    LOG_HOME='/scratch/logs/bobbys-front-end'
    SERVER_OUT_IN_POD_LOG='true'
    DATA_HOME=''
    KEEP_DEFAULT_DATA_HOME=''
    EXPERIMENTAL_LINK_SERVER_DEFAULT_DATA_DIR=''
    JAVA_HOME='/u01/jdk'
    ORACLE_HOME='/u01/oracle'
    WL_HOME='/u01/oracle/wlserver'
    MW_HOME='/u01/oracle'
    NODEMGR_HOME='/u01/nodemanager'
    INTROSPECT_HOME='/u01/oracle/user_projects/domains/bobbys-front-end'
    PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/u01/jdk/bin:/u01/oracle/oracle_common/common/bin:/u01/oracle/wlserver/common/bin:/u01/oracle'
    TRACE_TIMING=''
    OPERATOR_ENVVAR_NAMES='JAVA_OPTIONS,USER_MEM_ARGS,HELIDON_HOSTNAME,HELIDON_PORT,WL_HOME,MW_HOME,DOMAIN_UID,DOMAIN_HOME,NODEMGR_HOME,LOG_HOME,SERVER_OUT_IN_POD_LOG,ACCESS_LOG_IN_LOG_HOME,NAMESPACE,INTROSPECT_HOME,CREDENTIALS_SECRET_NAME,OPSS_KEY_SECRET_NAME,OPSS_WALLETFILE_SECRET_NAME,RUNTIME_ENCRYPTION_SECRET_NAME,WDT_DOMAIN_TYPE,DOMAIN_SOURCE_TYPE,ISTIO_ENABLED,ADMIN_CHANNEL_PORT_FORWARDING_ENABLED,ISTIO_READINESS_PORT,ISTIO_POD_NAMESPACE,ISTIO_USE_LOCALHOST_BINDINGS'
@[2022-08-30T12:05:28.235847480Z][utils_base.sh:147][FINE] id = 'uid=1000(oracle) gid=0(root) groups=0(root)'
@[2022-08-30T12:05:28.245508634Z][utils_base.sh:155][FINE] Directory trace for DOMAIN_HOME=DOMAIN_HOME (before)
  ls -ld DOMAIN_HOME/*:
    ls: cannot access DOMAIN_HOME/*: No such file or directory
  ls -ld DOMAIN_HOME:
    ls: cannot access DOMAIN_HOME: No such file or directory
  ls -ld .:
    drwxr-xr-x. 1 oracle root 4096 Aug  8 21:02 .
@[2022-08-30T12:05:28.273063357Z][utils_base.sh:155][FINE] Directory trace for DATA_HOME=DATA_HOME (before)
  ls -ld DATA_HOME/*:
    ls: cannot access DATA_HOME/*: No such file or directory
  ls -ld DATA_HOME:
    ls: cannot access DATA_HOME: No such file or directory
  ls -ld .:
    drwxr-xr-x. 1 oracle root 4096 Aug  8 21:02 .
@[2022-08-30T12:05:28.296859281Z][utils_base.sh:208][FINE] WDT_MODEL_HOME='/auxiliary/models'
@[2022-08-30T12:05:28.306984548Z][utils_base.sh:208][FINE] WDT_INSTALL_HOME='/auxiliary/weblogic-deploy'
@[2022-08-30T12:05:28.317892418Z][introspectDomain.sh:167][FINE] Beginning Model In Image
/usr/bin/gzip
/usr/bin/tar
/usr/bin/unzip
@[2022-08-30T12:05:28.334794158Z][modelInImage.sh:317][FINE] Entering createWLDomain
@[2022-08-30T12:05:28.348254232Z][modelInImage.sh:426][FINE] Entering checkDirNotExistsOrEmpty
@[2022-08-30T12:05:28.360686439Z][modelInImage.sh:440][FINE] Exiting checkDirNotExistsOrEmpty
@[2022-08-30T12:05:28.370798312Z][modelInImage.sh:426][FINE] Entering checkDirNotExistsOrEmpty
@[2022-08-30T12:05:28.383577853Z][modelInImage.sh:440][FINE] Exiting checkDirNotExistsOrEmpty
@[2022-08-30T12:05:28.393693091Z][modelInImage.sh:446][FINE] Entering checkModelDirectoryExtensions
@[2022-08-30T12:05:28.411416302Z][modelInImage.sh:467][FINE] Exiting checkModelDirectoryExtensions
@[2022-08-30T12:05:28.421642119Z][modelInImage.sh:473][FINE] Entering checkWDTVersion
@[2022-08-30T12:05:28.445955605Z][modelInImage.sh:497][FINE] Exiting checkWDTVersion
@[2022-08-30T12:05:28.470567299Z][modelInImage.sh:365][FINE] current version 12.2.1.4.0
@[2022-08-30T12:05:28.480169773Z][modelInImage.sh:508][FINE] Entering getSecretsAndEnvMD5
@[2022-08-30T12:05:28.500465287Z][modelInImage.sh:536][FINE] Found secrets and env: md5=369d141abab8c2b0d2f3fb5ace7c3301
@[2022-08-30T12:05:28.511559732Z][modelInImage.sh:538][FINE] Exiting getSecretsAndEnvMD5
@[2022-08-30T12:05:28.522769437Z][modelInImage.sh:370][FINE] Checking changes in secrets and jdk path
@[2022-08-30T12:05:28.534473068Z][modelInImage.sh:395][FINE] Building WDT parameters and MD5s
@[2022-08-30T12:05:28.544033667Z][modelInImage.sh:180][FINE] Entering setupInventoryList
@[2022-08-30T12:05:28.613858358Z][modelInImage.sh:276][FINE] Exiting setupInventoryList
@[2022-08-30T12:05:28.624505636Z][modelInImage.sh:122][FINE] Entering checkExistInventory
@[2022-08-30T12:05:28.634858790Z][modelInImage.sh:124][FINE] Checking wdt artifacts in image
@[2022-08-30T12:05:28.644869091Z][modelInImage.sh:135][FINE] Checking wdt artifacts in config map
@[2022-08-30T12:05:28.654764469Z][modelInImage.sh:146][FINE] New inventory in cm: create domain
@[2022-08-30T12:05:28.665640175Z][modelInImage.sh:153][FINE] no md5 found: create domain
@[2022-08-30T12:05:28.676329994Z][modelInImage.sh:157][FINE] Exiting checkExistInventory
@[2022-08-30T12:05:28.686493759Z][modelInImage.sh:410][FINE] Need to create domain WLS
@[2022-08-30T12:05:28.696794823Z][modelInImage.sh:548][FINE] Entering createModelDomain
@[2022-08-30T12:05:28.707069057Z][modelInImage.sh:695][FINE] Entering createPrimordialDomain
@[2022-08-30T12:05:28.717121001Z][modelInImage.sh:790][FINE] No primordial domain or need to create again because of changes require domain recreation
@[2022-08-30T12:05:28.727220285Z][modelInImage.sh:871][FINE] Entering wdtCreatePrimordialDomain
@[2022-08-30T12:05:28.738381075Z][modelInImage.sh:895][FINE] About to call '/auxiliary/weblogic-deploy/bin/createDomain.sh  -oracle_home /u01/oracle -domain_home /u01/oracle/user_projects/domains/bobbys-front-end -model_file /auxiliary/models/bobbys-front-end.yaml,/weblogic-operator/wdt-config-map/WebLogicPlugin.yaml -archive_file /auxiliary/models/archive.zip  -domain_type WLS  '.
@[2022-08-30T12:05:51.546370666Z][modelInImage.sh:943][SEVERE] Model in Image: WDT Create Primordial Domain Failed, ret=2
JDK version is 1.8.0_341-b10
JAVA_HOME = /u01/jdk
WLST_EXT_CLASSPATH = /auxiliary/weblogic-deploy/lib/weblogic-deploy-core.jar
CLASSPATH = /auxiliary/weblogic-deploy/lib/weblogic-deploy-core.jar
WLST_PROPERTIES = -Dcom.oracle.cie.script.throwException=true -Djava.util.logging.config.class=oracle.weblogic.deploy.logging.WLSDeployCustomizeLoggingConfig 
/u01/oracle/oracle_common/common/bin/wlst.sh /auxiliary/weblogic-deploy/lib/python/create.py -oracle_home /u01/oracle -domain_home /u01/oracle/user_projects/domains/bobbys-front-end -model_file /auxiliary/models/bobbys-front-end.yaml,/weblogic-operator/wdt-config-map/WebLogicPlugin.yaml -archive_file /auxiliary/models/archive.zip -domain_type WLS

Initializing WebLogic Scripting Tool (WLST) ...

Jython scans all the jar files it can find at first startup. Depending on the system, this process may take a few minutes to complete, and WLST may not return a prompt right away.

Welcome to WebLogic Server Administration Scripting Shell

Type help() for help on available commands

####<Aug 30, 2022 12:05:51 PM> <INFO> <WebLogicDeployToolingVersion> <logVersionInfo> <WLSDPLY-01750> <The WebLogic Deploy Tooling createDomain version is 1.9.0:master.75ef19a:May 27, 2020 21:46 UTC>
####<Aug 30, 2022 12:05:51 PM> <SEVERE> <cla_helper> <load_model> <WLSDPLY-20004> <createDomain variable substitution failed: No value in variable file /weblogic-operator/secrets/username>

Issue Log for createDomain version 1.9.0 running WebLogic version 12.2.1.4.0 offline mode:

SEVERE Messages:

        1. WLSDPLY-20004: createDomain variable substitution failed: No value in variable file /weblogic-operator/secrets/username

Total:       WARNING :     0    SEVERE :     1

createDomain.sh failed (exit code = 2)
[luna.user@lunabox oci-lab-verrazzano]$

