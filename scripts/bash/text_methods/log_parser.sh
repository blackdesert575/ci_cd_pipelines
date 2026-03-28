#!/bin/bash

cat some_log_file | grep "key_words" | cut -d' ' -f1,3 | sed -E 's/old-string/new-string/g'