my @m = $*ARGFILES.IO.lines».comb».Array;
my @rc = @m.keys X @m[0].keys;
my (@start, @dest);

for @rc -> ($r, $c) {
    if @m[$r][$c] eq 'S' {
        @m[$r][$c] = 'a';
        @start = [$r, $c];
    } elsif @m[$r][$c] eq 'E' {
        @m[$r][$c] = 'z';
        @dest = [$r, $c];
    }
    @m[$r][$c] = ord(@m[$r][$c]) - ord('a');
}

my $visited = SetHash.new;
my %minsteps;

my @queue = $%( :pos(@start), :steps(0), :score(0) );

say "dest: ", @dest;

while @queue {
    my $q = @queue.shift;
    my ($r, $c) = $q<pos>;

    $visited{$q<pos>} = True;
    my $height = @m[$r][$c];
    if $r == @dest[0] && $c == @dest[1] {
        say $q<steps>;
        last;
    }

    for [[$r-1, $c], [$r+1, $c], [$r, $c-1], [$r, $c+1]] -> ($rr, $cc) {
        next if $rr < 0;
        next if $rr >= @m.elems;
        next if $cc < 0;
        next if $cc >= @m[0].elems;
        my $p = [$rr, $cc];
        next if $visited{$p.gist};
        next if %minsteps{$p.gist}:exists and %minsteps{$p.gist} <= $q<steps> + 1;

        my $hh = @m[$rr][$cc];
        next if $hh > $height + 1;
        my @destdist = @$p «-» @dest;
        my $manhattan = [+] @destdist».abs;
        my $entry = $%( :pos($p), :steps($q<steps> + 1), :score(2 * $hh - $manhattan - $q<steps>) );
        say $entry;
        @queue.push($entry);
        %minsteps{$p.gist} = $entry<steps>;
    }
    @queue = @queue.sort(*<score>).reverse;
}
