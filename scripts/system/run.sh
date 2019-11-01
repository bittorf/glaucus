#!/usr/bin/dash -ex

# Copyright (c) 2019, Firas Khalil Khana
# Distributed under the terms of the ISC License

. /home/glaucus/scripts/system/variables
. $SSCR/prepare
. $SSCR/log

(. $SSCR/envenomate | tee $SLOG/$log/out.log) 3>&1 1>&2 2>&3 | tee \
  $SLOG/$log/err.log

. $SSCR/configure
. $SSCR/img $GLAD/glaucus.img 256M
