my @stacks;

for $*ARGFILES.IO.lines -> $line {
    if $line ~~ /'['/ {
        for $line.comb.rotor(4, :partial)».[1].kv -> $st, $cr {
            @stacks[$st].unshift($cr) unless $cr eq ' ';
        }
    } elsif $line ~~ /'move ' (\d+) ' from ' (\d+) ' to ' (\d+)/ {
        my ($count, $source, $dest) = $/.list;
        @stacks[$dest - 1].push: |@stacks[$source - 1].splice(* - $count);
    }
}

say @stacks».[*-1].join;
