RPMBUILDROOT=./rpm-build

build:
	scons statsite

clean:
	rm -rfv ./dist ./statsite ./rpm-build

test_runner:
	scons test_runner

test: test_runner
	./test_runner

integ: build test
	py.test integ/

sdist: clean
	mkdir -vp ./dist
	tar --exclude statsite.tar.gz -czvf ./dist/statsite.tar.gz .

rpms: sdist build
	mkdir -vp $(RPMBUILDROOT)
	cp -v dist/*.tar.gz $(RPMBUILDROOT)
	cp -v rpm/statsite.spec $(RPMBUILDROOT)
	rpmbuild --define "_topdir $(RPMBUILDROOT)" \
        --define "_builddir %{_topdir}" \
        --define "_rpmdir %{_topdir}" \
        --define "_srcrpmdir %{_topdir}" \
        --define "_specdir %{_topdir}" \
        --define '_rpmfilename %%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm' \
        --define "_sourcedir  %{_topdir}" \
        -ba $(RPMBUILDROOT)/statsite.spec

# There was no existing install target, so freebsd install target it is!
install: build
	cp statsite /usr/local/bin
	mkdir -p /usr/share/statsite
	cp -R sinks /usr/share/statsite
	cp config/freebsd/usr-local-etc/statsite.conf.sample /usr/local/etc
	cp config/freebsd/usr-local-etc/rc.d/statsite /usr/local/etc/rc.d

.PHONY: build test statsite_test
