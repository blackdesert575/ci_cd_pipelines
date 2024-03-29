#!/bin/bash
awk '{gsub(/old-string/, "new-string"); print}' *.yaml > temp && mv temp *.yaml