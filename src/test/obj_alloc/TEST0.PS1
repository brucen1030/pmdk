# SPDX-License-Identifier: BSD-3-Clause
# Copyright 2019, Intel Corporation

#
# src/test/obj_alloc/TEST0 -- unit test for obj_alloc
#

. ..\unittest\unittest.ps1

require_test_type medium
require_fs_type any

setup

create_poolset $DIR\testset1 16M:$DIR\testfile1:x r 16M:$DIR\testfile2:x

# <path> <size> <type_num> <is_oid_null> <flags> <expected_return_code> <expected_errno>

expect_normal_exit $Env:EXE_DIR\obj_alloc$Env:EXESUFFIX `
   $DIR\testset1 O 0 1 1 0 0 `
   $DIR\testset1 1 S 0 0 0 0 `
   $DIR\testset1 1 0 0 0 0 0 `
   $DIR\testset1 1 0 0 1 0 0 `
   $DIR\testset1 O B 0 0 0 0 `
   $DIR\testset1 O B 0 1 0 0 `
   $DIR\testset1 O 0 0 1 0 0 `
   $DIR\testset1 O 1 0 1 0 0 `
   $DIR\testset1 O S 0 1 0 0 `
   $DIR\testset1 0 0 0 0 -1 22 `
   $DIR\testset1 0 0 0 1 -1 22 `
   $DIR\testset1 B 0 0 0 -1 12 `
   $DIR\testset1 B 0 0 1 -1 12

check

pass
