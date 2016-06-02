FROM jhipster/jhipster

ENV JHIPSTER_TEST_BACK=1
ENV JHIPSTER_TEST_FRONT=1
ENV JHIPSTER_TEST_PACKAGING=1

COPY tester.sh /home/jhipster/tester.sh
COPY configstore /home/jhipster/.config/configstore

USER root
RUN chmod +x /home/jhipster/tester.sh && \
    chown -R jhipster:jhipster /home/jhipster

USER jhipster
VOLUME /tmp
CMD /home/jhipster/tester.sh
