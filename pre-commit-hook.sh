#!/bin/sh
mkdir -p .git/hooks #it seems that are some cases where git will not create a hook directory if someone removed the hook templates
tee .git/hooks/pre-commit << EOF
#!/bin/sh

FILES="\$(git diff --diff-filter=d --name-only --cached | grep .*\.dart | grep -v .*\.g\.dart | grep -v .*\.mocks\.dart)"

[ -z "\$FILES" ] && exit 0


echo "\$FILES" | xargs dart format 
echo "\$FILES" | xargs git add 
EOF

chmod +x .git/hooks/pre-commit
