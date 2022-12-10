constant %dir_motion = L => (0, -1), R => (0, 1), U => (-1, 0), D => (1, 0);

my @pos = [0, 0] xx 10;

my $visited = SetHash.new;
$visited.set(|@pos[*-1].raku);

for $*ARGFILES.IO.lines -> $line {
    $line ~~ /(<[LRUD]>) ' ' (\d+)/ or die "huh? $line";
    my ($dir, $steps) = $/.list;
    my @motion = %dir_motion{$dir};
#    say "move { @motion.raku } $steps";
    for ^$steps {
#       say "step";
        |@pos[0] «+=» @motion;
        for 1..9 -> $knot {
            my @delta = |@pos[$knot-1] «-» |@pos[$knot];
            my $distance = [max] @delta».abs;
#           print "knot $knot pos { @pos[$knot].raku } delta { @delta.raku } distance $distance";
            if $distance < 2 {
#               say " => no move";
            } else {
                @delta = @delta».sign;
                @pos[$knot] «+=» @delta;
#               say " => move { @delta.raku } to { @pos[$knot].raku }";
            }
        }
        $visited.set(|@pos[*-1].raku);
    }
}

say $visited.elems;
