say [+] $*ARGFILES.IO.lines.rotor(3).map: -> @lines {
    my @sets = @lines.map: *.comb.SetHash;
    my $common = ([(&)] @sets).keys[0];
    my $prio = $common ~~ 'a' .. 'z' ?? ord($common) - ord('a') + 1 !! ord($common) - ord('A') + 27;
    $prio;
}
