my @monkeys;
my $lcm;

class Op {
    has $.lhs;
    has $.op;
    has $.rhs;

    method evaluate (Int $old) {
        my $lv = $.lhs eq 'old' ?? $old !! $.lhs.Int;
        my $rv = $.rhs eq 'old' ?? $old !! $.rhs.Int;
        given $.op {
            when '+' {
                return $lv + $rv;
            }
            when '*' {
                return $lv * $rv;
            }
            default {
                die "Unknown op $.op";
            }
        }
    }
}

class Monkey {
    has @.items is rw;
    has $.operation is rw;
    has $.divisor is rw;
    has @.targets is rw;
    has $.inspected is rw = 0;

    method parse_operation(Str $op) {
        $op ~~ /'new = ' ('old' | \d+) \s+ ('*' | '+') \s+ ('old' | \d+)/ or die "bad op: $op";
        $.operation = Op.new(lhs => $0.Str, op => $1.Str, rhs => $2.Str);
    }

    method do_round {
        for @.items -> $item is copy {
            $.inspected++;
            $item = $.operation.evaluate($item);
            $item = $item % $lcm;
            my $target;
            if ($item %% $.divisor) {
                $target = @.targets[1];
            } else {
                $target = @.targets[0];
            }
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
