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
# do some stuff in here still wip todo
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

# setup route on localhost
# view current chain and send transactions
route("/send") do
  response = HTTP.request("POST", "http://localhost:8000/transactions/new", [("content-type", "application-json")], """{"sender:""rainbow","recipient:"foo", "amount:1}""")
  
  # format body output
  response.body |> String |> JSON
end

# run the server
Genie.startup(async = false)
