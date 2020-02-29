#!/bin/bash

lua-format ./*.lua -i -c .luaformatrc && lua-format ./**/*.lua -i -c .luaformatrc
