sub manhattan ($x1, $y1, $x2, $y2) {
    abs($x1 - $x2) + abs($y1 - $y2)
}

my %excluded;
my %beacons;

sub MAIN(Str $file, Int $row) {
    for $file.IO.lines {
        /'Sensor at x=' (<[\d-]>+) ', y=' (<[\d-]>+) ': closest beacon is at x=' (<[\d-]>+) ', y=' (<[\d-]>+)/;
        my ($sx, $sy, $bx, $by) = $/.list».Int;

        %beacons{$bx} = True if $by == $row;

        my $dist = manhattan($sx, $sy, $bx, $by);

        print "Sensor $sx,$sy -> $bx,$by dist=$dist. ";

        $dist = ($dist - abs($sy - $row));
        print "Modified dist $dist ";
        if $dist > 0 {
            say "Excluding {$sx-$dist},10 .. {$sx+$dist},10";
            for $sx - $dist .. $sx + $dist -> $x {
                %excluded{$x} = True;
            }
        } else {
            say "No exclusion.";
        }
    }

    %excluded{$_}:delete for %beacons.keys;
    say %excluded.elems;
}
