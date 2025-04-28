prefix    = $(DESTDIR)
package   = ucf
version   = $(shell dpkg-parsechangelog -Sversion)

all: build

build: man/ucfq.1
	sed -i "s#^pversion='.*'\$$#pversion='$(version)'#" ucf ucfr
	sed -i "s#VERSION[[:space:]]*=.*;\$$#VERSION = $(version);#" ucfq

man/ucfq.1: ucfq
	pod2man -r 'Debian' -c 'User Commands' ucfq $@

mancheck: man/ucf.1 man/ucfr.1 man/ucf.conf.5
	man --warnings -E UTF-8 -l -Tutf8 -Z $^ >/dev/null

check:
	sh -n  ucf
	sh -n  ucfr
	perl -wc ucfq
	podchecker ucfq
	sh -n  debian/ucf.preinst
	sh -n  debian/ucf.postinst
	sh -n  debian/ucf.postrm

	./t/run

shellcheck:
	# Ignored:
	#  SC3043 (warning): In POSIX sh, 'local' is undefined.
	#  SC2317 (info): Command appears to be unreachable. Check usage (or ignore if invoked indirectly).
	#  SC2004 (style): $$/$${} is unnecessary on arithmetic variables.

	shellcheck  --external-sources --exclude 3043,2317,2004 ucf ucfr

clean distclean:
	rm -f man/ucfq.1
