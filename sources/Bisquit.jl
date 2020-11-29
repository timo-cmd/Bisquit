module Bisquit

# export all local vars from this module
export Transaction, Blockchain, Block
export new_transaction, new_block, create_genesis, hash, valid_proof, proof_of_work, last_block

# include some utils here...
include("../include/utils.jl")

# include some utils for chaining and formats
using SHA # sha256bit for hashing
using JSON # json for formatted output

function new_transaction( blockchain::Blockchain, sender::String, recipient::String, amount::Int, )::int
  # add some values in here wip todo
  transaction = Transaction( sender, recipient, amount )
  push!( blockchain.current_transactions, transaction )
  return blockchain.chain[ end ].index + 1
end
