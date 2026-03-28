#!/usr/bin/env bash
set -euo pipefail
# IFS=$'\n\t'

# use case examples: https://www.tecmint.com/tr-command-examples-in-linux/

# $ cat linux.txt

# linux is my life
# linux has changed my life
# linux is best and everthing to me..:)

# $ cat linux.txt | tr [:lower:] [:upper:]

# LINUX IS MY LIFE
# LINUX HAS CHANGED MY LIFE
# LINUX IS BEST AND EVERTHING TO ME..:)

# $ cat linux.txt | tr [a-z] [A-Z]

# LINUX IS MY LIFE
# LINUX HAS CHANGED MY LIFE
# LINUX IS BEST AND EVERTHING TO ME..:)

# $ cat linux.txt | tr [a-z] [A-Z] >output.txt
# $ cat output.txt 

# LINUX IS MY LIFE
# LINUX HAS CHANGED MY LIFE
# LINUX IS BEST AND EVERTHING TO ME..:)

# $ cat domains.txt

# www. tecmint. com
# www. fossmint. com
# www. linuxsay. com

# $ cat domains.txt | tr -d '' 

# www.tecmint.com
# www.fossmint.com
# www.linuxsay.com