# SmbToRoot
This tool exploits a command execution vulerability in Samba
versions 3.0.20 through 3.0.25rc3 when using the non-default
"username map script" configuration option. By specifying a username
containing shell meta characters, attackers can execute arbitrary
commands.


No authentication is needed to exploit this vulnerability since
this option is used to map usernames prior to authentication!

Only works with apt package management system.
