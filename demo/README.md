# Demo sessions for local KDC setup

## Using Kerberos to access SUDO

1. User is defined locally (in `/etc/passwd`) but its password is only defined in Kerberos KDC

2. User logs to the system over SSH. SSSD handles login and acquires initial Kerberos ticket.

3. User runs `sudo -l`. Since this user is a member of `wheel` group and in
   Fedora members of `wheel` group are allowed to run privileged operations via
   sudo, the user is prompted to authenticate.

4. This machine is configured with SSSD using `pam_sss_gss` PAM module via
   `authselect`'s `with-gssapi` feature of the SSSD profile. This means that a
   successful acquisition and verification of the Kerberos service ticket to the
   `host/machine-name` would be treated as a successful authentication of this
   user for PAM service access. As a result, `sudo` allows to run commands as root.

5. We can see Kerberos service ticket was obtained and stored in the
   credentials cache during the `sudo -l` process execution.

6. We can also see that Kerberos KDC is running on a lo interface locally
   (address 127.88.88.88).

![video](admin-sudo-gssapi.webm)
