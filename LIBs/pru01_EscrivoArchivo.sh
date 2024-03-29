#!/bin/bash


# libs /bin/setupcon


cat >temp.log <<EOF
#!/bin/sh

$commands_fcat >/etc/console-setup/cached_setup_font.sh <<EOF

if ls /dev/fb* >/dev/null 2>/dev/null; then
    for i in /dev/vcs[0-9]*; do
        { :
            $commands_f
        } < /dev/tty\${i#/dev/vcs} > /dev/tty\${i#/dev/vcs}
    done
fi

mkdir -p /run/console-setup
> /run/console-setup/font-loaded
for i in /dev/vcs[0-9]*; do
    { :
$commands_t
    } < /dev/tty\${i#/dev/vcs} > /dev/tty\${i#/dev/vcs}
done
EOF