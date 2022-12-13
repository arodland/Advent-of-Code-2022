use lib '.';
use AOC13;

my $idx = 0;
my $isum = 0;
for $*ARGFILES.IO.lines.rotor(3, :partial) -> ($one is copy, $two is copy, $ = Nil) {
    $one = List.parse($one, actions => ListBuilder).made;
    $two = List.parse($two, actions => ListBuilder).made;
    my $cmp = lcmp($one, $two);
    say "Compare: $cmp";
    $idx++;
    $isum += $idx if $cmp ~~ Less;
}

say "Idx sum: $isum";
