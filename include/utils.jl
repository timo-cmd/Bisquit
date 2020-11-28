using Dates

struct Transaction
  sender::String
  recipient::String
  amount::Int
end

struct Block
  index::Int
  timestamp::Dates.DateTime
  transaction::Array{Transaction}
  proof::Int
  previous_hash::String
end

mutable struct blockchain 
  chain::Array{Block}
  current_transaction::Array{Transaction}
end
