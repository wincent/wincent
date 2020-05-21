Fixes an issue [I was complaining about on Twitter](https://twitter.com/wincent/status/1263422686174351363) — in short, an annoying multi-second beachball on opening files using the macOS "open file" sheet" — using [this 2013 tip](https://osxdaily.com/2013/11/24/slow-open-save-dialog-problem-mac-os-x/).

For more details, see `man auto_master`:

```
DESCRIPTION
     The auto_master file contains a list of the directories that are to be automounted.  Associ-
     ated with each directory is the name of a map that lists the locations of the filesystems to
     be automounted there.  The default map looks like this:

           #
           # Automounter master map
           #
           +auto_master            # Use directory service
           /net                    -hosts          -nobrowse,hidefromfinder,nosuid
           /home                   auto_home       -nobrowse,hidefromfinder
           /Network/Servers        -fstab
           /-                      -static

     A ``#'' is the comment character. All characters from it to the end of line are ignored.  A
     line beginning with ``+'' and followed by a name, indicates the name of a file or map accessi-
     ble from a Directory Service source such as NIS or LDAP; the master map entries in that file
     or map are included at this point in the master map.  A line that specifies a map to be
     mounted has the format:

           mountpoint map -options

Special Maps
     The special maps have reserved names and are built into the automounter.

     -hosts        This map would normally be mounted on /net.  The key is the host name of an NFS
                   server; the contents of the map are generated from the list of file systems
                   exported by that server.
```

and `man automount`:

```
DESCRIPTION
     automount reads the /etc/auto_master file, and any local or network maps it includes, and
     mounts autofs on the appropriate mount points to cause mounts to be triggered.  It will also
     attempt to unmount any top-level autofs mounts that correspond to maps no longer found.

OPTIONS
     -v      Print more detailed information about actions taken by automount.

     -c      Tell automountd(8) to flush any cached information it has.
```
