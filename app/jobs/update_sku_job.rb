class UpdateSkuJob < ApplicationJob
  queue_as :default

  def perform(book_name)
    uri = URI('http://localhost:4567/update_sku') # simulate external API call
    Net::HTTP.post(uri) # => String
    req.body = (sku = '123', name: book_params[:name]).to_json)
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
  end
end
