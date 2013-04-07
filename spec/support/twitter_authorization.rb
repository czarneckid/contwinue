TwitterCredentials = Struct.new(:token, :secret)
TwitterInfo = Struct.new(:name, :nickname)
TwitterAuth = Struct.new(:uid, :info, :credentials)