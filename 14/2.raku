my %map = SetHash.new;
my $max_y = 0;

for $*ARGFILES.IO.lines {
    my %prev;

    /[ $<x>=[\d+] ',' $<y>=[\d+] ] + % ' -> ' / or die "huh? $_";

    for $<x>.keys -> $i {
        my %pos = :x($<x>[$i].Int), :y($<y>[$i].Int);
        $max_y = %pos<y> if %pos<y> > $max_y;

        if %prev.elems {
            for %prev<x> ... %pos<x> -> $xx {
                for %prev<y> ... %pos<y> -> $yy {
                    %map{"$xx,$yy"} = True;
                }
            }
        }

        %prev = %pos;
    }
}

ROUND: for 1...* -> $round {
    my ($x, $y) = (500, 0);
    FALL: loop {
        my $yy = $y+1;
        for ($x, $x-1, $x+1) -> $xx {
            if !%map{"$xx,$yy"} && $yy < $max_y + 2 {
                ($x, $y) = ($xx,$yy);
                next FALL;
            }
        }
        %map{"$x,$y"} = True;
        say "Came to rest at $x,$y";
        if $y == 0 {
            say "round $round";
            last ROUND;
        }
        last FALL;
    }
}

