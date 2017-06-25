AC_PREREQ(2.52)

AC_INIT([Apertium Spanish-Catalan], [2.1.0], [xavi.ivars@gmail.com], [apertium-spa-cat], [http://wiki.apertium.org/wiki/Apertium-spa-cat])
AM_INIT_AUTOMAKE

AC_PROG_LN_S
AC_PROG_AWK

m4_define([required_apertium_version], [3.4.0])
PKG_CHECK_MODULES(APERTIUM, apertium >= required_apertium_version, [], [PKG_CHECK_MODULES(APERTIUM, apertium-3.2 >= required_apertium_version)])

AC_PATH_PROGS(ZCAT, [gzcat zcat], [false])
AS_IF([test x$ZCAT = xfalse], [AC_MSG_ERROR([You don't have zcat nor gzcat installed])])

m4_ifdef([AP_CHECK_LING],[],[AC_MSG_ERROR([AP_CHECK_LING not defined, is apertium.m4 in ACLOCAL_PATH? See: http://wiki.apertium.org/wiki/Installation_troubleshooting])])

AP_CHECK_LING([1], [apertium-spa])
AP_CHECK_LING([2], [apertium-cat])

AP_MKINCLUDE

AC_OUTPUT([Makefile])

