constant %dir_motion = L => (0, -1), R => (0, 1), U => (-1, 0), D => (1, 0);

my @start = (0, 0);
my @end = (0, 0);

my $visited = SetHash.new;
$visited.set(@end.raku);

for $*ARGFILES.IO.lines -> $line {
    $line ~~ /(<[LRUD]>) ' ' (\d+)/ or die "huh? $line";
    my ($dir, $steps) = $/.list;
    my @motion = %dir_motion{$dir};
    say "move { @motion.raku } $steps";
    for ^$steps {
        say "step";
        @start «+=» @motion;
        my @delta = @start «-» @end;
        my $distance = [max] @delta».abs;
        print "start pos { @start.raku } delta { @delta.raku } distance $distance";
        if $distance < 2 {
            say " => no move";
        } else {
            @delta = @delta».sign;
            @end «+=» @delta;
            say " => move end { @delta.raku } to { @end.raku }";
            $visited.set(@end.raku);
        }
    }
}

say $visited;
say $visited.elems;
