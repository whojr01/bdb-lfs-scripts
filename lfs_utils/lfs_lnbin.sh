#!/tools/bin/bash

#
# Create symlinks that will be replaced by the actual binary when it is built.
# But until then link /tools/bin/XXX to /usr/bin/XXX
#

ln -sv /tools/bin/{bash,cat,dd,echo,ln,pwd,rm,stty} /bin
ln -sv /tools/bin/{env,install,perl} /usr/bin
ln -sv /tools/lib/libgcc_s.so{,.1} /usr/lib
ln -sv /tools/lib/libstdc++.{a,so{,.6}} /usr/lib
ln -sv /tools/bin/libstdc++.a /usr/lib/libstdc++.a

for lib in blkid lzma mount uuid
do
	ln -sv /tools/lib/lib${lib}.so /usr/lib
	ln -sv /tools/lib/lib${lib}.a /usr/lib
# 	sed 's/tools/usr/' /tools/lib/lib${lib}.la > /usr/lib/lib${lib}.la
done

ln -svf /tools/include/blkid /usr/include
ln -svf /tools/include/libmount /usr/include
ln -svf /tools/include/uuid /usr/include

install -vdm755 /usr/lib/pkgconfig

for pc in blkid mount uuid
do
	/tools/bin/sed 's@tools@usr@g' /tools/lib/pkgconfig/${pc}.pc \
		> /usr/lib/pkgconfig/${pc}.pc
done

ln -sv bash /bin/sh

ln -sv /proc/self/mounts /etc/mtab
