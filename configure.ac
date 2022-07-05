AC_PREREQ(2.52)

AC_INIT([Apertium Spanish-Catalan], [2.2.0], [apertium-stuff@lists.sourceforge.net], [apertium-spa-cat], [https://wiki.apertium.org/wiki/Apertium-spa-cat])
AM_INIT_AUTOMAKE

AC_PROG_AWK

PKG_CHECK_MODULES(APERTIUM, apertium >= 3.7.2)
PKG_CHECK_MODULES(LTTOOLBOX, lttoolbox >= 3.5.4)
PKG_CHECK_MODULES(CG3, cg3 >= 1.3.3)
PKG_CHECK_MODULES(APERTIUM_LEX_TOOLS, apertium-lex-tools >= 0.4.0)
PKG_CHECK_MODULES(APERTIUM_ANAPHORA, apertium-anaphora >= 1.1.0)

AC_PATH_PROGS(ZCAT, [gzcat zcat], [false])
AS_IF([test x$ZCAT = xfalse], [AC_MSG_ERROR([You don't have zcat nor gzcat installed])])

m4_ifdef([AP_CHECK_LING],[],[AC_MSG_ERROR([AP_CHECK_LING not defined, is apertium.m4 in ACLOCAL_PATH? See: https://wiki.apertium.org/wiki/Installation_troubleshooting])])

AP_CHECK_LING([1], [apertium-spa], [1.2.0])
AP_CHECK_LING([2], [apertium-cat], [2.8.0])

PKG_CHECK_MODULES(REGTEST, apertium-regtest >= 0.0.1, [],
                  [AC_MSG_WARN([Running tests requires apertium-regtest])])

AP_MKINCLUDE

AC_OUTPUT([Makefile])
