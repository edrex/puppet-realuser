# currently inflexible define to create an SSH user with key

define realuser($uid, $groups=[], $comment, $key, $keytype="ssh-rsa") {
    group { $name :
        gid     => $uid,
    }

    user { $name :
        uid     => $uid,
        gid     => $uid,
        groups  => $groups,
        shell   => "/bin/bash",
        comment => $comment,
        home    => "/home/$name",
        managehome => true,
        require => Group[$name],
    }
    
    ssh_authorized_key { $name :
        user    => $name,
        key     => $key,
        type    => $keytype,
    }

    # require password change on first login
    # WARNING: will unlock locked accounts, TODO fix that
    exec { "usermod -p '' $name; chage -d 0 $name":
        onlyif  => "test `passwd -S $name|cut -d ' ' -f 2` == L",
        require => User[$name],
    }
}
        
