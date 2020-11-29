module Bisquit

    # export all local vars from this module
    export Transaction, Blockchain, Block
    export new_transaction, new_block, create_genesis, hash, valid_proof, proof_of_work, last_block

    # include some utils here...
    # seems to be pretty instable
    # include("./include/utils.jl")

    # include some utils for chaining and formats
    using SHA # sha256bit for hashing
    using JSON # json for formatted output
    using Dates # Dates for tamestamp

    struct Transaction
        sender::String
        recipient::String
        amount::Int
    end

    struct Block
        index::Int
        timestamp::Dates.DateTime
        transactions::Array{Transaction}
        proof::Int
        previous_hash::String
    end

    mutable struct  Blockchain
        chain::Array{Block}
        current_transactions::Array{Transaction}
    end


    function new_transaction( blockchain::Blockchain, sender::String, recipient::String, amount::Int, )::int
    # add some values in here wip todo
    transaction = Transaction( sender, recipient, amount )
    push!( blockchain.current_transactions, transaction )
    return blockchain.chain[ end ].index + 1
    end

    function new_block( blockchain::Blockchain, proof::Int, previous_hash::String)::Block
        block = Block( blockchain.chain[ end ].index + 1, Dates.now( ), blockchain.current_transactions, proof, previous_hash )
        blockchain.current_transactions = [ ]
        push!( blockchain.chain, block )
        return block
    end

    function create_genesis( )::Block
        # " 0 " is set to 0 to vaildate if the current node hasn't already mined blocks
        genesis = Block(1, Dates.now( ), [], 100, "0" )
        blockchain = Blockchain( [ genesis ], [ ] )
        return blockchain
    end

    function hash(block::Block)::String

        # set list of block_string to all strings in bisquit and generate a sha256hash
        block_string = string( block.index, block.timestamp, block.transactions, block.proof, block.previous_hash )
        return bytes2hex( sha256( block_string ) )
    end

    function valid_proof(last_proof::Int, proof::Int)::Bool
        guess = "$last_proof$proof"    
        guess_hash = bytes2hex( sha256( guess ) )

        # set the nonce value to 4layered 0000 
        return guess_hash[ end - 3 : end ] == "0000"
    end

    function proof_of_work( last_proof::Int )::Int
        proof = 0

        # if proof is neg int
        if last_proof < 0
            print("Method error occured!")
        end

        # while proof == 0 add 1 recursively
        while valid_proof( last_proof, proof ) == 0
            proof += 1
        end

        return proof
    end

    function last_block( blockchain::Blockchain)::Block
        return blockchain.chain[ end ]
    end
end
