say [+] $*ARGFILES.IO.lines.map: -> $line {
    my $len = $line.chars;
    my $h1 = $line.substr(0, $len/2).comb.SetHash;
    my $h2 = $line.substr($len/2).comb.SetHash;
    my $common = ($h1 (&) $h2).keys[0];
    my $prio = $common ~~ 'a' .. 'z' ?? ord($common) - ord('a') + 1 !! ord($common) - ord('A') + 27;
    $prio;
}
