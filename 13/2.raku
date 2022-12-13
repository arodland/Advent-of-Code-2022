use lib '.';
use AOC13;

my $div1 = [[2],];
my $div2 = [[6],];
my @packets = [$div1, $div2];

for $*ARGFILES.IO.lines.rotor(3, :partial) -> ($one is copy, $two is copy, $ = Nil) {
    @packets.push: List.parse($one, actions => ListBuilder).made;
    @packets.push: List.parse($two, actions => ListBuilder).made;
}

@packets = @packets.sort: &lcmp;
my $d1i = @packets.first: $div1, :k;
my $d2i = @packets.first: $div2, :k;

say ($d1i+1) * ($d2i+1);
