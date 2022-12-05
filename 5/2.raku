my @stacks;

for $*ARGFILES.IO.lines -> $line {
    if $line ~~ /'['/ {
        my $num = ($line.chars + 1) / 4;
        for ^$num -> $st {
            my $cr = $line.substr($st * 4 + 1, 1);
            @stacks[$st].unshift($cr) unless $cr eq ' ';
        }
    } elsif $line ~~ /'move ' (\d+) ' from ' (\d+) ' to ' (\d+)/ {
        my ($count, $source, $dest) = ($0, $1, $2);
        @stacks[$dest - 1].push: |@stacks[$source - 1].splice(* - $count);
    }
}

say @stacks».[*-1].join;
