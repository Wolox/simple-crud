module Response
  module JSONParser
    def response_body
      JSON.parse(response.body)
    end
  end
end
