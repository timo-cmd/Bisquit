module Bisquit

# export all local vars from this module
export Transaction, Blockchain, Block
export new_transaction, new_block, create_genesis, hash, valid_proof, proof_of_work, last_block

# include some utils here...
using SHA # sha256bit for hashing
using JSON # json for formatted output

function new_transaction( )::int
# add some values in here wip todo
end
