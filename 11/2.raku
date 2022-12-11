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
            say "Inspecting item $item";
            $.inspected++;
            $item = $.operation.evaluate($item);
            say "Worry level becomes $item";
            $item = $item % $lcm;
            say "Mod $lcm becomes $item";
            my $target;
            if ($item %% $.divisor) {
                say "Divisible by $.divisor";
                $target = @.targets[1];
            } else {
                say "Not divisible by $.divisor";
                $target = @.targets[0];
            }
            say "Thrown to monkey $target";
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
    say "Round $round";
    for @monkeys.keys -> $m {
        say "Monkey { $m + 1 }";
        @monkeys[$m].do_round();
    }

    say "Inventory:";
    for @monkeys.keys -> $m {
        say "Monkey $m: { @monkeys[$m].items.join(", ") }"
    }
    print "\n";
}

my @sorted = @monkeys.sort: { $^b.inspected <=> $^a.inspected }
say @sorted[0].inspected * @sorted[1].inspected;
