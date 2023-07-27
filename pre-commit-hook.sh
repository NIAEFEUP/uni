#!/bin/sh

tee .git/hooks/pre-commit << EOF
#!/bin/sh

FILES="\$(git diff --name-only --cached | grep .*\.dart | grep -v .*\.g\.dart)"



echo "\$FILES" | xargs dart format 
echo "\$FILES" | xargs git add 
EOF

chmod +x .git/hooks/pre-commit