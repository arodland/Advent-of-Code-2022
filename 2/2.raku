constant %map = :A(1), :B(2), :C(3), :X(-1), :Y(0), :Z(1);

say [+] $*ARGFILES.IO.lines.map: -> $line {
    $line ~~ /(<[ABC]>) \s+ (<[XYZ]>)/ or die "huh? $line";
    my ($opp, $response) = ($0, $1);
    my ($oppscore, $delta) = %map{$opp, $response};
    my $winscore = $delta * 3 + 3;
    my $myscore = ($oppscore + $delta - 1) % 3 + 1;
    my $score = $myscore + $winscore;
    say "$line $myscore + $winscore = $score";
    $score;
}
