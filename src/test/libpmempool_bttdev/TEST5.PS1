# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2019-2020, Intel Corporation
#
#
# libpmempool_bttdev/TEST5 -- test for checking btt
#

. ..\unittest\unittest.ps1

require_test_type medium
# dax on windows doesn't support sparse files
require_fs_type non-pmem
#
# For a large pool, util_map consumes so much memory.
#
require_free_physical_memory 3G
#
# Automatic page file size management eliminate the risk
# of exceeding the available resources.
#
require_automatic_managed_pagefile

setup

$POOL="$DIR\file.pool"
$LOG="out${Env:UNITTEST_NUM}.log"
$LOG_TEMP="out${Env:UNITTEST_NUM}_part.log"
rm $LOG -Force -ea si
rm $LOG_TEMP -Force -ea si
touch $LOG_TEMP
$EXE="$Env:EXE_DIR\libpmempool_test$Env:EXESUFFIX"

truncate -s 1T $POOL
expect_normal_exit $BTTCREATE -s 1T -b 512M -t $POOL >> $LOG

expect_normal_exit $PMEMSPOIL $POOL "bttdevice.arena(0).btt_info.sig=ERROR" `
	"bttdevice.arena(0).btt_info_backup.sig=ERROR" `
	"bttdevice.arena(1).btt_info.sig=ERROR" `
	"bttdevice.arena(1).btt_info_backup.sig=ERROR"

expect_normal_exit $EXE -r 1 -t btt $POOL >> $LOG_TEMP

cat -Encoding Ascii $LOG | out-file -append -Encoding Ascii -literalpath $LOG_TEMP

mv -Force $LOG_TEMP $LOG

check_file $POOL

check

pass
