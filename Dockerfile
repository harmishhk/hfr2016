FROM httpd:alpine

COPY dist/ /usr/local/apache2/htdocs/dist/
COPY build/ /usr/local/apache2/htdocs/
COPY index.html /usr/local/apache2/htdocs/

RUN chmod -R a+rx /usr/local/apache2/htdocs

EXPOSE 80
