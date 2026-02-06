FROM tomcat:9.0-alpine
COPY index.jsp /usr/local/tomcat/webapps/ROOT/
EXPOSE 80