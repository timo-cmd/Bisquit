using Bisquit
using Genie, Genie.Router, Genie.Renderer.Json, Genie.Requests
using HTTP
using UUIDs

import JSON

# initialize an unique id for the new node instance
node_identifier = uuid4( ) |> string 

# initialize a genesis block at startup
blockchain = create_genesis( )

# setup route adress on localhost
route("/mine") do
  # define some utiled variables
  last_block = blockchain.chain[ end ]
  last_proof = last_block.proof
  proof = proof_of_work( last_proof )  

  # after finding the proof we'll get a reward
  # "0" to identify that the current node has mined a new block
  new_transaction( blockchain, "0", node_identifier, 1 )

  previous_hash = Bisquit.hash( last_block )
  block = Bisquit.new_block

  response = Dict( 
    "message"=> "Mined new Block",
    "index"=> block.index,
    "transactions"=> block.transactions,
    "proof"=> block.proof,
    "previous_hash"=> block.previous_hash,
  )
  json( response )
end

# setup route adress on localhost
# view the current chain transaction 
route("/chain") do
  response = Dict( 
    "chain" => blockchain.chain,
    "length" => length(blockchain.chain)
  )
 
  # format the output
  response |> JSON.json
end

route("/transactions/new", method = POST) do 
  # starting the json request
  data = jsonpayload( )

  # show the current sha256 key for following objects
  print( keys( data ) )

  # add array to the requested keys 
  requested_keys = [ "sender", "recipient", "amount" ]

  # check if the current transaction contains the required keys. If not do: give a shoutout error message
  if !( length( keys( data ) ) == length( requested_keys ) && all( k -> in( k, requested_keys ), keys( data ) ) )
    # format the error message in json format
    "Missing valuess" |> json
  end

  # initialize a new transaction
  index = new_transaction( blockchain, data[ "sender" ], data[ "recipipient" ], data[ "amount" ])

  # shout out the success message and format in json
  response = Dict("message" => "Transaction is beeing added to Block $index")
  json( response ) 
end

# setup route on localhost
# view current chain and send transactions
route("/send") do
  response = HTTP.request("POST", "http://localhost:8000/transactions/new", [("Content-Type", "application/json")], """{"sender":"hello", "recipient":"thanks", "amount":1}""")
  
  # format body output
  response.body |> String |> JSON
end

# run the server
Genie.startup(async = false)
