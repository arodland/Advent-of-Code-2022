my $max = 0;
my $sum = 0;

for $*ARGFILES.lines -> $line {
    if $line eq '' {
        if $sum > $max {
            $max = $sum;
        }
        $sum = 0;
    } else {
        $sum += $line;
    }
}

if $sum > $max {
    $max = $sum;
}

say $max;
