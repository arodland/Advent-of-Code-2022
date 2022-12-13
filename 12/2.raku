my @m = $*ARGFILES.IO.lines».comb».Array;
my @rc = @m.keys X @m[0].keys;
my (@start, @dests);
my $desthash = SetHash.new;

for @rc -> ($r, $c) {
    if @m[$r][$c] eq 'S' {
        @m[$r][$c] = 'a';
    } elsif @m[$r][$c] eq 'E' {
        @m[$r][$c] = 'z';
        @start = [$r, $c];
    }
    @m[$r][$c] = ord(@m[$r][$c]) - ord('a');
    if @m[$r][$c] == 0 {
        @dests.push: $[$r, $c];
        $desthash{"$r;$c"} = True;
    }
}

say $desthash;

my $visited = SetHash.new;
my %minsteps;

my @queue = $%( :pos(@start), :steps(0), :score(0) );

while @queue {
    my $q = @queue.shift;
    my ($r, $c) = $q<pos>;

    $visited{$q<pos>} = True;
    my $height = @m[$r][$c];
    if $desthash{"$r;$c"} {
        say "$q<steps> to [$r, $c]";
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
        next if $hh < $height - 1;
        my @destdists = @dests.map: { @$p «-» @$_ }
        my @manhattans = @destdists.map: { [+] @$_».abs };
        my $manhattan = @manhattans.min;
        my $entry = $%( :pos($p), :steps($q<steps> + 1), :score(-2 * $hh - $manhattan - $q<steps>) );
        say $entry;
        @queue.push($entry);
        %minsteps{$p.gist} = $entry<steps>;
    }
    @queue = @queue.sort(*<score>).reverse;
}
