class CGI
  HTTP_PORT = 80
  HTTPS_PORT = 443

  # Returns a full uri for a given uri fragment.
  # full_uri_for 'foo.cgi' => 'http://localhost/dir/foo.cgi'
  # full_uri_for '/images/' => 'http://localhost/images/'
  def full_uri_for(fragment)
    case fragment
    when /^http:\/\//
      # The fragment is a complete URI
      fragment
    when /^\//
      # The fragment is relative to the root of this host
      host_uri + fragment
    else
      # The fragment is relative to this directory
      relative_uri + fragment
    end
  end

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
    host_uri.chop + script_name
  end

end
