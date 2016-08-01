# JAX-RS & RESTEasy POJO from/to JSON with Security PoC

Proof of concept web service demonstrating POJO to/from JSON via RESTEasy and WildFly 10. 
It has been further enhanced to demonstrate role based security using SQL Server 2014 for the JDBC security realm.

## Requirements & Setup

### 1. Setup a SQL Server 2014 database for users

SQL Server Requirements:
- TCP/IP is enabled (This can be done in SQL Server Configuration Manager)
- `SQL Server and Windows Authentication mode` is selected as the `Server authentication` option

1. Create a new database with the name `jdbc_realm` 
2. Run the `create-tables.sql` script
3. Run the insert scripts
    - `insert-users.sql`
    - `insert-roles.sql`
    - `insert-userRoles.sql`
5. Run the `create-view-userRoles.sql` script to create the view used to check the user's roles
4. Run the `create-login.sql` script to create the login we will be using
5. Run the `create-user.sql` script to create the user **I'm unsure if this is actually used**

### 2. Setup WildFly

1. Deploy the SQL Server `sqljdbc42.jar` to your WildFly server via the management console or site

2. Add this as a child of the security-domains element

```xml
...

<security-domain name="jdbcWildflyDbRealm" cache-type="default">
    <authentication>
        <login-module code="Database" flag="required">
            <module-option name="dsJndiName" value="java:jboss/datasources/UserDb"/>
            <module-option name="principalsQuery" value="SELECT password FROM Users WHERE email=?"/>
            <module-option name="rolesQuery" value="SELECT name, 'Roles' FROM v_userRoles WHERE email=?"/>
            <module-option name="hashAlgorithm" value="SHA-256"/>
            <module-option name="hashEncoding" value="base64"/>
            <module-option name="unauthenticatedIdentity" value="guest"/>
        </login-module>
    </authentication>
</security-domain>

...
```

3. Add the datasource for this security domain. You need the datasource portion of this:

```xml
...

<subsystem xmlns="urn:jboss:domain:datasources:4.0">
    <datasources>
        <datasource jta="true" jndi-name="java:jboss/datasources/UserDb" pool-name="UserDb" enabled="true" use-ccm="true">
            <connection-url>jdbc:sqlserver://localhost:1433;DatabaseName=jdbc_realm;</connection-url>
            <driver-class>com.microsoft.sqlserver.jdbc.SQLServerDriver</driver-class>
            <driver>sqljdbc42.jar</driver>
            <transaction-isolation>TRANSACTION_READ_COMMITTED</transaction-isolation>
            <security>
                <user-name>jdbc_login</user-name>
                <password>jdbc</password>
            </security>
            <validation>
                <valid-connection-checker class-name="org.jboss.jca.adapters.jdbc.extensions.mssql.MSSQLValidConnectionChecker"/>
                <background-validation>true</background-validation>
            </validation>
        </datasource>
    </datasources>
</subsystem>

...
```

### 3. Setup KeyCloak in WildFly

#### Install KeyCloak
[Official Installation Guide](https://keycloak.github.io/docs/userguide/keycloak-server/html/server-installation.html)  

1. Download keycloak-overlay-1.9.4.Final
2. Copy the contents of keycloak-overlay-1.9.4.Final into the root WildFly directory
3. Navigate to WildFly's bin directory and run `jboss-cli.bat --file=keycloak-install.cli`

#### Install the WildFly Adapter
[Official Installation Guide](https://keycloak.github.io/docs/userguide/keycloak-server/html/ch08.html#jboss-adapter)  

1. Download and install keycloak-wildfly-adapter-dist-1.9.4.Final
2. Copy the contents of keycloak-wildfly-adapter-dist-1.9.4.Final into the root WildFly directory
3. Navigate to WildFly's bin directory and run `jboss-cli.bat -c --file=adapter-install-offline.cli`

#### Configure KeyCloak
1. Start WildFly and naviate to localhost:8080/auth/
2. Setup an admin account for KeyCloak
3. Add a Realm and import KeyCloak/demo.json

### 4. Install Oracle Enterprise Pack for Eclipse
- Download and install OEPE for the Eclipse Mars - [Download Link](http://www.oracle.com/technetwork/developer-tools/eclipse/downloads/index.html)
  - Latest and version used at time of creation: `12.2.1.2.1`

### 5. Install JBoss Tools
1. Open Eclipse
2. Help -> Eclipse Marketplace
3. Search for and Install `JBoss Tools`
 - Latest and version used at time of creation: `4.3.1.Final`

### 6. Setup JBoss Tools to be aware of WildFly
1. Open Eclipse
2. Window -> Preferneces
3. JBoss Tools -> JBoss Runtime Detection
 - Add a new Paths entry pointing to the folder containing WildFly 10

### 7. Install Maven
1. Download Maven - [Download Link](https://maven.apache.org/download.cgi)
 - Latest and version used at time of creation: `3.3.9`
2. Extract it
3. Add the Maven `bin` directory to your path
 - [Install Instructions](https://maven.apache.org/install.html)
4. Restart Eclipse if it is running

### 8. Import The Project
1. Open Eclipse
2. File -> Import
3. Maven -> Existing Maven Projects -> Next
4. Set the root to either Prototypes or photo-upload
5. Select the `pom.xml` for `ca.drewm.example:photo-upload:1.0.0:war`
6. Finish

### 9. Deploy The Project
- Right-click the project folder in Project Explorer -> Run As -> Run on server


## KeyCloak Demo
The `Make GET Request` and `Make POST Request` buttons make requests to secured resources which will result in a redirect to KeyCloak's login page.
Due to the way it is currently set up, this results in the login page being rendered ontop of the demo page. If your screen is tall enough, you will be
able to log in using this overlaid login page. If it isn't, navigate to `http://localhost:8080/auth/realms/demo/protocol/openid-connect/auth?response_type=code&client_id=pojo-rest` in a separate tab and log in. Then reload the demo page and make a request. 


## JDBC Demo
- The `Make GET Request` button makes a GET request to `/api/book/` which is secured to only allow users in the `admin` role to access it.  
- The `Make POST Request` button makes a POST request to `/api/book/` which is secured to only allow users in the `dataentry` role to access it.  
- The `Admin Login` button makes a POST request to `/api/login/` with credentials for an `admin` account. 
    - This API is unsecured and logs in the user with the provided credentials.  
- The `Data Entry Login` button makes a POST request to `/api/login/` with credentials for a `dataentry` account.  
