#!/bin/bash
set -e

psql -U dspace -d dspace -f /docker-entrypoint-initdb.d/imagineRio.sql
