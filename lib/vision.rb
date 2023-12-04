require 'base64'
require 'json'
require 'net/https'

module Vision
  class << self
    def image_analysis(image_file)
      api_url="https://vision.googleapis.com/v1/images:annotate?key=#{ENV['GOOGLE_API_KEY']}"
      base64_image = Base64.encode64(image_file.tempfile.read)

      params = {
        requests: [{
          image: {
            content: base64_image
          },
          features: [
            {
              type: 'SAFE_SEARCH_DETECTION'
            }
          ]
        }]
      }.to_json

      uri = URI.parse(api_url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      request['Content-Type'] = 'application/json'
      response = https.request(request, params)
      response_body = JSON.parse(response.body)

      if (error = response_body['responses'][0]['error']).present?
        raise error['message']
      else
        result_arr = response_body["responses"].flatten.map do |parsed_image|
          parsed_image["safeSearchAnnotation"].values
        end.flatten
        if result_arr.include?("LIKELY") || result_arr.include?("VERY_LIKELY")
          false
        else
          true
        end
      end
    end
  end
end