pipeline {
    agent any

	tools {
		maven 'Maven3.6'
		jdk 'JDK1/8'
	}
//
//	environment {
//		M2_INSTALL = "/home/gamut/Distros/apache-maven-3.6.0/bin/mvn"
//	}

    
    stages {
		stage('Clone-Repo') {
			steps {
				
				git 'https://github.com/kd31967/testdemo1.git'
			}
		}
		
		stage('copy tomcat to workspace dir') {
	    	steps {
				sh 'cp /home/vagrant/apache-tomcat-7.0.104.tar.gz .'
			}
	    }
		
		stage('Build') {
	    	steps {
				sh 'mvn install -DskipTests'
			}
	    }
		
		stage('DockerImageCreate') {
	    	steps {
				sh 'sudo docker build -t abc-img .'
			}
	    }
		
		stage('Docker Container creation') {
	    	steps {
			    
				sh 'sh nginx-load-balancer.sh 4'
			}
	    }
		
		
		stage('Unit Tests') {
			steps {
				sh 'mvn surefire:test'
			}
		}
		stage('Deployment') {
	    	steps {
				print "Deployment is done!"
				sh 'sshpass -p "dev" scp target/petclinic.war dev@172.17.0.3:/home/dev/apache-tomcat-7.0.104/webapps/'
				sh 'sshpass -p "dev" ssh  dev@172.17.0.3 "JAVA_HOME=/usr/bin/java" "/home/dev/apache-tomcat-7.0.104/bin/startup.sh"'	


	    	}
		}
		stage('sonar analysis'){
			steps{
			
			withSonarQubeEnv(installationName: 'sonar',credentialsId: 'e6eb3b85-7f7c-457c-a27e-c7b8020255f1') {
            sh 'mvn sonar:sonar'
}
			
			}
		
		}
		
		
		
		stage('publish HTML REPORT'){
			steps{	
			sh 'mvn clean verify'
publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'target/site/jacoco/', reportFiles: 'index.html', reportName: 'ProjectReport', reportTitles: ''])			
			}
		
		}
		
		stage('publish JUNIT REPORTT'){
			steps{	
                   junit 'target/surefire-reports/*.xml'				
			}
		
		}
		
		
	
		
    }


}


