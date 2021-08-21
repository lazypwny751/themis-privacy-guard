define install
	mkdir -p /usr/local/lib/themis /usr/share/doc/themis/tpg /usr/share/licenses/themis/tpg
	install -m 755 tpg.sh /usr/local/lib/themis
	cp README.md /usr/share/doc/themis/tpg
	cp LICENSE /usr/share/licenses/themis/tpg
endef

define uninstall
	rm -rf /usr/local/lib/themis/tpg.sh /usr/share/doc/themis/tpg /usr/share/licenses/themis/tpg
endef

install:
	$(install)

uninstall:
	$(uninstall)

reinstall:
	$(uninstall)
	$(install)