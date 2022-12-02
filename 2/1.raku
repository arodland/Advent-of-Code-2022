constant %map = :A(1), :B(2), :C(3), :X(1), :Y(2), :Z(3);

say [+] $*ARGFILES.IO.lines.map: -> $line {
    $line ~~ /(<[ABC]>) \s+ (<[XYZ]>)/ or die "huh? $line";
    my ($opp, $response) = ($0, $1);
    my ($oppscore, $myscore) = %map{$opp, $response};
    my $winscore = $oppscore == $myscore ?? 3 !!
                ($myscore - $oppscore) % 3 == 1 ?? 6 !! 0;
    my $score = $myscore + $winscore;
    say "$line  $myscore + $winscore = $score";
    $score;
}
