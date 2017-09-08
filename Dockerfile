FROM registry.devshift.net/fabric8-analytics/f8a-worker-base

RUN pip3 install --upgrade awscli &&\
    mkdir -p /tmp/cvedb/ &&\
    ${OWASP_DEP_CHECK_PATH}/bin/dependency-check.sh --updateonly --data /tmp/cvedb/ &&\
    cd /tmp/cvedb/ &&\
    zip dc.h2.db.zip dc.h2.db &&\
    rm dc.h2.db

COPY cvedb-s3-dump.sh /usr/local/bin/cvedb-s3-dump.sh

CMD ["/usr/local/bin/cvedb-s3-dump.sh"]
