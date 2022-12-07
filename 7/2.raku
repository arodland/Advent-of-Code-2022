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
my $need_delete = 30000000 - $avail;

my $to_delete = (%aggsize.pairs.grep: *.value >= $need_delete).sort({ $^a.value <=> $^b.value }).[0];
say "delete { $to_delete.key } to free up { $to_delete.value } bytes";
