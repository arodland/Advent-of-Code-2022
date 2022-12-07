my @dstack;
my %aggsize;

for $*ARGFILES.IO.lines {
    when /'$ cd /'/ {
        @dstack = ();
    }
    when /'$ cd ..'/ {
        @dstack.pop;
    }
    when /'$ cd ' (.*)/ {
        @dstack.push: $0;
    }
    when /(\d+) (.*)/ {
        my ($size, $fn) = $/.list;
        for '/', |@dstack.produce(&[,])».join('/') -> $dir {
            %aggsize{$dir} += $size;
        }
    }
}

my $avail = 70000000 - %aggsize{'/'};
my $todelete = 30000000 - $avail;

say (%aggsize.values.grep: * >= $todelete).sort.[0];
