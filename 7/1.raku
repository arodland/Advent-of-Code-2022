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

say [+] %aggsize.values.grep: * <= 100000;
