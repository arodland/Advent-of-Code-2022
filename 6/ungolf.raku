say (
    $*ARGFILES.get.comb                 # Read one line of input, and split to characters
    .rotor(4 => -3)                     # Get all overlapping runs of four characters
    .first: *.SetHash.elems == 4, :k    # First index such that all four are unique
                                        # (a set built from them has four elements)
) + 4;                                  # Add 4 to get the index of the *end* of the run, and make it 1-based.
