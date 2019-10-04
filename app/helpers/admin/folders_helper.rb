module Admin::FoldersHelper
  def file_exist? url
    uri = URI(url)

    request = Net::HTTP.new uri.host
    response= request.request_head uri.path
    return response.code.to_i == 200
  end
end
