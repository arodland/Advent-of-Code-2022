sub manhattan ($x1, $y1, $x2, $y2) {
    abs($x1 - $x2) + abs($y1 - $y2)
}

my @sensors;
my @beacons;

sub exclude(@ranges, $exclude) {
    gather {
        for @ranges -> $r {
            if $exclude.min <= $r.min && $exclude.max >= $r.max { # obliterated
            } elsif $exclude.min ~~ $r && $exclude.max ~~ $r { #split
                take $r.min .. $exclude.min - 1;
                take $exclude.max + 1 .. $r.max;
            } elsif $exclude.min ~~ $r {
                take $r.min .. $exclude.min - 1;
            } elsif $exclude.max ~~ $r {
                take $exclude.max + 1 .. $r.max;
            } else {
                take $r;
            }
        }
    }.grep: *.defined && *.elems;
}

sub MAIN(Str $file, Int $coordmax) {
    for $file.IO.lines {
        /'Sensor at x=' (<[\d-]>+) ', y=' (<[\d-]>+) ': closest beacon is at x=' (<[\d-]>+) ', y=' (<[\d-]>+)/;
        my ($sx, $sy, $bx, $by) = $/.list».Int;

        @beacons.push: %( x => $bx, y => $by );
        @sensors.push: %( x => $sx, y => $sy, dist => manhattan($sx, $sy, $bx, $by) );
    }

    @beacons = @beacons.unique(as => Str);
    say @sensors;

    ROW: for 0 .. $coordmax -> $row {
        if $row %% 1000 {
            say "row $row";
        }

        my @ranges = [$(0 .. $coordmax.Int)];

        for @sensors -> $s {
            my $dist = $s<dist> - abs($s<y> - $row);
            next unless $dist > 0;
            my $exclude = ($s<x>-$dist)..($s<x>+$dist);
            @ranges = exclude(@ranges, $exclude);
            next ROW unless @ranges.elems;
        }

        for @beacons.grep: *<y> == $row -> $b {
            @ranges = exclude(@ranges, $b<x> .. $b<x>);
            next ROW unless @ranges.elems;
        }

        say "row $row";
        say @ranges;
        say @ranges[0].min * 4000000 + $row;
        last ROW;
    }
}
