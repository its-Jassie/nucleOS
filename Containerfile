FROM quay.io/fedora/fedora-coreos:stable

RUN rpm-ostree override \
        remove nfs-utils-coreos \
        --install nfs-utils

#install cockpit-{extensions}
RUN rpm-ostree install \
        cockpit-machines \
        cockpit-networkmanager \
        cockpit-ostree \
        cockpit-podman \
        cockpit-selinux \
        cockpit-sosreport \
        cockpit-storaged \
        cockpit-system

#start cockpit service
RUN echo 'PasswordAuthentication yes' | sudo tee /etc/ssh/sshd_config.d/02-enable-passwords.conf \
    podman container runlabel --name cockpit-ws RUN quay.io/cockpit/ws && \
    podman container runlabel INSTALL quay.io/cockpit/ws && \
    systemctl enable cockpit.service
