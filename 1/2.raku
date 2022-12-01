my $sum = 0;

my @sums;

for $*ARGFILES.lines -> $line {
    if $line eq '' {
        @sums.push: $sum;
        $sum = 0;
    } else {
        $sum += $line;
    }
}

@sums.push: $sum;
@sums = @sums.sort.reverse;

say [+] @sums[^3];
