#!/bin/bash
docker ps --filter "label=type=x11server" --format '{{json .}}'
