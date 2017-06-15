FROM docker-registry.usersys.redhat.com/bayesian/cucos-worker

RUN pip3 install --upgrade awscli &&\
    mkdir -p /tmp/cvedb/ &&\
    ${OWASP_DEP_CHECK_PATH}/bin/dependency-check.sh --updateonly --data /tmp/cvedb/ &&\
    cd /tmp/cvedb/ &&\
    zip dc.h2.db.zip dc.h2.db &&\
    rm dc.h2.db

# --branch develop can be removed once
# https://github.com/snyk/vulnerabilitydb/issues/14
# is fixed
RUN cd /tmp/ && \
    git clone --depth 1 --branch develop https://github.com/snyk/vulndb && \
    cd vulndb && \
    npm install && \
    cli/shrink.js data vulndb.json && \
    cp vulndb.json /tmp/cvedb/ && \
    rm -rf /tmp/vulndb/

COPY cvedb-s3-dump.sh /usr/local/bin/cvedb-s3-dump.sh

CMD ["/usr/local/bin/cvedb-s3-dump.sh"]
