class CGI
  HTTP_PORT = 80
  HTTPS_PORT = 443
 
  # Try to guess the uri for the host alone (http://host/)
  def host_uri
    uri = ''
    case server_port
    when HTTP_PORT
      uri << 'http://' + server_name
    when HTTPS_PORT
      uri << 'https://' + server_name
    else
      uri << 'https://' + server_name + ':' + server_port
    end
    uri
  end

  # Try to guess the relative path for this request. (http://host/directory/)
  def relative_uri
    uri.sub(/[^\/]*$/, '')
  end

  # Try to guess the full uri for this script (http://host/directory/script.cgi)
  def uri
    host_uri + script_name
  end

end
