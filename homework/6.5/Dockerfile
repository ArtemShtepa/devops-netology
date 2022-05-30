FROM elasticsearch:7.17.4
COPY src/ /usr/share/elasticsearch/config/
RUN mkdir /var/log/elasticsearch && chown elasticsearch /var/log/elasticsearch &&\
    mkdir /var/lib/elasticsearch && chown elasticsearch /var/lib/elasticsearch &&\
    mkdir /var/lib/elasticsearch/data && chown elasticsearch /var/lib/elasticsearch/data &&\
    mkdir /usr/share/elasticsearch/snapshots && chown -R elasticsearch /usr/share/elasticsearch/snapshots &&\
    chmod -R o+rwx /usr/share/elasticsearch/snapshots
