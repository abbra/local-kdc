FROM registry.fedoraproject.org/fedora-toolbox:39
MAINTAINER [FreeIPA Developers freeipa-devel@lists.fedorahosted.org]
ENV container=docker LANG=en_US.utf8 LANGUAGE=en_US.utf8 LC_ALL=en_US.utf8

ADD dist /root
RUN echo 'deltarpm = false' >> /etc/dnf/dnf.conf \
    && dnf update -y dnf \
    && dnf update -y python3 \
    && (sed -i 's/%_install_langs \(.*\)/\0:fr/g' /etc/rpm/macros.image-language-conf ||:) \
    && dnf install -y systemd \
    && dnf install -y \
        firewalld \
        git \
        glibc-langpack-en \
        iptables \
        nss-tools \
        openssh-server \
        sudo \
        wget vim \
        krb5-server krb5-workstation sssd-krb5 sssd sssd-idp sssd-passkey sssd-tools \
        samba-client samba samba-winbind sssd-winbind-idmap \
    && dnf clean all \
    && sed -i 's/.*PermitRootLogin .*/#&/g' /etc/ssh/sshd_config \
    && echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config \
    && systemctl enable sshd \
    && for i in /usr/lib/systemd/system/*-domainname.service; \
    do sed -i 's#^ExecStart=/#ExecStart=-/#' $i ; done \
    && { systemctl mask systemd-resolved ||: ; } \
    && systemctl set-default multi-user.target

STOPSIGNAL RTMIN+3
VOLUME ["/freeipa", "/run", "/tmp"]
ENTRYPOINT [ "/usr/sbin/init" ]
