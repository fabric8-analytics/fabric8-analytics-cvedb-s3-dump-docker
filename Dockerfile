FROM registry.devshift.net/fabric8-analytics/f8a-worker-base

RUN pip3 install --upgrade awscli &&\
    mkdir -p /tmp/cvedb/ &&\
    ${OWASP_DEP_CHECK_PATH}/bin/dependency-check.sh --updateonly --data /tmp/cvedb/ &&\
    cd /tmp/cvedb/ &&\
    zip dc.h2.db.zip dc.h2.db &&\
    rm dc.h2.db

RUN git clone --depth 1 https://github.com/victims/victims-cve-db.git /tmp/victims-cve-db &&\
    cd /tmp/victims-cve-db/ &&\
    zip -r /tmp/victims-cve-db.zip . &&\
    rm -rf victims-cve-db/

COPY cvedb-s3-dump.sh /usr/local/bin/cvedb-s3-dump.sh

CMD ["/usr/local/bin/cvedb-s3-dump.sh"]
