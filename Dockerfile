FROM httpd:2.4
COPY ./public-html/ /usr/local/apache2/htdocs/
COPY ./my-httpd.conf /usr/local/apache2/conf/httpd.conf
COPY server.crt /usr/local/apache2/conf/server.crt
COPY ca.crt /usr/local/apache2/conf/ca.crt
COPY server.key /usr/local/apache2/conf/server.key

