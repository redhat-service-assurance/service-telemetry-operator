FROM quay.io/openshift/origin-jenkins-agent-base:latest

COPY install-sdk.sh /install-sdk.sh
RUN /install-sdk.sh
RUN dnf install -y ansible && \
    ansible-galaxy collection install community.kubernetes && \
    python -m pip install openshift
