#!/bin/sh
set -e

cd web
dotnet IronSegFault.dll "$@"
