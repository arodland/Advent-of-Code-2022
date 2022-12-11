my @monkeys;
my $lcm;

sub compile-routine(:$lhs, :$op, :$rhs) {
    use MONKEY-SEE-NO-EVAL;
    my $code = '-> Int $old { (';
    $code ~= $lhs eq 'old' ?? '$old' !! $lhs.Int.raku;
    if $op eq '+' || $op eq '*' {
        $code ~= $op;
    } else {
        die "unknown op $op";
    }
    $code ~= $rhs eq 'old' ?? '$old' !! $rhs.Int.raku;
    $code ~= ') % $lcm }';
    return EVAL $code;
}

class Monkey {
    has @.items is rw;
    has $.operation is rw;
    has $.divisor is rw;
    has @.targets is rw;
    has $.inspected is rw = 0;

    method parse_operation(Str $op) {
        $op ~~ /'new = ' ('old' | \d+) \s+ ('*' | '+') \s+ ('old' | \d+)/ or die "bad op: $op";
        $.operation = compile-routine(lhs => $0.Str, op => $1.Str, rhs => $2.Str);
    }

    method do_round {
        for @.items -> $item is copy {
            $.inspected++;
            $item = $.operation.($item);
            my $target;
            $target = @.targets[ $item %% $.divisor ];
            @monkeys[$target].items.push: $item;
        }
        @.items = ();
    }
}

my $i;
for $*ARGFILES.lines {
    when /^ 'Monkey ' (\d+)/ {
        $i = $0.Int;
        @monkeys[$i] = Monkey.new;
    }
    when /'Starting items: ' (.*)/ {
        @monkeys[$i].items = $0.split(/', '/)».Int;
    }
    when /'Operation: ' (.*)/ {
        @monkeys[$i].parse_operation($0.Str);
    }
    when /'Test: divisible by ' (\d+)/ {
        @monkeys[$i].divisor = $0.Int;
    }
    when /'If true: throw to monkey ' (\d+)/ {
        @monkeys[$i].targets[1] = $0.Int;
    }
    when /'If false: throw to monkey ' (\d+)/ {
        @monkeys[$i].targets[0] = $0.Int;
    }
    when /^$/ {
    }

    default {
        die "Bad line: $_";
    }
}

my @divisors = @monkeys».divisor;
$lcm = [lcm] @divisors;

for 1..10000 -> $round {
    for @monkeys.keys -> $m {
        @monkeys[$m].do_round();
    }
}

my @sorted = @monkeys.sort: { $^b.inspected <=> $^a.inspected }
say @sorted[0].inspected * @sorted[1].inspected;
